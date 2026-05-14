import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'services/auth_gate.dart';

// IMPORTANT: You need to run 'flutterfire configure' to generate this file
// Or manually provide the options in Firebase.initializeApp()
// For now, I will assume the user will configure it.
import 'firebase_options.dart'; 

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // You must configure Firebase before running this.
  // If you use flutterfire CLI, uncomment the following:
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // If you haven't run flutterfire configure yet, 
  // you might need to initialize it manually or just run the CLI.
  try {
    await Firebase.initializeApp();
  } catch (e) {
    print("Firebase initialization failed: $e");
    print("Make sure you have added google-services.json / GoogleService-Info.plist");
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthGate(),
      theme: lightMode,
    );
  }
}

// Simple Light Mode Theme
ThemeData lightMode = ThemeData(
  colorScheme: ColorScheme.light(
    surface: Colors.grey.shade300,
    primary: Colors.grey.shade500,
    secondary: Colors.grey.shade200,
    tertiary: Colors.white,
    inversePrimary: Colors.grey.shade900,
  ),
);
