import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';

class CartProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  List<CartItem> _items = [];
  String? _authToken;

  List<CartItem> get items => [..._items];

  int get itemCount => _items.length;

  double get totalAmount {
    return _items.fold(0.0, (sum, item) => sum + item.total);
  }

  void updateToken(String? token) {
    if (_authToken == token) return;
    _authToken = token;
    if (token != null) {
      fetchCart();
    } else {
      _items = [];
      notifyListeners();
    }
  }

  Future<void> fetchCart() async {
    if (_authToken == null) return;
    try {
      final result = await _apiService.getCart(_authToken!);
      if (result['items'] != null) {
        _items = (result['items'] as List)
            .where((item) => item['food'] != null)
            .map((item) {
          return CartItem(
            food: Food.fromJson(item['food']),
            quantity: item['quantity'],
          );
        }).toList();
        notifyListeners();
      }
    } catch (e) {
      print('Fetch Cart Error: $e');
    }
  }

  Future<void> addItem(Food food) async {
    int index = _items.indexWhere((item) => item.food.id == food.id);
    int newQuantity = 1;
    if (index != -1) {
      newQuantity = _items[index].quantity + 1;
    }
    
    await updateQuantity(food.id, newQuantity, food: food);
  }

  Future<void> removeItem(String foodId) async {
    await updateQuantity(foodId, 0);
  }

  Future<void> updateQuantity(String foodId, int quantity, {Food? food}) async {
    // Optimistic update
    int index = _items.indexWhere((item) => item.food.id == foodId);
    List<CartItem> originalItems = [..._items];

    if (index != -1) {
      if (quantity <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = quantity;
      }
    } else if (quantity > 0 && food != null) {
      _items.add(CartItem(food: food, quantity: quantity));
    }
    notifyListeners();

    if (_authToken != null) {
      try {
        await _apiService.updateCart(_authToken!, foodId, quantity);
      } catch (e) {
        // Rollback on error
        _items = originalItems;
        notifyListeners();
        print('Update Cart Error: $e');
      }
    }
  }

  Future<void> clear() async {
    _items = [];
    notifyListeners();
    if (_authToken != null) {
      try {
        await _apiService.clearCart(_authToken!);
      } catch (e) {
        print('Clear Cart Error: $e');
      }
    }
  }
}
