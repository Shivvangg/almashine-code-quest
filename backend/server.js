const express = require('express');
const mongoose = require('mongoose');
const fs = require("fs");
const cors = require('cors');
const bodyParser = require('body-parser');
const bcrypt = require('bcrypt');

require('dotenv').config();

const app = express();

app.use(cors());

app.use(express.json());

fs.readdirSync("./routes").forEach((file) => {
    const route = require("./routes/" + file);
    console.log(`Loaded route: ${file}`);
    app.use("", route); // Mount the routes
});

// Simulate the password process
async function testPassword() {
    const password = 'myPassword123';
    const salt = await bcrypt.genSalt(10);
    const hashedPassword = await bcrypt.hash(password, salt);

    console.log('Hashed Password:', hashedPassword);

    const isMatch = await bcrypt.compare(password, hashedPassword);
    console.log('Does the password match?', isMatch); // Should return true
}

testPassword();

mongoose.connect(process.env.MONGO_URL)
    .then(() => console.log('MongoDB connected'))
    .catch(err => console.error('MongoDB connection error:', err));

app.listen(process.env.PORT || 8000);
