import User from "../models/userModel.js";
import bcrypt from "bcryptjs";
import fs from "fs";
import { fileURLToPath } from "url";
import path from "path";

export const getUsers = async (req, res) => {
  try {
    const loggedInUserId = req.user._id;
    const allUsers = await User.find({ _id: { $ne: loggedInUserId } });
    res.status(200).json(allUsers);
  } catch (error) {
    console.log("Error in getUsers controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const editAccount = async (req, res) => {
  try {
    const { username, email } = req.body;
    const user = await User.findById(req.user.id);

    if (username) user.username = username;
    if (email) user.email = email;

    await user.save();
    res.status(200).json({ message: "The account was edited succesfully" });
  } catch (error) {
    console.log("Error in editAccount controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const changePassword = async (req, res) => {
  try {
    const { currentPassword, newPassword, confirmNewPassword } = req.body;

    if (!currentPassword || !newPassword || !confirmNewPassword) {
      return res.status(400).json({
        message:
          "Please provide current password, new password and confirm new password",
      });
    }

    if (newPassword !== confirmNewPassword) {
      return res.status(400).json({
        message: "New Password and Confirm New Password should be the same",
      });
    }

    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ message: "User not found" });
    }
    const isMatch = await bcrypt.compare(currentPassword, user.password);

    if (!isMatch) {
      return res
        .status(400)
        .json({ message: "You introduced the wrong current password" });
    }

    const hashedPassword = await bcrypt.hash(newPassword, 10);
    user.password = hashedPassword;
    await user.save();
    res.status(200).json({ message: "The password was changed succesfully" });
  } catch (error) {
    console.log("Error in change password controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const addProfilePicture = async (req, res) => {
  console.log("File received:", req.file);
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.profilePic = req.file.path;
    await user.save();

    res.status(200).json({
      message: "Profile photo updated successfully",
      profilePic: user.profilePic,
    });
  } catch (error) {
    console.log("Error in Add Profile Picture controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const deleteProfilePicture = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    if (user.profilePic === "") {
      return res.status(400).json({ message: "No profile picture to delete" });
    }

    const filePath = path.join(
      __dirname,
      "..",
      "uploads",
      "profilePics",
      path.basename(user.profilePic)
    );

    console.log("File path: ", filePath);
    try {
      await fs.promises.access(filePath);
      await fs.promises.unlink(filePath);

      user.profilePic = "";
      await user.save();
      res.status(200).json({ message: "Profile picture deleted succesfully" });
    } catch (error) {
      console.log("Error deleting file", error);
      return res
        .status(400)
        .json({ error: "File does not exist or error deleting" });
    }
  } catch (error) {
    console.log("Error in deleteProfilePicture controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const deleteAccount = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }
    if (user.profilePic) {
      const filePath = path.join(
        __dirname,
        "..",
        "uploads",
        "profilePics",
        path.basename(user.profilePic)
      );
      try {
        await fs.promises.access(filePath);
        await fs.promises.unlink(filePath);
      } catch (error) {
        console.log("Error deleting profile picture", error);
      }
    }
    await User.findByIdAndDelete(req.user.id);
    res.status(200).json({ message: "Account deleted successfully" });
  } catch (error) {
    console.log("Error in deleteAccount controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
