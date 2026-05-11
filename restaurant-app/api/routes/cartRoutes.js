const express = require('express');
const { getCart, addToCart, clearCart } = require('../controllers/cartController');
const jwt = require('jsonwebtoken');
const router = express.Router();

const auth = async (req, res, next) => {
  try {
    const authHeader = req.header('Authorization');
    if (!authHeader) return res.status(401).send({ error: 'Authorization header missing' });
    
    const token = authHeader.replace('Bearer ', '');
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (e) {
    res.status(401).send({ error: 'Vui lòng đăng nhập để tiếp tục' });
  }
};

router.get('/', auth, getCart);
router.post('/add', auth, addToCart);
router.delete('/', auth, clearCart);

module.exports = router;
