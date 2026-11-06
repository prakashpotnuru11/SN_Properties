
import { Router } from "express";
import {
  requestOtp,
  verifyLoginOtp,
} from "../services/auth.service.js";
import jwt from "jsonwebtoken";

const router = Router();

// POST /api/auth/request-otp
router.post("/request-otp", async (req, res) => {
  try {
    const { mobileNumber } = req.body;

    if (typeof mobileNumber !== "string") {
      res.status(400).json({
        status: "error",
        message: "Mobile number is required",
      });
      return;
    }

    const result = await requestOtp(mobileNumber);

    res.status(200).json({
      status: "success",
      ...result,
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "Unable to request OTP";

    const statusCode = message.includes("limit reached") ? 429 : 400;

    res.status(statusCode).json({
      status: "error",
      message,
    });
  }
});

// POST /api/auth/verify-otp
router.post("/verify-otp", async (req, res) => {
  try {
    const { mobileNumber, otp } = req.body;

    if (
      typeof mobileNumber !== "string" ||
      typeof otp !== "string"
    ) {
      res.status(400).json({
        status: "error",
        message: "Mobile number and OTP are required",
      });
      return;
    }

    const user = await verifyLoginOtp(mobileNumber, otp);

    const jwtSecret = process.env.JWT_SECRET;

    if (!jwtSecret) {
      throw new Error("JWT_SECRET is not configured");
    }

    const token = jwt.sign(
      {
        sub: user.id,
        role: user.role,
      },
      jwtSecret,
      { expiresIn: "1h" }
    );

    res.status(200).json({
      status: "success",
      message: "Login successful",
      token,
      user,
    });
  } catch (error) {
    const message =
      error instanceof Error ? error.message : "OTP verification failed";

    res.status(401).json({
      status: "error",
      message,
    });
  }
});

export default router;
