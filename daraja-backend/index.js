require("dotenv").config(); // Load .env variables
const axios = require("axios");

// Read from environment
const consumerKey = process.env.CONSUMER_KEY;
const consumerSecret = process.env.CONSUMER_SECRET;

// Log to confirm variables loaded
console.log("🔍 CONSUMER_KEY:", consumerKey);
console.log("🔍 CONSUMER_SECRET:", consumerSecret);

// Validate .env was loaded
if (!consumerKey || !consumerSecret) {
  console.error("❌ Missing Consumer Key or Secret. Check your .env file!");
  process.exit(1);
}

const getAccessToken = async () => {
  const url = "https://sandbox.safaricom.co.ke/oauth/v1/generate?grant_type=client_credentials";
  const auth = Buffer.from(`${consumerKey}:${consumerSecret}`).toString("base64");

  try {
    const response = await axios.get(url, {
      headers: {
        Authorization: `Basic ${auth}`
      }
    });
    console.log("✅ ACCESS TOKEN:", response.data.access_token);
  } catch (error) {
    console.error("❌ ERROR:", error.response?.data || error.message);
  }
};

getAccessToken();
