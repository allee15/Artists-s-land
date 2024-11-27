import Conversation from "../models/conversationModel.js";
import Message from "../models/messageModel.js";
import { getReceiverSocketId } from "../socket/socket.js";
import { fileURLToPath } from "url";
import { dirname } from "path";
import fs from "fs";
import path from "path";

export const sendMessage = async (req, res) => {
  try {
    const { message } = req.body;
    const { id: receiverId } = req.params;
    const senderId = req.user._id;

    const fileUrl = req.file ? req.file.path : null;

    let conversation = await Conversation.findOne({
      participants: { $all: [senderId, receiverId] },
    });

    if (!conversation) {
      conversation = await Conversation.create({
        participants: [senderId, receiverId],
      });
    }

    const newMessage = new Message({
      senderId,
      receiverId,
      message: message || "",
      fileUrl: fileUrl || "",
    });

    if (newMessage) {
      conversation.messages.push(newMessage._id);
    }

    await conversation.save();
    await newMessage.save();

    const receiverSocketId = getReceiverSocketId(receiverId);
    if (receiverSocketId) {
      io.to(receiverSocketId).emit("newMessage", newMessage);
    }

    res.status(201).json(newMessage);
  } catch (error) {
    console.log("Error in sendMessage controller", error.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

export const getMessages = async (req, res) => {
  try {
    const { id: userToChatId } = req.params;
    const senderId = req.user._id;

    const conversation = await Conversation.findOne({
      participants: { $all: [senderId, userToChatId] },
    }).populate("messages");

    if (!conversation) return res.status(200).json([]);

    const messagesWithFiles = conversation.messages.map((msg) => {
      return {
        senderId: msg.senderId,
        receiverId: msg.receiverId,
        message: msg.message,
        fileUrl: msg.fileUrl || null,
        createdAt: msg.createdAt,
      };
    });

    res.status(200).json(messagesWithFiles);
  } catch (error) {
    console.log("Error in getMessages controller", error.message);
    res.status(500).json({ error: "Internal server error" });
  }
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = dirname(__filename);

export const deleteConversation = async (req, res) => {
  try {
    const { conversationId } = req.params;
    const userId = req.user._id;

    const conversation = await Conversation.findById(conversationId);
    if (!conversation) {
      return res.status(404).json({ error: "Conversation not found" });
    }

    if (!conversation.participants.includes(userId)) {
      return res
        .status(403)
        .json({ error: "You are not authorized to delete this conversation" });
    }

    for (let messageId of conversation.messages) {
      const message = await Message.findById(messageId);

      if (message && message.fileUrl) {
        console.log("File URL:", message.fileUrl);

        const filePath = path.join(
          __dirname,
          "..",
          "uploads",
          "pictures",
          path.basename(message.fileUrl)
        );

        console.log("File Path:", filePath);

        fs.stat(filePath, (err, stats) => {
          if (err) {
            console.log("File does not exist:", err);
          } else {
            console.log("File exists:", stats);
            fs.unlink(filePath, (err) => {
              if (err) {
                console.log("Failed to delete file", err);
              } else {
                console.log("File deleted");
              }
            });
          }
        });
      }

      await Message.findByIdAndDelete(messageId);
    }

    await Conversation.findByIdAndDelete(conversationId);

    res.status(200).json({
      message: "Conversation and associated messages deleted successfully",
    });
  } catch (error) {
    console.log("Error in deleteConversation controller", error.message);
    res.status(500).json({ error: "Internal server error" });
  }
};
