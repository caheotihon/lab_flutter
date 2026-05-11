import 'food_model.dart';

class CartItem {
  final Food food;
  int quantity;

  CartItem({required this.food, this.quantity = 1});

  double get total => food.price * quantity;
}
