import express from "express";
import authorize from "../middleware/authorization.js";
import { changePassword, editAccount } from "../controllers/userController.js";

const router = express.Router();

router.put("/edit-acc", authorize, editAccount);
router.put("/change-password", authorize, changePassword);

export default router;
