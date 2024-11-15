import User from "../models/userModel.js";

export const editAccount = async (req, res) => {
  try {
    const { username, email } = req.body;
    const user = await User.findById(req.user.id);

    if (username) user.username = username;
    if (email) user.email = email;

    await user.save();
    res.status(200).json({ message: "The account was edited succesfully" });
  } catch (error) {
    console.log("Error in editAccount function", error.message);
    res.status(500).json({ error: "Internal Server Error" });
  }
};
