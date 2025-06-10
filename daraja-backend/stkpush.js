require("dotenv").config();
const axios = require("axios");

const consumerKey = process.env.CONSUMER_KEY;
const consumerSecret = process.env.CONSUMER_SECRET;
const shortCode = process.env.SHORTCODE;
const passKey = process.env.PASSKEY;
const callbackURL = process.env.CALLBACK_URL;

// Function to generate timestamp
const getTimestamp = () => {
  const date = new Date();
  return date.toISOString().replace(/[-T:\.Z]/g, "").slice(0, 14);
};

// Function to generate password
const generatePassword = (timestamp) => {
  const password = Buffer.from(`${shortCode}${passKey}${timestamp}`).toString("base64");
  return password;
};

// Function to get token
const getAccessToken = async () => {
  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString("base64");
  const url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
  const response = await axios.get(url, {
    headers: { Authorization: `Basic ${auth}` }
  });
  return response.data.access_token;
};

// Function to initiate STK Push
const initiateSTKPush = async () => {
  const timestamp = getTimestamp();
  const password = generatePassword(timestamp);
  const accessToken = await getAccessToken();

  const payload = {
    BusinessShortCode: shortCode,
    Password: password,
    Timestamp: timestamp,
    TransactionType: "CustomerPayBillOnline",
    Amount: 10, // Change this to desired amount
    PartyA: "254717895133", // Your phone number here (MUST be Safaricom)
    PartyB: shortCode,
    PhoneNumber: "254717895133", // Same phone number here
    CallBackURL: callbackURL,
    AccountReference: "ChamaSmart",
    TransactionDesc: "Chama contribution"
  };

  try {
    const response = await axios.post(
      "https://sandbox.safaricom.co.ke/mpesa/stkpush/v1/processrequest",
      payload,
      {
        headers: {
          Authorization: `Bearer ${accessToken}`
        }
      }
    );
    console.log("✅ STK Push Response:", response.data);
  } catch (error) {
    if (error.response) {
      console.error("❌ STK Push Error:", error.response.data);
    } else {
      console.error("❌ Error:", error.message);
    }
  }
};

initiateSTKPush();
