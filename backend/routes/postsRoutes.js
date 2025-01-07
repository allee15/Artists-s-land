import express from "express";
import authorize from "../middleware/authorization.js";
import upload, { postUpload } from "../middleware/multer.js";
import {
  getPosts,
  getSelectedUserPosts,
  getUserPosts,
  addPost,
  deletePost,
  likePost,
  addComment,
  deleteLikePost,
} from "../controllers/postsController.js";

const router = express.Router();

router.get("/get-posts", getPosts);
router.get("/get-user-posts", authorize, getUserPosts);
router.get("/get-user/posts/:id", authorize, getSelectedUserPosts);

router.post("/add-post", authorize, postUpload, addPost);
router.delete("/delete-post/:id", authorize, deletePost);

router.post("/like-post/:id", authorize, likePost);
router.post("/add-comment-post/:id", authorize, addComment);
router.delete("/delete-like-post/:id", authorize, deleteLikePost);

export default router;
