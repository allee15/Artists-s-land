import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";

import authRoutes from "./routes/authRoutes.js";
import connectToMongoDB from "./database/connectToMongoDB.js";

dotenv.config();

const port = process.env.PORT || 5000;
const app = express();

app.use(express.json());
app.use("/api/auth", authRoutes);
app.use("api/user");

app.listen(port, () => {
  connectToMongoDB();
  console.log(`Server is running on port ${port}`);
});
