import Stripe from "stripe";
import User from "../models/userModel.js";

const stripe = new Stripe(String(process.env.STRIPE_SECRET));

export default stripe;

export const createPaymentIntent = async (req, res) => {
  const { amount, currency, userId } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: {
        enabled: true,
      },
    });

    const user = await User.findById(userId);
    if (!user) {
      return res.status(404).json({ error: "User not found" });
    }

    user.balance += amount / 100;

    const tokensBought = amount / 100;
    const levelPointsGained = Math.floor(tokensBought / 5) * 10;

    user.levelPoints = (user.levelPoints || 0) + levelPointsGained;

    if (user.levelPoints >= 50) {
      user.level += 1;
      user.levelPoints -= 50;
    }

    await user.save();

    res.status(200).json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    console.error("Error creating payment intent:", error.message);
    res.status(500).json({ error: error.message });
  }
};
