import express from "express";
import authorize from "../middleware/authorization.js";
import { editAccount } from "../controllers/userController.js";

const router = express.Router();

router.put("/edit-acc", authorize, editAccount);

export default router;
