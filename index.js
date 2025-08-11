require("dotenv").config();
const express = require("express");
const cors = require("cors");
const axios = require("axios");
const { GoogleGenerativeAI } = require("@google/generative-ai");

const app = express();
app.use(cors());
app.use(express.json());


// Generate a 6-digit numeric verification code
function generateVerificationCode() {
  return Math.floor(100000 + Math.random() * 900000).toString();
}

// 💳 Daraja API Keys (Sandbox or Default)
const consumerKey = process.env.CONSUMER_KEY;
const consumerSecret = process.env.CONSUMER_SECRET;
const shortCode = process.env.SHORTCODE || "174379";
const passKey = process.env.PASSKEY || "bfb279f9aa9bdbcf15e97dd71a467cd2c2c8a25b";
const callbackURL = process.env.CALLBACK_URL || "https://yourdomain.com/mpesa/callback";

// 🧠 Gemini API Key
const geminiKey = process.env.GEMINI_API_KEY;
const genAI = new GoogleGenerativeAI(geminiKey);

// List available models
async function listModels() {
  const models = await genAI.listModels();
  console.log(models);
}
listModels();
// Debugging output (optional)
console.log("🔐 CONSUMER_KEY:", consumerKey ? "Loaded ✅" : "Missing ❌");
console.log("🔐 CONSUMER_SECRET:", consumerSecret ? "Loaded ✅" : "Missing ❌");
console.log("🤖 GEMINI_API_KEY:", geminiKey ? "Loaded ✅" : "Missing ❌");

// Validate .env was loaded
if (!consumerKey || !consumerSecret) {
  console.error("❌ Missing Consumer Key or Secret. Check your .env file!");
  process.exit(1);
}

// Function to get access token
const getAccessToken = async () => {
  const url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString("base64");

  try {
    const response = await axios.get(url, {
      headers: {
        Authorization: `Basic ${auth}`
      }
    });
    return response.data.access_token;
  } catch (error) {
    console.error("❌ ERROR:", error.response?.data || error.message);
    throw error;
  }
};

// Function to generate timestamp
const getTimestamp = () => {
  const date = new Date();
  return date.toISOString().replace(/[-T:\.Z]/g, "").slice(0, 14);
};

// Function to generate password
const generatePassword = (timestamp) => {
  return Buffer.from(`${shortCode}${passKey}${timestamp}`).toString("base64");
};

// Gemini AI endpoint
app.post("/gemini/ask", async (req, res) => {
  const { prompt } = req.body;
  if (!prompt) {
    return res.status(400).json({ error: "Prompt is required." });
  }
  try {
    const model = genAI.getGenerativeModel({ model: "gemini-pro" });
    const result = await model.generateContent(prompt);
    const response = await result.response;
    const text = response.text();
    res.json({ text });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// STK Push endpoint
app.post("/mpesa/stkpush", async (req, res) => {
  const { phone, amount } = req.body;
  if (!phone || !amount) {
    return res.status(400).json({ error: "Phone and amount are required." });
  }

  try {
    const accessToken = await getAccessToken();
    const timestamp = getTimestamp();
    const password = generatePassword(timestamp);

    const payload = {
      BusinessShortCode: shortCode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: "CustomerPayBillOnline",
      Amount: amount,
      PartyA: phone,
      PartyB: shortCode,
      PhoneNumber: phone,
      CallBackURL: callbackURL,
      AccountReference: "ChamaSmart",
      TransactionDesc: "Chama Deposit"
    };

    const stkRes = await axios.post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      payload,
      { headers: { Authorization: `Bearer ${accessToken}` } }
    );
    res.json(stkRes.data);
  } catch (error) {
    res.status(500).json({ error: error.response?.data || error.message });
  }
});

// Callback endpoint (for Safaricom to notify you)
app.post("/mpesa/callback", (req, res) => {
  console.log("M-Pesa Callback:", req.body);
  res.json({ ResultCode: 0, ResultDesc: "Received" });
});

// Start the server
const PORT = process.env.PORT || 3001;
app.listen(PORT, () => console.log(`Daraja backend running on port ${PORT}`));