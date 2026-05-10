import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart'; // File này tự sinh ra sau khi chạy flutterfire configure

// Khai báo import thư mục bạn vừa tạo
import 'providers/auth_provider.dart';
import 'providers/food_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/login_screen.dart';

void main() async {
  // Bắt buộc phải có 2 dòng này để khởi tạo Firebase trước khi chạy App
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    // Bọc toàn bộ app bằng MultiProvider để chia sẻ dữ liệu
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Restaurant App',
      // Màn hình khởi động là LoginScreen
      home: const LoginScreen(),
    );
  }
}