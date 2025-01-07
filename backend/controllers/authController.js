import User from "../models/userModel.js";
import bcrypt from "bcryptjs";
import speakeasy from "speakeasy";
import qrcode from "qrcode";
import generateTokenAndSetCookie from "../utils/generateToken.js";

export const register = async (req, res) => {
  try {
    const { username, accType, email, password } = req.body;
    const user = await User.findOne({ username });
    if (user) {
      return res.status(400).json({ error: "Username already exists." });
    }

    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    const secret = speakeasy.generateSecret({ length: 20 });

    const newUser = new User({
      username,
      accType,
      email,
      password: hashedPassword,
      twoFactorSecret: secret.base32,
      twoFactorEnabled: true,
    });
    if (newUser) {
      const token = generateTokenAndSetCookie(newUser._id, res);
      await newUser.save();

      qrcode.toDataURL(secret.otpauth_url, (err, data_url) => {
        if (err) {
          return res.status(500).json({ error: "Error generating QR code" });
        }
        res.status(201).json({
          _id: newUser._id,
          username: newUser.username,
          accType: newUser.accType,
          email: newUser.email,
          token: token,
          qr_code: data_url,
        });
      });
    } else {
      res.status(400).json({ error: "Invalid user data" });
    }
  } catch (error) {
    console.log("Error in signup controller.", error.message);
    res.status(500).json({ error: "Internal server error." });
  }
};

export const login = async (req, res) => {
  try {
    const { email, password, verificationToken } = req.body;
    const user = await User.findOne({ email });
    const isPasswordCorrect = await bcrypt.compare(
      password,
      user?.password || ""
    );

    if (!user || !isPasswordCorrect) {
      return res.status(400).json({ error: "Invalid credentials" });
    }
    if (user.twoFactorEnabled) {
      const isVerified = speakeasy.totp.verify({
        secret: user.twoFactorSecret,
        encoding: "base32",
        verificationToken,
      });

      if (!isVerified) {
        return res.status(400).json({ error: "Invalid 2FA token" });
      }
    }
    const token = generateTokenAndSetCookie(user._id, res);

    res.status(200).json({
      _id: user._id,
      username: user.username,
      accType: user.accType,
      email: user.email,
      profilePic: user.profilePic,
      token: token,
    });
  } catch (error) {
    console.log("Error in login controller.");
    res.status(500).json({ error: "Internal Server Error." });
  }
};

export const logout = async (req, res) => {
  try {
    res.cookie("jwt", "", { maxAge: 0 });
    res.status(200).json({ message: "Logged out succesfully" });
  } catch (error) {
    console.log("Error in logout controller", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
export const enable2FA = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (user.twoFactorEnabled) {
      return res.status(400).json({ error: "2FA is already enabled" });
    }

    user.twoFactorEnabled = true;
    await user.save();

    res.status(200).json({ message: "2FA enabled successfully!" });
  } catch (error) {
    console.log("Error in enable 2FA controller.");
    res.status(500).json({ error: "Internal Server Error." });
  }
};
export const disable2FA = async (req, res) => {
  try {
    const user = await User.findById(req.user.id);

    if (!user.twoFactorEnabled) {
      return res.status(400).json({ error: "2FA is not enabled" });
    }

    user.twoFactorEnabled = false;
    user.twoFactorSecret = null;
    await user.save();

    res.status(200).json({ message: "2FA disabled successfully!" });
  } catch (error) {
    console.log("Error in disable 2FA controller.");
    res.status(500).json({ error: "Internal Server Error." });
  }
};
