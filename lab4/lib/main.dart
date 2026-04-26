import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'controllers/auth_services.dart';
import 'pages/home.dart';
import 'pages/login_page.dart';
import 'pages/add_contact_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Contacts Firebase',
      theme: ThemeData(primarySwatch: Colors.indigo),
      // Dùng StreamBuilder để tự động chuyển màn hình Login/Home
      home: StreamBuilder(
        stream: AuthService().authStateChanges,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(body: Center(child: CircularProgressIndicator()));
          }
          if (snapshot.hasData) {
            return const HomePage(); // Đã login
          }
          return const LoginPage(); // Chưa login
        },
      ),
      routes: {
        "/add": (context) => const AddContactPage(),
      },
    );
  }
}