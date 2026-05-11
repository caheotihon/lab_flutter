import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/category_model.dart';
import '../models/food_model.dart';
import '../services/api_service.dart';
import '../providers/cart_provider.dart';
import 'cart_screen.dart';

class FoodListScreen extends StatefulWidget {
  static const routeName = '/food-list';

  const FoodListScreen({super.key});

  @override
  State<FoodListScreen> createState() => _FoodListScreenState();
}

class _FoodListScreenState extends State<FoodListScreen> {
  final ApiService _apiService = ApiService();
  Category? _category;
  late Future<List<Food>> _foodsFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_category == null) {
      _category = ModalRoute.of(context)!.settings.arguments as Category;
      _foodsFuture = _apiService.getFoods(_category!.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_category!.name),
        actions: [
          Consumer<CartProvider>(
            builder: (context, cart, child) => Badge(
              label: Text(cart.itemCount.toString()),
              isLabelVisible: cart.itemCount > 0,
              child: IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder<List<Food>>(
        future: _foodsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No food items found.'));
          }

          final foods = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: foods.length,
            itemBuilder: (ctx, i) {
              final food = foods[i];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: ListTile(
                  contentPadding: const EdgeInsets.all(12),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'assets/images/${food.image}',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Image.asset('assets/images/placeholder-food.png', width: 80, height: 80),
                    ),
                  ),
                  title: Text(food.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(food.description, maxLines: 2, overflow: TextOverflow.ellipsis),
                      const SizedBox(height: 4),
                      Text('\$${food.price.toStringAsFixed(2)}', style: TextStyle(color: Colors.orange.shade800, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  trailing: Consumer<CartProvider>(
                    builder: (ctx, cart, _) {
                      final cartItemIndex = cart.items.indexWhere((item) => item.food.id == food.id);
                      final cartItem = cartItemIndex != -1 ? cart.items[cartItemIndex] : null;

                      if (cartItem != null) {
                        return Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.orange),
                              onPressed: () => cart.updateQuantity(food.id, cartItem.quantity - 1),
                            ),
                            Text('${cartItem.quantity}', style: const TextStyle(fontWeight: FontWeight.bold)),
                            IconButton(
                              icon: const Icon(Icons.add_circle_outline, color: Colors.orange),
                              onPressed: () => cart.updateQuantity(food.id, cartItem.quantity + 1),
                            ),
                          ],
                        );
                      }

                      return IconButton(
                        icon: const Icon(Icons.add_shopping_cart, color: Colors.orange),
                        onPressed: () {
                          cart.addItem(food);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${food.name} added to cart!'), duration: const Duration(seconds: 1)),
                          );
                        },
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
