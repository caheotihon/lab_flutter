const express = require('express');
const { getCategories, getFoodsByCategory, seedData } = require('../controllers/foodController');
const router = express.Router();

router.get('/categories', getCategories);
router.get('/foods/:categoryId', getFoodsByCategory);
router.post('/seed', seedData);

module.exports = router;
