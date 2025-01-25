const express = require('express');
const bodyParser = require('body-parser');
const cloudinary = require('cloudinary').v2;

const app = express();
app.use(bodyParser.json());

cloudinary.config({
  cloud_name: 'dmzzprj46', // Replace with your Cloudinary cloud name
  api_key: '772598274843411', // Replace with your Cloudinary API key
  api_secret: 'HiafWZwRnhlcaHdBqjiffn1Uwr0', // Replace with your Cloudinary API secret
});

app.post('/generate_signature', (req, res) => {
  const timestamp = Math.round(new Date().getTime() / 1000);
  const signature = cloudinary.utils.api_sign_request(
    { timestamp: timestamp, upload_preset: 'ml_default' },
    cloudinary.config().api_secret
  );

  res.json({ timestamp, signature });
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`Server is running on port ${PORT}`);
});
