const Category = require('../models/Category');
const Food = require('../models/Food');

exports.getCategories = async (req, res) => {
  try {
    const categories = await Category.find();
    res.json(categories);
  } catch (error) {
    console.error('Get Categories Error:', error);
    res.status(500).json({ error: 'Lỗi khi lấy danh mục' });
  }
};

exports.getFoodsByCategory = async (req, res) => {
  try {
    const { categoryId } = req.params;
    const foods = await Food.find({ category: categoryId });
    res.json(foods);
  } catch (error) {
    console.error('Get Foods Error:', error);
    res.status(500).json({ error: 'Lỗi khi lấy danh sách món ăn' });
  }
};

// Seed endpoint: create categories from assets/images and sample foods
const fs = require('fs');
const path = require('path');

exports.seedData = async (req, res) => {
  try {
    const count = await Category.countDocuments();
    const force = req.query && req.query.force === 'true';
    if (count > 0 && !force) return res.status(400).json({ error: 'Dữ liệu đã được seed trước đó' });
    if (force) {
      await Food.deleteMany({});
      await Category.deleteMany({});
    }

    const imagesDir = path.resolve(__dirname, '..', '..', 'assets', 'images');
    const files = fs.existsSync(imagesDir) ? fs.readdirSync(imagesDir) : [];

    // Candidate category images (based on repo images)
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

    // Fallback: if no category images found, create a default category
    if (categoriesToInsert.length === 0) categoriesToInsert.push({ name: 'General', image: 'placeholder-food.png' });

    const categories = await Category.insertMany(categoriesToInsert);

    // Prepare a pool of images for foods (exclude category images)
    const categoryImageSet = new Set(categoriesToInsert.map(c => c.image));
    const foodImages = files.filter(f => !categoryImageSet.has(f));
    if (foodImages.length === 0) foodImages.push('placeholder-food.png');

    const foodsToInsert = [];
    // Create 3 sample foods per category
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

    res.json({ message: 'Seed dữ liệu thành công', categoriesCreated: categories.length, foodsCreated: foodsToInsert.length });
  } catch (error) {
    console.error('Seed Error:', error);
    res.status(500).json({ error: 'Lỗi khi seed dữ liệu', details: error.message });
  }
};
