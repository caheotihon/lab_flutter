import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartModel(),
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
      title: 'Provider Shopper',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

// ==========================================
// 0. MÀN HÌNH ĐĂNG NHẬP (LOGIN PAGE)
// ==========================================

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Welcome',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 48),
              const TextField(
                decoration: InputDecoration(
                  hintText: 'Dash',
                ),
              ),
              const SizedBox(height: 16),
              const TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: 'Password',
                ),
              ),
              const SizedBox(height: 40),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const MyCatalog()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.yellow,
                    foregroundColor: Colors.black,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    elevation: 0,
                  ),
                  child: const Text(
                    'ENTER',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 1. DATA & STATE MANAGEMENT
// ==========================================

// Danh sách tên sản phẩm giống trong ảnh
const List<String> itemNames = [
  'Code Smell', 'Control Flow', 'Interpreter', 'Recursion', 'Sprint',
  'Heisenbug', 'Spaghetti', 'Hydra Code', 'Off-By-One', 'Scope', 'Callback'
];

class Item {
  final int id;
  final String name;
  final Color color;

  Item(this.id, this.name)
      // Tự động gán một màu dựa vào ID để tạo các ô vuông nhiều màu
      : color = Colors.primaries[id % Colors.primaries.length];

  // Ghi đè toán tử == để Provider biết cách so sánh các Item với nhau
  @override
  int get hashCode => id;

  @override
  bool operator ==(Object other) => other is Item && other.id == id;
}

class CartModel extends ChangeNotifier {
  final List<Item> _items = [];

  UnmodifiableListView<Item> get items => UnmodifiableListView(_items);

  int get totalPrice => _items.length * 42;

  void add(Item item) {
    _items.add(item);
    notifyListeners();
  }

  void removeAll() {
    _items.clear();
    notifyListeners();
  }
}

// ==========================================
// 2. MÀN HÌNH CATALOG (GIỐNG TRONG ẢNH)
// ==========================================

class MyCatalog extends StatelessWidget {
  const MyCatalog({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Thanh AppBar màu vàng chữ đen giống ảnh
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Catalog',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          Consumer<CartModel>(
            builder: (context, cart, child) {
              return Badge(
                label: Text(cart.items.length.toString()),
                isLabelVisible: cart.items.isNotEmpty,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.shopping_cart, color: Colors.black),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MyCart()),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: itemNames.length,
        itemBuilder: (context, index) {
          final item = Item(index, itemNames[index]);

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                // Ô màu vuông bên trái
                Container(
                  width: 48,
                  height: 48,
                  color: item.color,
                ),
                const SizedBox(width: 16),
                
                // Tên item
                Expanded(
                  child: Text(
                    item.name,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                
                // Nút ADD hoặc Dấu Check ✔️
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    // Kiểm tra xem item này đã có trong giỏ hàng chưa
                    final isInCart = cart.items.contains(item);

                    return isInCart
                        ? const Padding(
                            padding: EdgeInsets.only(right: 16),
                            child: Icon(Icons.check, semanticLabel: 'ADDED'),
                          )
                        : TextButton(
                            onPressed: () {
                              cart.add(item);
                            },
                            child: const Text(
                              'ADD',
                              style: TextStyle(color: Colors.black54),
                            ),
                          );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ==========================================
// 3. MÀN HÌNH CART (GIỮ NGUYÊN HOẶC CHỈNH THEO STYLE MỚI)
// ==========================================

class MyCart extends StatelessWidget {
  const MyCart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Text(
          'Cart',
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<CartModel>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Empty Cart'));
                }
                return ListView.builder(
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    return ListTile(
                      leading: const Icon(Icons.done),
                      title: Text(item.name),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(height: 4, color: Colors.black),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Consumer<CartModel>(
                  builder: (context, cart, child) {
                    return Text(
                      '\$${cart.totalPrice}',
                      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    );
                  },
                ),
                ElevatedButton(
                  onPressed: () {
                    Provider.of<CartModel>(context, listen: false).removeAll();
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
                  child: const Text('CLEAR', style: TextStyle(color: Colors.black)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}