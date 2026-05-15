import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:user_management/accounts/login.dart';
import 'package:user_management/constants/api_endpoints.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/models/user_model.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/services/role_check.dart';
import 'package:user_management/shared/confirmation_dialog.dart';
import 'package:user_management/shared/custom_appbar.dart';
import 'package:user_management/shared/error_dialog.dart';
import 'package:user_management/shared/submit_button.dart';
import 'package:user_management/shared/user_details.dart';
import 'package:user_management/users_area/change_user_password.dart';
import 'package:user_management/users_area/edit_user_profile.dart';
import 'package:http/http.dart' as http;

class UsersMainPage extends StatefulWidget {
  const UsersMainPage({super.key});

  @override
  State<UsersMainPage> createState() => _UsersMainPageState();
}

class _UsersMainPageState extends State<UsersMainPage> {
  List<Map<String, dynamic>> buttons = [];
  late String email;

  @override
  void initState() {
    super.initState();
    RoleCheck().checkUserRole(context);
    email = fetchEmailFromToken(context: context);
    addButtonData(context);
  }

  Future<void> getUserInfo({required String email}) async {
    if (email.isEmpty) {
      return;
    }

    final result = await http.post(
      Uri.parse(ApiEndpoints.userInfoReadUpdate),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenHandler().getToken()}',
      },
      body: jsonEncode(email),
    );

    if (result.statusCode >= 200 && result.statusCode <= 299) {
      final jsonData = json.decode(result.body);
      final user = UserModel.fromJson(jsonData);

      if (!mounted) return;
      userDetails(
        context: context,
        user: user,
        color: AppColors.userPage,
      );
    } else {
      var errorBody = jsonDecode(result.body);
      final error = errorBody['message'] ?? "An error occurred.";

      if (!mounted) return;

      errorDialog(
        context: context,
        statusCode: result.statusCode,
        description: error,
        color: Colors.green,
      );
    }
  }

  Future<void> deleteUserAccount({required String email}) async {
    if (email.isEmpty) {
      return;
    }

    final result = await http.delete(
      Uri.parse(ApiEndpoints.userDeleteProfile),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer ${TokenHandler().getToken()}',
      },
      body: jsonEncode(email),
    );

    if (result.statusCode >= 200 && result.statusCode <= 299) {
      TokenHandler().clearToken();
      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false,
      );
    } else {
      var errorBody = jsonDecode(result.body);
      final error = errorBody['message'] ?? "An error occurred.";

      if (!mounted) return;

      errorDialog(
        context: context,
        statusCode: result.statusCode,
        description: error,
        color: Colors.green,
      );
    }
  }

  void addButtonData(BuildContext context) {
    buttons.addAll(
      [
        {
          'title': 'User Info',
          'backgroundColor': AppColors.userPage,
          'textColor': Colors.white,
          'onPressed': () {
            getUserInfo(email: email);
          },
        },
        {
          'title': 'Edit Profile',
          'backgroundColor': AppColors.userPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditUserProfile(email: email),
              ),
            );
          }
        },
        {
          'title': 'Change Password',
          'backgroundColor': AppColors.userPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeUserPassword(email: email),
              ),
            );
          }
        },
        {
          'title': 'Delete Account',
          'backgroundColor': AppColors.userPage,
          'textColor': Colors.white,
          'onPressed': () async {
            bool? confirmed = await showConfirmationDialog(
              context: context,
              title: "Confirm",
              content: "Are you sure that you want to delete this user?",
              color: AppColors.userPage,
            );

            if (confirmed) {
              deleteUserAccount(email: email);
            } else {
              return;
            }
          },
        },
        {
          'title': 'Logout',
          'backgroundColor': AppColors.userPage,
          'textColor': Colors.white,
          'onPressed': () {
            TokenHandler().clearToken();

            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
              (Route<dynamic> route) => false,
            );
          },
        },
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: CustomAppbar(
        title: "User Profile",
        color: AppColors.userPage.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
                ),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white24,
                    child: Icon(Icons.person, size: 50, color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    email,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Standard User",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              "Account Actions",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple.shade900,
              ),
            ),
            const SizedBox(height: 16),
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
              ),
              itemCount: buttons.length,
              itemBuilder: (context, index) {
                final button = buttons[index];
                return InkWell(
                  onTap: button['onPressed'],
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _getIconForTitle(button['title']),
                          color: button['title'] == 'Delete Account' 
                              ? Colors.red.shade400 
                              : Colors.deepPurple.shade700,
                          size: 32,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          button['title'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: button['title'] == 'Delete Account' 
                                ? Colors.red.shade900 
                                : Colors.deepPurple.shade900,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForTitle(String title) {
    switch (title) {
      case 'User Info':
        return Icons.info_outline_rounded;
      case 'Edit Profile':
        return Icons.edit_rounded;
      case 'Change Password':
        return Icons.lock_outline_rounded;
      case 'Delete Account':
        return Icons.delete_forever_rounded;
      case 'Logout':
        return Icons.power_settings_new_rounded;
      default:
        return Icons.widgets_outlined;
    }
  }
}
