import User from "../models/userModel.js";
import bcrypt from "bcryptjs";

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
