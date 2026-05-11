import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'screens/auth_screen.dart';
import 'screens/category_screen.dart';
import 'screens/food_list_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/success_screen.dart';
import 'screens/forgot_password_screen.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProxyProvider<AuthProvider, CartProvider>(
          create: (_) => CartProvider(),
          update: (_, auth, cart) => cart!..updateToken(auth.token),
        ),
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
      title: 'Restaurant App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.orange,
          primary: Colors.orange.shade700,
          secondary: Colors.deepOrange,
        ),
        useMaterial3: true,
      ),
      home: Consumer<AuthProvider>(
        builder: (ctx, auth, _) => auth.isAuthenticated 
          ? const CategoryScreen() 
          : const AuthScreen(),
      ),
      routes: {
        CategoryScreen.routeName: (ctx) => const CategoryScreen(),
        FoodListScreen.routeName: (ctx) => const FoodListScreen(),
        CartScreen.routeName: (ctx) => const CartScreen(),
        SuccessScreen.routeName: (ctx) => const SuccessScreen(),
        ForgotPasswordScreen.routeName: (ctx) => const ForgotPasswordScreen(),
      },
    );
  }
}
