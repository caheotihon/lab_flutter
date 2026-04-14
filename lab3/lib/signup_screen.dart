import 'package:flutter/material.dart';
import 'api_service.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _userController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _apiService = ApiService();

  void _handleSignup() async {
    if (_emailController.text.isEmpty || _passController.text.isEmpty) return;

    Map<String, dynamic> data = {
      "username": _userController.text,
      "email": _emailController.text,
      "password": _passController.text,
    };

    // Gọi API đến endpoint 'users' (khớp với MockAPI của bạn)
    await _apiService.send("users", data);

    if (mounted) {
      // In ra hộp thoại thông báo theo yêu cầu đề bài
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Thông báo"),
          content: const Text("Đăng ký thành công"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Đóng dialog
                Navigator.pop(context); // Quay về màn hình Login
              },
              child: const Text("OK"),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Registration')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(Icons.person_add, size: 100, color: Colors.blue),
            const SizedBox(height: 20),
            _buildTextField(_userController, 'Username'),
            const SizedBox(height: 15),
            _buildTextField(_emailController, 'Email'),
            const SizedBox(height: 15),
            _buildTextField(_passController, 'Password', isObscure: true),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleSignup,
                child: const Text('Sign up'),
              ),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isObscure = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: isObscure,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
