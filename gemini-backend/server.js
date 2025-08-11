require("dotenv").config();
console.log("API Key from env:", process.env.GEMINI_API_KEY);

const express = require('express');
const cors = require('cors'); // Correctly declaring 'cors' here
const { GoogleGenerativeAI } = require("@google/generative-ai");

const app = express();
const port = 3001;

console.log("Server script is starting...");

// Use middleware
app.use(cors());
app.use(express.json());

// Initialize Gemini with your API key
const genAI = new GoogleGenerativeAI(process.env.GEMINI_API_KEY);
const model = genAI.getGenerativeModel({ model: "gemini-1.5-pro" });


// Define the endpoint that your Flutter app will call
app.post('/gemini/ask', async (req, res) => {
  const { prompt } = req.body;

  if (!prompt) {
    return res.status(400).json({ error: "Prompt is required in the request body." });
  }

  try {
    const result = await model.generateContent(prompt);
    const response = result.response;
    const text = response.text();

    console.log("✅ Gemini Response:", text);
    res.status(200).json({ text });
  } catch (error) {
    console.error("❌ Error generating content:", error);
    res.status(500).json({ error: error.message || "An unknown error occurred" });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server is running at http://localhost:${port}`);
  console.log("Waiting for requests from your Flutter app...");
});