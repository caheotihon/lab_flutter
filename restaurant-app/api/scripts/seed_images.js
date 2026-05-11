const path = require('path');
const fs = require('fs');
const mongoose = require('mongoose');
require('dotenv').config({ path: path.resolve(__dirname, '..', '.env') });

const connectDB = require('../config/db');
const Category = require('../models/Category');
const Food = require('../models/Food');

async function seed() {
  try {
    await connectDB();

    const imagesDir = path.resolve(__dirname, '..', '..', 'flutter_app', 'assets', 'images');
    const files = fs.existsSync(imagesDir) ? fs.readdirSync(imagesDir) : [];

    const categoryFiles = {
      'Chinese': 'chinese.png',
      'Mexican': 'mexican.png',
      'North Indian': 'north-indian.png',
      'South Indian': 'south-indian.png',
      'Pizza': 'pizza.png',
      'Desserts': 'desserts.png',
      'Ice Creams': 'ice-creams.png',
      'Beverages': 'beverages.png'
    };

    const categoriesToInsert = [];
    for (const [name, file] of Object.entries(categoryFiles)) {
      if (files.includes(file)) categoriesToInsert.push({ name, image: file });
    }
    if (categoriesToInsert.length === 0) categoriesToInsert.push({ name: 'General', image: 'placeholder-food.png' });

    console.log('Clearing existing Category and Food collections...');
    await Category.deleteMany({});
    await Food.deleteMany({});

    const categories = await Category.insertMany(categoriesToInsert);
    console.log(`Inserted ${categories.length} categories`);

    const categoryImageSet = new Set(categoriesToInsert.map(c => c.image));
    const foodImages = files.filter(f => !categoryImageSet.has(f));
    if (foodImages.length === 0) foodImages.push('placeholder-food.png');

    const foodsToInsert = [];
    for (const cat of categories) {
      for (let i = 1; i <= 3; i++) {
        const img = foodImages[(Math.abs((cat._id.toString().charCodeAt(0) + i)) % foodImages.length)];
        foodsToInsert.push({
          name: `${cat.name} Dish ${i}`,
          description: `Món ${i} thuộc ${cat.name}`,
          price: Math.floor(40000 + Math.random() * 120000),
          image: img,
          category: cat._id,
        });
      }
    }

    await Food.insertMany(foodsToInsert);
    console.log(`Inserted ${foodsToInsert.length} foods`);
    process.exit(0);
  } catch (err) {
    console.error('Seeding error:', err);
    process.exit(1);
  }
}

seed();