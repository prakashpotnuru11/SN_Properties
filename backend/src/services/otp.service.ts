import { randomInt } from "node:crypto";
import argon2 from "argon2";

// Generate a secure 6-digit OTP
export function generateOtp(): string {
  return randomInt(100000, 1000000).toString();
}

// Securely hash the OTP before storing it
export async function hashOtp(otp: string): Promise<string> {
  return argon2.hash(otp);
}

// Compare the entered OTP with the stored hash
export async function verifyOtpHash(
  enteredOtp: string,
  storedHash: string
): Promise<boolean> {
  return argon2.verify(storedHash, enteredOtp);
}