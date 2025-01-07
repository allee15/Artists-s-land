import express from "express";
import authorize from "../middleware/authorization.js";
import upload, { postUpload } from "../middleware/multer.js";
import {
  changePassword,
  getUsers,
  editAccount,
  addProfilePicture,
  deleteProfilePicture,
  deleteAccount,
  getUser,
  getSelectedUser,
  getSelectedUserPosts,
  getUserPosts,
  addPost,
  deletePost,
  likePost,
  addComment,
  deleteLikePost
} from "../controllers/userController.js";

const router = express.Router();

router.get("/get-user", authorize, getUser);
router.get("/get-user-posts", authorize, getUserPosts);
router.get("/get-user/:id", authorize, getSelectedUser);
router.get("/get-user/posts/:id", authorize, getSelectedUserPosts)
router.get("/get-users", authorize, getUsers);
router.put("/edit-acc", authorize, editAccount);
router.put("/change-password", authorize, changePassword);

router.post("/profile-pic", authorize, upload, addProfilePicture);
router.delete("/profile-pic", authorize, deleteProfilePicture);
router.post("/add-post", authorize, postUpload, addPost);
router.delete("/delete-post/:id", authorize, deletePost);
router.delete("/delete-account", authorize, deleteAccount);

router.post("/like-post/:id", authorize, likePost);
router.post("/add-comment-post/:id", authorize, addComment);
router.delete("/delete-like-post/:id", authorize, deleteLikePost);
export default router;
