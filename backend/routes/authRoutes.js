import express from "express";
import {
  register,
  login,
  logout,
  enable2FA,
  disable2FA,
} from "../controllers/authController.js";

const router = express.Router();

router.post("/register", register);

router.post("/login", login);

router.post("/logout", logout);

router.post("/enable-2fa", enable2FA);

router.post("/disable-2fa", disable2FA);

export default router;
