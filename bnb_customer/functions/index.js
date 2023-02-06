const functions = require("firebase-functions");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
const express = require('express');
const app = express();
const cors = require('cors')({origin: true});
app.use(cors);
app.get('/', (req, res) => {
    const date = new Date();
    const hours = (date.getHours() % 12) + 1;  // London is UTC + 1hr;
    res.send(`
      <!doctype html>
      <head>
        <title>Time</title>
        <link rel="stylesheet" href="/style.css">
        <script src="/script.js"></script>
      </head>
      <body>
        <p>In London, the clock strikes:
          <span id="bongs">${'BONG '.repeat(hours)}</span></p>
        <button onClick="refresh(this)">Refresh</button>
      </body>
    </html>`);
  });
//   "ignore": [
//     "firebase.json",
//     "**/.*",
//     "**/node_modules/**"
//   ],

// "target1": "bnb-test-dev",
//     "target": "bnbtest",
//     "public": "build/web",

// "functions": {
//     "source": "functions"
//   },
//   "database": {
//     "rules": "database.rules.json"
//   },
//   "firestore": {
//     "rules": "firestore.rules",
//     "indexes": "firestore.indexes.json"
//   },
//   "storage": {
//     "rules": "storage.rules"
//   }
  app.get('/api', (req, res) => {
    const date = new Date();
    const hours = (date.getHours() % 12) + 1;  // London is UTC + 1hr;
    res.json({bongs: 'BONG '.repeat(hours)});
  });
 
  exports.app = functions.https.onRequest(app);