import express from "express";
import { sendMessage } from "../controllers/messageController.js";
import authorize from "../middleware/authorization.js";

const router = express.Router();

router.post("/send/:id", authorize, sendMessage);

export default router;
