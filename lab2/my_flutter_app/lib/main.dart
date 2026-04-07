import 'package:flutter/material.dart';

// Import các file chứa 4 phần trước của bạn
// Lưu ý: Đảm bảo bạn đã thêm từ khóa 'export' hoặc import đúng tên file
import 'part1_layout.dart';
import 'part2_responsive.dart';
import 'part3_navigation.dart';
import 'part4_form.dart';

void main() {
  runApp(const MyLabApp());
}

class MyLabApp extends StatelessWidget {
  const MyLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lab 2 - Full App',
      theme: ThemeData(
        useMaterial3: true,
        // Giữ lại cấu hình theme cho Form của Part 4
        inputDecorationTheme: const InputDecorationTheme(
          border: OutlineInputBorder(),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
      // Giữ lại cấu hình Route cho Part 3
      routes: {
        '/second': (context) => const SecondScreen(), 
      },
      home: const MainDashboard(),
    );
  }
}

class MainDashboard extends StatefulWidget {
  const MainDashboard({super.key});

  @override
  State<MainDashboard> createState() => _MainDashboardState();
}

class _MainDashboardState extends State<MainDashboard> {
  // Biến lưu trữ vị trí tab hiện tại đang được chọn
  int _selectedIndex = 0;

  // Danh sách 4 màn hình đã làm ở các Part trước
  final List<Widget> _screens = const [
    LayoutApp(),          // Part 1
    ResponsiveHomePage(), // Part 2
    HomeScreen(),         // Part 3
    RegistrationPage(),   // Part 4
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // IndexedStack giúp giữ nguyên State của các màn hình khi chuyển tab
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      // NavigationBar là widget chuẩn Material 3 (thay thế cho BottomNavigationBar cũ)
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard),
            label: 'Layout',
          ),
          NavigationDestination(
            icon: Icon(Icons.devices_outlined),
            selectedIcon: Icon(Icons.devices),
            label: 'Responsive',
          ),
          NavigationDestination(
            icon: Icon(Icons.navigation_outlined),
            selectedIcon: Icon(Icons.navigation),
            label: 'Route',
          ),
          NavigationDestination(
            icon: Icon(Icons.app_registration_outlined),
            selectedIcon: Icon(Icons.app_registration),
            label: 'Form',
          ),
        ],
      ),
    );
  }
}