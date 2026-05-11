import 'dart:convert';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';

class ApiService {
  Future<List<Category>> getCategories() async {
    final response = await http.get(Uri.parse(AppConfig.categoriesUrl));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Category.fromJson(data)).toList();
    } else {
      throw Exception('Lỗi khi tải danh mục');
    }
  }

  Future<List<Food>> getFoods(String categoryId) async {
    final response = await http.get(Uri.parse('${AppConfig.foodsUrl}/$categoryId'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => Food.fromJson(data)).toList();
    } else {
      throw Exception('Lỗi khi tải món ăn');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse(AppConfig.loginUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'password': password}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> register(String username, String email, String password) async {
    final response = await http.post(
      Uri.parse(AppConfig.registerUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'username': username, 'email': email, 'password': password}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> forgotPassword(String email, String newPassword) async {
    final response = await http.post(
      Uri.parse(AppConfig.forgotPasswordUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email, 'newPassword': newPassword}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> placeOrder(String token, List<Map<String, dynamic>> items, double totalAmount) async {
    final response = await http.post(
      Uri.parse(AppConfig.ordersUrl),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'items': items,
        'totalAmount': totalAmount,
      }),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> getCart(String token) async {
    final response = await http.get(
      Uri.parse(AppConfig.cartUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> updateCart(String token, String foodId, int quantity) async {
    final response = await http.post(
      Uri.parse('${AppConfig.cartUrl}/add'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'foodId': foodId, 'quantity': quantity}),
    );
    return json.decode(response.body);
  }

  Future<Map<String, dynamic>> clearCart(String token) async {
    final response = await http.delete(
      Uri.parse(AppConfig.cartUrl),
      headers: {'Authorization': 'Bearer $token'},
    );
    return json.decode(response.body);
  }
}
