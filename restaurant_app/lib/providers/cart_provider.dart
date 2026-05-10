import 'package:flutter/material.dart';

class CartItem {
  final String id;
  final String name;
  final double price;
  int quantity;

  CartItem({required this.id, required this.name, required this.price, this.quantity = 1});
}

class CartProvider with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  // Thêm món vào giỏ (nếu có rồi thì tăng số lượng) [cite: 43]
  void addToCart(String id, String name, double price) {
    if (_items.containsKey(id)) {
      _items.update(id, (existingItem) => CartItem(
            id: existingItem.id,
            name: existingItem.name,
            price: existingItem.price,
            quantity: existingItem.quantity + 1,
          ));
    } else {
      _items.putIfAbsent(id, () => CartItem(id: id, name: name, price: price));
    }
    notifyListeners();
  }

  // Tăng/Giảm số lượng món ăn [cite: 49-58]
  void updateQuantity(String id, bool isIncreasing) {
    if (!_items.containsKey(id)) return;

    if (isIncreasing) {
      _items[id]!.quantity += 1;
    } else {
      if (_items[id]!.quantity > 1) {
        _items[id]!.quantity -= 1;
      } else {
        _items.remove(id); // Nếu giảm về 0 thì xóa khỏi giỏ
      }
    }
    notifyListeners();
  }

  // Xóa sạch giỏ hàng (dùng sau khi thanh toán xong) [cite: 74, 81]
  void clearCart() {
    _items = {};
    notifyListeners();
  }

  // --- CÁC HÀM TÍNH TOÁN BILL RECEIPT ---

  // Tổng tiền các món (Items Total) [cite: 61, 62]
  double get itemsTotal {
    var total = 0.0;
    _items.forEach((key, item) => total += item.price * item.quantity);
    return total;
  }

  // Giảm giá (Offer Discount) [cite: 63, 64]
  double get offerDiscount => 18.0; // Hardcode theo đề bài hoặc tự tính

  // Tính thuế 8% (Taxes) [cite: 65, 66]
  double get taxes => itemsTotal * 0.08;

  // Phí giao hàng (Delivery Charges) [cite: 67, 68]
  double get deliveryCharges => _items.isEmpty ? 0.0 : 30.0;

  // Tổng thanh toán cuối cùng (Total Pay) [cite: 69, 70]
  double get totalPay {
    if (_items.isEmpty) return 0.0;
    return itemsTotal - offerDiscount + taxes + deliveryCharges;
  }
}