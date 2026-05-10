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
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: Builder(
          builder: (ctx) => IconButton(
            icon: Icon(Icons.menu, color: Colors.black87),
            onPressed: () => Scaffold.of(ctx).openDrawer(),
          ),
        ),
        title: Text('Restaurant App', style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.bold)),
        centerTitle: true,
        iconTheme: IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black87),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CartScreen())),
          )
        ],
      ),
      // Tạo Drawer theo yêu cầu
      drawer: Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.white),
              child: Text("Menu", style: TextStyle(color: Colors.black87, fontSize: 24)),
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
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: GridView.builder(
          itemCount: cuisines.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.95, mainAxisSpacing: 12, crossAxisSpacing: 12),
          itemBuilder: (ctx, i) {
            final name = cuisines[i];
            final imageMap = {
              'Chinese': 'assets/images/chinese.png',
              'South Indian': 'assets/images/south-indian.png',
              'Beverages': 'assets/images/beverages.png',
              'North India': 'assets/images/north-indian.png',
            };
            final img = imageMap[name] ?? 'assets/images/placeholder-res.png';

            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (_) => FoodListScreen(cuisineName: name)));
              },
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Image.asset(img, fit: BoxFit.contain),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(name, style: TextStyle(color: Colors.red.shade700, fontWeight: FontWeight.w600)),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}