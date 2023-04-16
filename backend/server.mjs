import fs from 'fs';

import { create } from 'ipfs-http-client';
const ipfs = create('/ip4/127.0.0.1/tcp/5001');
// const ipfs_provider = 'https://ipfs.io/ipfs';
const ipfs_provider = 'http://chirux-3.local:8080/ipfs';

import { MongoClient } from "mongodb";
const uri = "mongodb://localhost:27017";
const client = new MongoClient(uri);
const database = client.db('NITK');

import express from 'express';
const app = express();
const port = 3000;
import formidable from 'express-formidable';
app.use(formidable());

import cors from 'cors';
app.use(cors())


app.get('/catalogue', async (req, res) => {

  const shops = database.collection('shops');
  const shop_items = await (await shops.find()).toArray();

  res.json(JSON.stringify(shop_items));
});

app.post('/add_item', async (req, res) => {

  console.log('adding item');

  const { sid, ...details } = req.fields;

  const img = fs.readFileSync(req.files['image'].path);
  const { cid } = await ipfs.add(img)
  const img_url = ipfs_provider + '/' + cid;
  
  const product_entry = { ...details, image: img_url };

  const shops = database.collection('shops');
  await shops.updateOne({ sid }, { $push: { products: product_entry } });

  res.status(200).end();
});

app.post('/add_shop', async (req, res) => {

  console.log('adding shop');
  
  const details = req.fields;

  const img = fs.readFileSync(req.files['image'].path);
  const { cid } = await ipfs.add(img)
  const img_url = ipfs_provider + '/' + cid;
  
  const db_entry = { ...details, image: img_url, products: [] };
  const shops = database.collection('shops');
  await shops.insertOne(db_entry);

  res.status(200).end();
});

app.get('/qr')

app.use(express.static('public'));

app.listen(port, () => {
  console.log(`App Listening At Port: ${port}`);
});



db.shops.update({ _id: ObjectId("643b597640c950fa1f522a3b") }, { $set: { image: 'localhost:8080/ipfs/QmW22ZuSwpX2dAU6nKZLvDAWoHjKQdZQcPUwKKXbeinZju' } })

