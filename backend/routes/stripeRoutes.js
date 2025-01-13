import express from "express";
import { createPaymentIntent } from "../controllers/stripeController.js";
import authorize from "../middleware/authorization.js";

const router = express.Router();

router.post("/create-payment-intent", authorize, createPaymentIntent);

export default router;
