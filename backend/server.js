import express from "express";
import dotenv from "dotenv";
import cookieParser from "cookie-parser";

import authRoutes from "./routes/authRoutes.js";
import userRoutes from "./routes/userRoutes.js";
import messageRoutes from "./routes/messageRoutes.js";
import postsRoutes from "./routes/postsRoutes.js";
import stripeRoutes from "./routes/stripeRoutes.js";

import connectToMongoDB from "./database/connectToMongoDB.js";
import { app, server } from "./socket/socket.js";

dotenv.config();

const port = process.env.PORT || 5001;

app.use(express.json());
app.use(cookieParser());

app.use("/api/auth", authRoutes);
app.use("/api/user", userRoutes);
app.use("/api/messages", messageRoutes);
app.use("/api/posts", postsRoutes);
app.use("/api/stripe", stripeRoutes);

server.listen(port, () => {
  connectToMongoDB();
  console.log(`Server is running on port ${port}`);
});
