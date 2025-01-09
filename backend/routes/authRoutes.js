import express from "express";
import authorize from "../middleware/authorization.js";
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

router.post("/enable-2fa", authorize, enable2FA);

router.post("/disable-2fa", authorize, disable2FA);

export default router;
