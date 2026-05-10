import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class FoodListScreen extends StatelessWidget {
  final String cuisineName;
  FoodListScreen({required this.cuisineName});

  @override
  Widget build(BuildContext context) {
    // Lọc món ăn theo Cuisine
    final foods = context.read<FoodProvider>().getFoodsByCuisine(cuisineName);

    return Scaffold(
      appBar: AppBar(
        title: Text(cuisineName),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: foods.length,
        itemBuilder: (ctx, i) {
          final food = foods[i];
          return ListTile(
            leading: Image.asset(food.imagePath, width: 60, height: 60, fit: BoxFit.cover,
                errorBuilder: (c, e, s) => Icon(Icons.fastfood, size: 50)), // Fallback nếu ảnh lỗi
            title: Text(food.name),
            subtitle: Text("\$${food.price}"),
            trailing: ElevatedButton(
              onPressed: () {
                // Thêm vào giỏ hàng
                context.read<CartProvider>().addToCart(food.id, food.name, food.price);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã thêm vào giỏ!"), duration: Duration(seconds: 1)));
              },
              child: Text("ADD TO CART"),
            ),
          );
        },
      ),
    );
  }
}