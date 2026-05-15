import 'dart:convert';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:user_management/accounts/register.dart';
import 'package:user_management/admin_area/admin_main_page.dart';
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/login_model.dart';
import 'package:user_management/other_roles/unknown_roles.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/submit_button.dart';
import 'package:user_management/shared/text_fields.dart';
import 'package:http/http.dart' as http;
import 'package:user_management/users_area/users_main_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void submitForm() async {
    if (_formKey.currentState!.validate()) {
      final loginData = LoginModel(
        email: _emailController.text,
        password: _passwordController.text,
      );

      var result = await http.post(
        Uri.parse(ApiEndpoints.login),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(loginData.toJson()),
      );

      if (result.statusCode >= 200 && result.statusCode <= 299) {
        final jsonData = json.decode(result.body);
        final token = jsonData['token'];

        TokenHandler().addToken(token);

        final decodedToken = JwtDecoder.decode(TokenHandler().getToken());

        String? role = decodedToken[
            'http://schemas.microsoft.com/ws/2008/06/identity/claims/role'];

        if (!mounted) return;

        if (role == "Admin") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const AdminMainPage()),
            (Route<dynamic> route) => false,
          );
        } else if (role == "User") {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const UsersMainPage()),
            (Route<dynamic> route) => false,
          );
        } else {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const UnknownRoles(),
            ),
          );
        }
      } else {
        var errorData = jsonDecode(result.body);
        int statusCode = errorData['status'];
        String title = errorData['title'];

        if (!mounted) return;

        errorDialog(
          context: context,
          statusCode: statusCode,
          description: title,
          color: Colors.green,
        );
      }
    } else {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.indigo.shade900,
              Colors.indigo.shade500,
              Colors.purple.shade400,
            ],
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.indigo.shade50,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_person_rounded,
                      size: 64,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    "Welcome Back",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade900,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "Login to manage your account",
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        emailTextField(emailController: _emailController),
                        const SizedBox(height: 20),
                        passwordTextField(passwordController: _passwordController),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 56,
                          child: ElevatedButton(
                            onPressed: submitForm,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo.shade700,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                              elevation: 4,
                            ),
                            child: const Text(
                              "Login",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account? ",
                      style: TextStyle(color: Colors.grey.shade700),
                      children: [
                        TextSpan(
                          text: "Register Here",
                          style: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.bold,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const RegisterPage(),
                                ),
                              );
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
