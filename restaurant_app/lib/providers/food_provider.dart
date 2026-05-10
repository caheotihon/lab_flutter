import 'package:flutter/material.dart';

class FoodModel {
  final String id;
  final String name;
  final String cuisine; // VD: "chinese", "south_indian"
  final double price;
  final String imagePath; // Đường dẫn ảnh từ thư mục assets

  FoodModel({required this.id, required this.name, required this.cuisine, required this.price, required this.imagePath});
}

class FoodProvider with ChangeNotifier {
  // Danh sách các loại món ăn cứng hoặc lấy từ Firebase
  final List<String> _cuisines = ['Chinese', 'South Indian', 'Beverages', 'North India'];
  
  // Danh sách món ăn
  List<FoodModel> _foods = [
    FoodModel(id: '1', name: 'Noodles', cuisine: 'Chinese', price: 100, imagePath: 'assets/images/noodles.png'),
    FoodModel(id: '2', name: 'Fajita Chicken Burrito', cuisine: 'Mexican', price: 825, imagePath: 'assets/images/burrito.png'),
    FoodModel(id: '3', name: 'Gulab Jamun', cuisine: 'North India', price: 126, imagePath: 'assets/images/gulab.png'),
  ];

  List<String> get cuisines => _cuisines;
  List<FoodModel> get foods => _foods;

  // Lọc món ăn theo Cuisine
  List<FoodModel> getFoodsByCuisine(String cuisine) {
    return _foods.where((food) => food.cuisine.toLowerCase() == cuisine.toLowerCase()).toList();
  }
}