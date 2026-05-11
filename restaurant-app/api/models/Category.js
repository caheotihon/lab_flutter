const mongoose = require('mongoose');

const categorySchema = new mongoose.Schema({
  name: { type: String, required: true },
  image: { type: String, required: true }, // Filename in assets/images
});

module.exports = mongoose.model('Category', categorySchema);
