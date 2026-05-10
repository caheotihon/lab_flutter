import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';

class PaymentSuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 100),
            SizedBox(height: 20),
            Text("Payment Successful", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text("Your payment has been approved!"),
            SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                // Xóa giỏ hàng
                context.read<CartProvider>().clearCart();
                // Quay lại Home (Xóa toàn bộ lịch sử màn hình trước đó)
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: Text("Back to Home"),
            )
          ],
        ),
      ),
    );
  }
}