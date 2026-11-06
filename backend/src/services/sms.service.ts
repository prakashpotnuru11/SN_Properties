
import axios from "axios";

interface ApitxtResponse {
  status?: string;
  message?: string;
  data?: {
    request_id?: string;
    mobile?: string;
    cost?: number;
  };
}

export async function sendOtpSms(
  mobileNumber: string,
  otp: string
): Promise<ApitxtResponse> {
  const authKey = process.env.APITXT_AUTH_KEY;

  if (!authKey) {
    throw new Error("APITXT_AUTH_KEY is not configured");
  }

  const payload = new URLSearchParams({
    authkey: authKey,
    mobile: mobileNumber,
    otp,
    channel: process.env.APITXT_CHANNEL || "sms",
    country: process.env.APITXT_COUNTRY || "91",
  });

  const response = await axios.post<ApitxtResponse>(
    "https://apitxt.com/api/sendOTP",
    payload.toString(),
    {
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      timeout: 15000,
    }
  );

  if (response.data.status?.toLowerCase() !== "success") {
    throw new Error("APITXT could not accept the OTP request");
  }

  return response.data;
}
