import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/food_provider.dart';
import '../providers/auth_provider.dart';
import 'food_list_screen.dart';
import 'cart_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Lấy danh sách Cuisine từ FoodProvider
    final cuisines = context.watch<FoodProvider>().cuisines;

    return Scaffold(
      appBar: AppBar(
        title: Text("Cuisine"),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
          )
        ],
      ),
      // Tạo Drawer theo yêu cầu
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text("Menu", style: TextStyle(color: Colors.white, fontSize: 24)),
            ),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text("Logout"),
              onTap: () {
                context.read<AuthProvider>().logout();
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
              },
            ),
          ],
        ),
      ),
      // Hiển thị danh sách Cuisines dạng Grid
      body: GridView.builder(
        padding: EdgeInsets.all(10),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 3/2),
        itemCount: cuisines.length,
        itemBuilder: (ctx, i) {
          return GestureDetector(
            onTap: () {
              // Điều hướng sang màn hình món ăn
              Navigator.push(context, MaterialPageRoute(
                builder: (_) => FoodListScreen(cuisineName: cuisines[i])
              ));
            },
            child: Card(
              color: Colors.orangeAccent,
              child: Center(child: Text(cuisines[i], style: TextStyle(fontSize: 18, color: Colors.white))),
            ),
          );
        },
      ),
    );
  }
}