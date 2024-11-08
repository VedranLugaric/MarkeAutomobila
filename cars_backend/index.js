const express = require('express');
const { MongoClient } = require('mongodb');
const cors = require('cors');

const app = express();
const port = 3000;

// Enable Cross-Origin Resource Sharing
app.use(cors());

const mongoUrl = 'mongodb://user:password@mongodb:27017';
const dbName = 'MarkeAutomobila';
let db;
console.log(`POKUSAVAMMMM`);

// Connect to MongoDB
async function connectToMongoDB() {
  console.log(`Povezujem se na BAZUUUUU`);
  const client = new MongoClient(mongoUrl);
  await client.connect();
  db = client.db(dbName);
  console.log(`Connected to MongoDB at ${mongoUrl}`);
  const librariesCollection = db.collection('MarkeAutomobila');
  const libraries = await librariesCollection.find({}).toArray();
  console.log(libraries);
}

// Endpoint to fetch all libraries
app.get('/libraries', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    const libraries = await librariesCollection.find({}).toArray();
    res.json(libraries);
  } catch (error) {
    console.error('Error fetching libraries:', error);
    res.status(500).json({ error: 'Failed to fetch libraries' });
  }
});

// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

// Connect to MongoDB when the server starts
connectToMongoDB().catch(error => console.error('Failed to connect to MongoDB:', error));
