import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../providers/auth_provider.dart' as app_auth;
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isLogin = true; // Chuyển đổi giữa Login và Sign Up
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  void submit() async {
    final auth = context.read<app_auth.AuthProvider>();
    try {
      if (isLogin) {
        await auth.login(_emailController.text, _passwordController.text);
      } else {
        await auth.signUp(_emailController.text, _passwordController.text, _nameController.text);
      }
      if (!mounted) return;
      // Thành công chuyển sang Home
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => HomeScreen()));
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Lỗi: $e")));
    }
  }

  void forgotPassword() async {
    if (_emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Vui lòng nhập email")));
      return;
    }
    await FirebaseAuth.instance.sendPasswordResetEmail(email: _emailController.text);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Đã gửi email khôi phục!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isLogin ? "Đăng nhập" : "Đăng ký")),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 24),
              // Title like mockup
              Center(
                child: Text('Restaurant App', style: TextStyle(fontSize: 26, color: Colors.red.shade700, fontWeight: FontWeight.bold)),
              ),
              const SizedBox(height: 24),

              if (!isLogin)
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(labelText: 'Username', border: UnderlineInputBorder()),
                ),
              if (!isLogin) const SizedBox(height: 12),

              TextField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email', border: UnderlineInputBorder()),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(labelText: 'Password', border: UnderlineInputBorder()),
                obscureText: true,
              ),
              const SizedBox(height: 8),

              if (isLogin)
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(onPressed: forgotPassword, child: Text("Forgot Password?", style: TextStyle(color: Colors.orange))),
                ),

              const SizedBox(height: 8),
              // Sign In (light grey rounded)
              ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade300,
                  foregroundColor: Colors.black87,
                  shape: const StadiumBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(isLogin ? 'Sign In' : 'Sign Up'),
                ),
              ),
              const SizedBox(height: 12),
              // Sign Up (blue pill)
              ElevatedButton(
                onPressed: () => setState(() => isLogin = !isLogin),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo.shade700,
                  shape: const StadiumBorder(),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Text(isLogin ? 'Sign Up' : 'I already have an account', style: TextStyle(color: Colors.white)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}