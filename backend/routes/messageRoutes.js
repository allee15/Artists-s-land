import express from "express";
import { sendMessage, getMessages } from "../controllers/messageController.js";
import authorize from "../middleware/authorization.js";
import upload from "../middleware/multer-messages.js";
const router = express.Router();

router.get("/receive/:id", authorize, getMessages);
router.post("/send/:id", authorize, upload, sendMessage);
export default router;
