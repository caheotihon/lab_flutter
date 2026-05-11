const Order = require('../models/Order');

exports.createOrder = async (req, res) => {
  try {
    const { items, totalAmount } = req.body;

    if (!items || items.length === 0) {
      return res.status(400).json({ error: 'Giỏ hàng trống' });
    }

    const order = new Order({
      user: req.userId,
      items,
      totalAmount,
    });

    const createdOrder = await order.save();
    res.status(201).json({
      message: 'Đặt hàng thành công',
      order: createdOrder,
    });
  } catch (error) {
    console.error('Order Controller Error:', error);
    res.status(500).json({ error: 'Lỗi hệ thống khi đặt hàng' });
  }
};
