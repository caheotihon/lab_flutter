import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import 'payment_success_screen.dart';

class CartScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final cartItems = cart.items.values.toList();

    return Scaffold(
      appBar: AppBar(title: Text("Cart")),
      body: Column(
        children: [
          // Danh sách món trong giỏ
          Expanded(
            child: ListView.builder(
              itemCount: cartItems.length,
              itemBuilder: (ctx, i) {
                final item = cartItems[i];
                return ListTile(
                  title: Text(item.name),
                  subtitle: Text("\$${item.price * item.quantity}"),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(icon: Icon(Icons.remove), onPressed: () => cart.updateQuantity(item.id, false)),
                      Text('${item.quantity}', style: TextStyle(fontSize: 18)),
                      IconButton(icon: Icon(Icons.add), onPressed: () => cart.updateQuantity(item.id, true)),
                    ],
                  ),
                );
              },
            ),
          ),
          // Hóa đơn (Bill Receipt)
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.grey[200],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text("Bill Receipt", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Divider(),
                buildReceiptRow("Items Total", cart.itemsTotal),
                buildReceiptRow("Offer Discount", -cart.offerDiscount),
                buildReceiptRow("Taxes (8%)", cart.taxes),
                buildReceiptRow("Delivery Charges", cart.deliveryCharges),
                Divider(),
                buildReceiptRow("Total Pay", cart.totalPay, isBold: true),
                SizedBox(height: 10),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green, padding: EdgeInsets.all(15)),
                  onPressed: cart.items.isEmpty ? null : () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => PaymentSuccessScreen()));
                  },
                  child: Text("Proceed To Pay", style: TextStyle(fontSize: 18)),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Hàm phụ trợ vẽ các dòng hóa đơn cho gọn code
  Widget buildReceiptRow(String title, double amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
          Text("\$${amount.toStringAsFixed(2)}", style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 16)),
        ],
      ),
    );
  }
}