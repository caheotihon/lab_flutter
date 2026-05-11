const express = require('express');
const { createOrder } = require('../controllers/orderController');
const jwt = require('jsonwebtoken');
const router = express.Router();

// Middleware xác thực (Có thể tách ra file middleware riêng)
const auth = async (req, res, next) => {
  try {
    const token = req.header('Authorization').replace('Bearer ', '');
    const decoded = jwt.verify(token, process.env.JWT_SECRET);
    req.userId = decoded.userId;
    next();
  } catch (e) {
    res.status(401).send({ error: 'Vui lòng đăng nhập để tiếp tục' });
  }
};

router.post('/', auth, createOrder);

module.exports = router;
