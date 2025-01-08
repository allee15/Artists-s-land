import Stripe from "stripe";

const stripe = new Stripe(
  "sk_test_51NzPkBFsUJrHtrhWlwiD8MCBEZKKA22zr0rM0PCOo5XU7EUxReZlRMhlNhqan199k8Z3eObxScKdgVod1dNGarpM00OzSUewgH"
);

export default stripe;

export const createPaymentIntent = async (req, res) => {
  const { amount, currency } = req.body;

  try {
    const paymentIntent = await stripe.paymentIntents.create({
      amount,
      currency,
      automatic_payment_methods: {
        enabled: true,
      },
    });

    res.status(200).json({ clientSecret: paymentIntent.client_secret });
  } catch (error) {
    console.error("Error creating payment intent:", error.message);
    res.status(500).json({ error: error.message });
  }
};
