import express from "express";
import authorize from "../middleware/authorization.js";
import upload from "../middleware/multer.js";
import {
  changePassword,
  editAccount,
  addProfilePicture,
  deleteProfilePicture,
} from "../controllers/userController.js";

const router = express.Router();

router.put("/edit-acc", authorize, editAccount);
router.put("/change-password", authorize, changePassword);

router.post(
  "/profile-pic",
  authorize,
  upload.single("profilePic"),
  addProfilePicture
);
router.delete("/profile-pic", authorize, deleteProfilePicture);
export default router;
