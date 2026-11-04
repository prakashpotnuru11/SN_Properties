
import express from "express";
import cors from "cors";
import { testDatabaseConnection } from "./db.js";

const app = express();
const PORT = process.env.PORT || 5000;

// Middleware
app.use(cors());
app.use(express.json());

// Health check API
app.get("/api/health", (_req, res) => {
  res.status(200).json({
    status: "success",
    message: "SN PROPERTIES API is running",
    timestamp: new Date().toISOString(),
  });
});

// Start server
// Start server after checking database connection
async function startServer() {
  try {
    await testDatabaseConnection();

    app.listen(PORT, () => {
      console.log(`SN PROPERTIES API running on port ${PORT}`);
    });
  } catch (error) {
    console.error("Database connection failed:", error);
    process.exit(1);
  }
}

startServer();
