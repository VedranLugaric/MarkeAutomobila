const express = require('express');
const { MongoClient, ObjectId } = require('mongodb');
const cors = require('cors');

const app = express();
const port = 3000;

const jwt = require('jsonwebtoken'); 
const { auth, requiresAuth } = require('express-openid-connect'); 
const dotenv = require('dotenv'); 
dotenv.config();

// Enable Cross-Origin Resource Sharing
app.use(cors());
app.use(express.json());


const mongoUrl = 'mongodb://user:password@mongodb:27017';
const dbName = 'MarkeAutomobila';


let db;
console.log(`POKUSAVAMMMM`);

const wrapResponse = (data, message = 'Success') => ({
  status: 'success',
  message: message,
  data: data
});

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

app.get('/libraries/:name', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    "const libraries = await librariesCollection.find({}).toArray();"
    const libraries = await librariesCollection.find({ "Ime_proizvodjac": req.params.name }).toArray();
    console.log(libraries);
    res.json(libraries);
  } catch (error) {
    console.error('Error fetching libraries:', error);
    res.status(500).json({ error: 'Failed to fetch libraries' });
  }
});

app.get('/libraries/id/:id', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    "const libraries = await librariesCollection.find({}).toArray();"
    const libraries = await librariesCollection.find({ "ID_proizvodjac": Number(req.params.id) }).toArray();
    console.log(libraries);
    res.json(libraries);
  } catch (error) {
    console.error('Error fetching libraries:', error);
    res.status(500).json({ error: 'Failed to fetch libraries' });
  }
});

app.get('/libraries/godinanastanka/:godina', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    "const libraries = await librariesCollection.find({}).toArray();"
    const libraries = await librariesCollection.find({ "Godina_nastanka": Number(req.params.godina) }).toArray();
    console.log(libraries);
    res.json(libraries);
  } catch (error) {
    console.error('Error fetching libraries:', error);
    res.status(500).json({ error: 'Failed to fetch libraries' });
  }
});

app.get('/libraries/mongoid/:id', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    "const libraries = await librariesCollection.find({}).toArray();"
    console.log("Prije");
    console.log( new ObjectId(req.params.id));
    console.log("nakon");
    const libraries = await librariesCollection.find({ _id: new ObjectId(req.params.id) }).toArray();
    console.log(libraries);
    res.json(libraries);
  } catch (error) {
    console.error('Error fetching libraries:', error);
    res.status(500).json({ error: 'Failed to fetch libraries' });
  }
});

// POST endpoint to add a new item
app.post('/libraries/add/:id', async (req, res) => {
  try {
    const librariesCollection = db.collection('MarkeAutomobila');
    console.log("Prije");
    const newItem = req.body;
    console.log(newItem[0]);
    console.log("nakon");
    console.log(req.body['field1']);
    const result = await librariesCollection.insertOne(newItem);
    console.log(result);
    console.log(wrapResponse(result[0], 'Item created successfully'));
    res.status(201).json(wrapResponse(result[0], 'Item created successfully'));
  } catch (error) {
    console.error('Error creating item:', error);
    res.status(500).json(wrapResponse(null, 'Failed to create item'));
  }
});

app.put('/libraries/update/:id', async (req, res) => {
  try {
    const itemsCollection = db.collection('MarkeAutomobila');
    const updatedItem = req.body;
    const result = await itemsCollection.findOneAndUpdate(
      { _id: new ObjectId(req.params.id) },
      { $set: updatedItem },
      { returnDocument: 'after' }
    );
    delete result._id;
    console.log(updatedItem);
    console.log(result);
    console.log();
    if (!result.value) {
      res.json(wrapResponse(result.value, 'Item updated successfully'));
    } else {
      res.status(404).json(wrapResponse(null, 'Item not found'));
    }
  } catch (error) {
    console.error('Error updating item:', error);
    res.status(500).json(wrapResponse(null, 'Failed to update item'));
  }
});

app.delete('/libraries/delete/:id', async (req, res) => {
  try {
    const itemsCollection = db.collection('MarkeAutomobila');
    const result = await itemsCollection.deleteOne({ _id: new ObjectId(req.params.id) });
    if (result.deletedCount > 0) {
      res.json(wrapResponse(null, 'Item deleted successfully'));
    } else {
      res.status(404).json(wrapResponse(null, 'Item not found'));
    }
  } catch (error) {
    console.error('Error deleting item:', error);
    res.status(500).json(wrapResponse(null, 'Failed to delete item'));
  }
});

// Endpoint to serve the OpenAPI specification
app.get('/api-spec', (req, res) => {
  res.sendFile(__dirname + '/openapi.json');
});



const config = {
  authRequired: false,
  auth0Logout: true,
  secret: 'a long, randomly-generated string stored in env',
  baseURL: 'http://localhost:3000',
  clientID: 'O1VUflixUYi0DV4Q2QeMuzwH9xsd5Rga',
  issuerBaseURL: 'https://dev-0a66pm1zz2c5mu0u.us.auth0.com'
};

// auth router attaches /login, /logout, and /callback routes to the baseURL
app.use(auth(config));

app.get('/', (req, res) => {
  if (req.oidc.isAuthenticated()) {
    const token = jwt.sign(
      { sub: req.oidc.user.sub },
      process.env.JWT_SECRET,
      { expiresIn: '1h' }
    );
    const redirectUrl = `http://localhost:3000/token?token=${token}`;
    res.redirect(redirectUrl);
  } else {
    res.status(401).send('Not authenticated');
  }
});

// Endpoint to handle token reception
app.get('/token', (req, res) => {
  const token = req.query.token;
  res.send(`<script>window.opener.postMessage('${token}', '*'); window.close();</script>`);
});


app.get('/profile', requiresAuth(), (req, res) => {
  res.send(JSON.stringify(req.oidc.user));
});

// Endpoint for logout
app.get('/logout', (req, res) => {
  res.oidc.logout();
});


// Start the server
app.listen(port, () => {
  console.log(`Server running on http://localhost:${port}`);
});

// Connect to MongoDB when the server starts
connectToMongoDB().catch(error => console.error('Failed to connect to MongoDB:', error));
