const User = require('../models/User');
const jwt = require('jsonwebtoken');

exports.register = async (req, res) => {
  console.log('Auth.register body:', req.body);
  try {
    const { username, email, password } = req.body;
    if (!username || !email || !password) {
      return res.status(400).json({ error: 'Vui lòng cung cấp đầy đủ thông tin' });
    }

    const existing = await User.findOne({ email });
    if (existing) return res.status(400).json({ error: 'Email đã được sử dụng' });

    const user = new User({ username, email, password });
    await user.save();

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET || 'secret', { expiresIn: '7d' });

    res.status(201).json({
      message: 'Đăng ký thành công',
      token,
      user: { id: user._id, username: user.username, email: user.email },
    });
  } catch (error) {
    console.error('Auth Register Error:', error);
    // In development, include error message for easier debugging
    res.status(500).json({ error: 'Lỗi hệ thống khi đăng ký', details: error.message });
  }
};

exports.login = async (req, res) => {
  try {
    const { email, password } = req.body;
    if (!email || !password) return res.status(400).json({ error: 'Vui lòng cung cấp email và mật khẩu' });

    const user = await User.findOne({ email });
    if (!user) return res.status(400).json({ error: 'Email hoặc mật khẩu không đúng' });

    const isMatch = await user.comparePassword(password);
    if (!isMatch) return res.status(400).json({ error: 'Email hoặc mật khẩu không đúng' });

    const token = jwt.sign({ userId: user._id }, process.env.JWT_SECRET || 'secret', { expiresIn: '7d' });

    res.json({ message: 'Đăng nhập thành công', token, user: { id: user._id, username: user.username, email: user.email } });
  } catch (error) {
    console.error('Auth Login Error:', error);
    res.status(500).json({ error: 'Lỗi hệ thống khi đăng nhập' });
  }
};

exports.forgotPassword = async (req, res) => {
  try {
    const { email, newPassword } = req.body;
    if (!email || !newPassword) {
      return res.status(400).json({ error: 'Vui lòng cung cấp email và mật khẩu mới' });
    }

    const user = await User.findOne({ email });
    if (!user) {
      return res.status(404).json({ error: 'Email không tồn tại trong hệ thống' });
    }

    user.password = newPassword;
    await user.save();

    res.json({ message: 'Đổi mật khẩu thành công' });
  } catch (error) {
    console.error('Forgot Password Error:', error);
    res.status(500).json({ error: 'Lỗi hệ thống khi đổi mật khẩu' });
  }
};
