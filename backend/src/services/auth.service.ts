
import { pool } from "../db.js";
import {
  generateOtp,
  hashOtp,
  verifyOtpHash,
} from "./otp.service.js";
import { sendOtpSms } from "./sms.service.js";

const OTP_EXPIRY_MINUTES = 5;
const MAX_OTP_REQUESTS_PER_MINUTE = 3;
const MAX_OTP_ATTEMPTS = 5;

function normalizeMobileNumber(mobileNumber: string): string {
  const digits = mobileNumber.replace(/\D/g, "");

  // Accept either a 10-digit Indian number or a 12-digit number
  // beginning with 91.
  const normalized =
    digits.length === 10
      ? `91${digits}`
      : digits.length === 12 && digits.startsWith("91")
        ? digits
        : "";

  if (!normalized) {
    throw new Error("Enter a valid 10-digit Indian mobile number");
  }

  return normalized;
}

export async function requestOtp(mobileNumber: string) {
  const mobile = normalizeMobileNumber(mobileNumber);

  // Enforce APITXT's documented limit of 3 requests per minute.
  const rateLimit = await pool.query(
    `SELECT COUNT(*)::int AS request_count
     FROM public.otp_verifications
     WHERE mobile_number = $1
       AND created_at > NOW() - INTERVAL '1 minute'`,
    [mobile]
  );

  if (rateLimit.rows[0].request_count >= MAX_OTP_REQUESTS_PER_MINUTE) {
    throw new Error("OTP request limit reached. Please try again after one minute.");
  }

  const otp = generateOtp();
  const otpHash = await hashOtp(otp);

  // Store the hashed OTP before contacting the SMS provider.
  const insertResult = await pool.query(
    `INSERT INTO public.otp_verifications
       (mobile_number, otp_hash, expires_at, delivery_status)
     VALUES ($1, $2, NOW() + ($3 * INTERVAL '1 minute'), 'pending')
     RETURNING id`,
    [mobile, otpHash, OTP_EXPIRY_MINUTES]
  );

  const otpId = insertResult.rows[0].id;

  try {
    const smsResult = await sendOtpSms(mobile, otp);

    await pool.query(
      `UPDATE public.otp_verifications
       SET delivery_status = 'sent'
       WHERE id = $1`,
      [otpId]
    );

    // Create an unverified buyer account if this is a new mobile number.
    await pool.query(
      `INSERT INTO public.users (mobile_number)
       VALUES ($1)
       ON CONFLICT (mobile_number) DO NOTHING`,
      [mobile]
    );

    return {
      message: "OTP request accepted by SMS provider",
      requestId: smsResult.data?.request_id ?? null,
      expiresInSeconds: OTP_EXPIRY_MINUTES * 60,
    };
  } catch {
    await pool.query(
      `UPDATE public.otp_verifications
       SET delivery_status = 'failed'
       WHERE id = $1`,
      [otpId]
    );

    throw new Error("Unable to send OTP. Please try again later.");
  }
}

export async function verifyLoginOtp(
  mobileNumber: string,
  enteredOtp: string
) {
  const mobile = normalizeMobileNumber(mobileNumber);

  if (!/^\d{6}$/.test(enteredOtp)) {
    throw new Error("Enter a valid six-digit OTP");
  }

  const client = await pool.connect();

  try {
    await client.query("BEGIN");

    // Lock the latest OTP record to prevent simultaneous verification.
    const otpResult = await client.query(
      `SELECT id, otp_hash, attempts
       FROM public.otp_verifications
       WHERE mobile_number = $1
         AND delivery_status = 'sent'
         AND verified_at IS NULL
         AND expires_at > NOW()
       ORDER BY created_at DESC
       LIMIT 1
       FOR UPDATE`,
      [mobile]
    );

    if (otpResult.rows.length === 0) {
      throw new Error("OTP is invalid or expired. Please request a new OTP.");
    }

    const otpRecord = otpResult.rows[0];

    if (otpRecord.attempts >= MAX_OTP_ATTEMPTS) {
      throw new Error("Too many incorrect attempts. Please request a new OTP.");
    }

    const isValid = await verifyOtpHash(enteredOtp, otpRecord.otp_hash);

    if (!isValid) {
      await client.query(
        `UPDATE public.otp_verifications
         SET attempts = attempts + 1
         WHERE id = $1`,
        [otpRecord.id]
      );

      await client.query("COMMIT");
      throw new Error("Incorrect OTP. Please try again.");
    }

    await client.query(
      `UPDATE public.otp_verifications
       SET verified_at = NOW()
       WHERE id = $1`,
      [otpRecord.id]
    );

    const userResult = await client.query(
      `UPDATE public.users
       SET is_verified = TRUE,
           updated_at = NOW()
       WHERE mobile_number = $1
       RETURNING id, mobile_number, full_name, role`,
      [mobile]
    );

    if (userResult.rows.length === 0) {
      throw new Error("User account was not found. Please request a new OTP.");
    }

    await client.query("COMMIT");

    return userResult.rows[0];
  } catch (error) {
    await client.query("ROLLBACK");
    throw error;
  } finally {
    client.release();
  }
}
