import User from "../models/userModel.js";
import Post from "../models/postModel.js";
import bcrypt from "bcryptjs";
import fs from "fs";
import { fileURLToPath } from "url";
import path from "path";

export const getPosts = async (req, res) => {
  try {
    const posts = await Post.find()
      .populate({
        path: "comments",
        populate: {
          path: "userId",
          model: "User",
        },
      })
      .populate("artistId")
      .sort({
        "artistId.level": 1,
      });
    res.status(200).json(posts);
  } catch (error) {
    console.log("Error in getPosts", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const getUserPosts = async (req, res) => {
  try {
    const posts = await Post.find({ artistId: req.user.id }).populate({
      path: "comments",
      populate: {
        path: "userId",
        model: "User",
      },
    });
    res.status(200).json(posts);
  } catch (error) {
    console.log("Error in getUserPosts", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const getSelectedUserPosts = async (req, res) => {
  try {
    const { id } = req.params;
    const posts = await Post.find({ artistId: id }).populate({
      path: "comments",
      populate: {
        path: "userId",
        model: "User",
      },
    });
    res.status(200).json(posts);
  } catch (error) {
    console.log("Error in getSelectedUserPosts", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const addPost = async (req, res) => {
  console.log("File received:", req.file);
  try {
    if (!req.file) {
      return res.status(400).json({ message: "No file uploaded" });
    }

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    await Post.create({
      artistId: user.id,
      comments: [],
      createdAt: new Date(),
      description: req.body.description,
      likes: [],
      postUrl: req.file.path,
      updatedAt: new Date(),
    });

    res.status(200).json({
      message: "Post updated successfully",
    });
  } catch (error) {
    console.log("Error in add post controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);

export const deletePost = async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ error: "Post not found" });
    }

    if (post.postUrl === "") {
      return res.status(400).json({ message: "No post image to delete" });
    }

    const filePath = path.join(
      __dirname,
      "..",
      "uploads",
      "posts",
      path.basename(post.postUrl)
    );

    console.log("File path: ", filePath);
    try {
      await fs.promises.access(filePath);
      await fs.promises.unlink(filePath);

      await Post.deleteOne(post);
      res.status(200).json({ message: "Post deleted succesfully" });
    } catch (error) {
      console.log("Error deleting file", error);
      return res
        .status(400)
        .json({ error: "File does not exist or error deleting" });
    }
  } catch (error) {
    console.log("Error in deletePost controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const likePost = async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ error: "Post not found" });
    }

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const userIndex = post.likes.findIndex((l) => l === user.id);

    if (userIndex >= 0) {
      return res.status(204).json({ error: "User has already liked post" });
    }

    post.likes.push(user.id);
    await post.save();
    res.status(201).json({ message: "Post liked succesfully" });
  } catch (error) {
    console.log("Error in likePost controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const addComment = async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ error: "Post not found" });
    }

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    post.comments.push({ userId: user.id, message: req.body.message });
    await post.save();
    res.status(201).json({ message: "Commented on post succesfully" });
  } catch (error) {
    console.log("Error in addComment controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};

export const deleteLikePost = async (req, res) => {
  try {
    const post = await Post.findById(req.params.id);

    if (!post) {
      return res.status(404).json({ error: "Post not found" });
    }

    const user = await User.findById(req.user.id);

    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    const userIndex = post.likes.findIndex((l) => String(l) === user.id);

    if (userIndex === -1) {
      return res.status(204).json({ error: "User has already unliked post" });
    }

    post.likes.splice(userIndex, 1);
    await post.save();
    res.status(201).json({ message: "Post unliked succesfully" });
  } catch (error) {
    console.log("Error in deleteLikePost controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
