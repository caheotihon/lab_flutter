import 'package:flutter/material.dart';
import 'package:user_management/accounts/login.dart';
import 'package:user_management/admin_area/add_role.dart';
import 'package:user_management/admin_area/add_user.dart';
import 'package:user_management/admin_area/change_admin_password.dart';
import 'package:user_management/admin_area/edit_profile.dart';
import 'package:user_management/admin_area/get_roles.dart';
import 'package:user_management/admin_area/get_users.dart';
import 'package:user_management/admin_area/select_user.dart';
import 'package:user_management/constants/app_colors.dart';
import 'package:user_management/constants/token_handler.dart';
import 'package:user_management/services/fetch_email.dart';
import 'package:user_management/services/role_check.dart';
import 'package:user_management/shared/custom_appbar.dart';
import 'package:user_management/shared/submit_button.dart';

class AdminMainPage extends StatefulWidget {
  const AdminMainPage({super.key});

  @override
  State<AdminMainPage> createState() => _AdminMainPageState();
}

class _AdminMainPageState extends State<AdminMainPage> {
  List<Map<String, dynamic>> buttons = [];
  late String email;

  @override
  void initState() {
    RoleCheck().checkAdminRole(context);
    email = fetchEmailFromToken(context: context);
    addButtonData(context);
    super.initState();
  }

  void addButtonData(BuildContext context) {
    buttons.addAll(
      [
        {
          'title': 'Show Users',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const GetUsers()));
          }
        },
        {
          'title': 'Add New Users',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddUser(),
              ),
            );
          },
        },
        {
          'title': 'Show Roles',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const GetRoles(),
              ),
            );
          },
        },
        {
          'title': 'Add New Roles',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddRole(),
              ),
            );
          },
        },
        {
          'title': 'Change User Roles',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SelectUser(),
              ),
            );
          },
        },
        {
          'title': 'Edit Profile',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditProfile(
                  email: email,
                ),
              ),
            );
          },
        },
        {
          'title': 'Change Password',
          'backgroundColor': AppColors.adminPage,
          'textColor': Colors.white,
          'onPressed': () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeAdminPassword(
                  email: email,
                ),
              ),
            );
          },
        },
        {
          'title': 'Logout',
          'backgroundColor': AppColors.adminPage,
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
        title: "Admin Dashboard",
        color: AppColors.adminPage.withOpacity(0.8),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Management Tools",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.indigo.shade900,
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
                childAspectRatio: 1.1,
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
                          color: Colors.indigo.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.indigo.shade50,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _getIconForTitle(button['title']),
                            color: Colors.indigo.shade700,
                            size: 28,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Text(
                            button['title'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Colors.indigo.shade900,
                            ),
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
      case 'Show Users':
        return Icons.people_outline_rounded;
      case 'Add New Users':
        return Icons.person_add_outlined;
      case 'Show Roles':
        return Icons.verified_user_outlined;
      case 'Add New Roles':
        return Icons.add_moderator_outlined;
      case 'Change User Roles':
        return Icons.swap_horiz_rounded;
      case 'Edit Profile':
        return Icons.edit_note_rounded;
      case 'Change Password':
        return Icons.password_rounded;
      case 'Logout':
        return Icons.logout_rounded;
      default:
        return Icons.grid_view_rounded;
    }
  }
}
