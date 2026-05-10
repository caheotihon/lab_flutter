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
    FoodModel(id: '1', name: 'Noodles', cuisine: 'Chinese', price: 100, imagePath: 'assets/images/placeholder-food.png'),
    FoodModel(id: '2', name: 'Fried Rice', cuisine: 'Chinese', price: 120, imagePath: 'assets/images/placeholder-food.png'),
    FoodModel(id: '3', name: 'Dosa', cuisine: 'South Indian', price: 90, imagePath: 'assets/images/south-indian.png'),
    FoodModel(id: '4', name: 'Idli', cuisine: 'South Indian', price: 50, imagePath: 'assets/images/south-indian.png'),
    FoodModel(id: '5', name: 'Lassi', cuisine: 'Beverages', price: 40, imagePath: 'assets/images/beverages.png'),
    FoodModel(id: '6', name: 'Thali', cuisine: 'North India', price: 150, imagePath: 'assets/images/north-indian.png'),
    FoodModel(id: '7', name: 'Biryani', cuisine: 'North India', price: 180, imagePath: 'assets/images/biryani.png'),
    FoodModel(id: '8', name: 'Pizza', cuisine: 'Chinese', price: 200, imagePath: 'assets/images/pizza.png'),
  ];

  List<String> get cuisines => _cuisines;
  List<FoodModel> get foods => _foods;

  // Lọc món ăn theo Cuisine
  List<FoodModel> getFoodsByCuisine(String cuisine) {
    return _foods.where((food) => food.cuisine.toLowerCase() == cuisine.toLowerCase()).toList();
  }
}