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
        backgroundColor: Colors.white,
        elevation: 0.5,
        iconTheme: IconThemeData(color: Colors.black87),
        title: Text(cuisineName, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView.builder(
          itemCount: foods.length,
          itemBuilder: (ctx, i) {
            final food = foods[i];
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: Column(
                children: [
                  // header with restaurant name placeholder
                  ListTile(
                    title: Text('KFC', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
                    subtitle: Text('Block 12'),
                  ),
                  Divider(height: 1),
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.grey.shade100,
                          ),
                          child: ClipOval(
                            child: Image.asset(food.imagePath, fit: BoxFit.cover, errorBuilder: (c, e, s) => Icon(Icons.fastfood, size: 40)),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(food.name, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 6),
                              Text(food.cuisine.toLowerCase(), style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Text('₹ ${food.price.toStringAsFixed(0)}', style: TextStyle(color: Colors.green.shade700, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: (){
                                context.read<CartProvider>().addToCart(food.id, food.name, food.price);
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã thêm vào giỏ!'), duration: Duration(seconds: 1)));
                              },
                              child: Text('ADD TO CART'),
                            )
                          ],
                        )
                      ],
                    ),
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}