import 'package:flutter/material.dart';
import 'api_service.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final ApiService _apiService = ApiService(); // Khởi tạo một lần dùng chung

  void _handleResetPassword() async {
    String email = _emailController.text.trim();

    if (email.isEmpty) {
      _showSimpleDialog("Thông báo", "Vui lòng nhập Email!");
      return;
    }

    // Hiển thị Loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const Center(child: CircularProgressIndicator()),
    );

    try {
      // 1. Lấy danh sách users
      List<dynamic> users = await _apiService.getUsers("users");

      // 2. Tìm user khớp email
      dynamic targetUser;
      for (var user in users) {
        if (user['email'] == email) {
          targetUser = user;
          break;
        }
      }

      if (mounted) Navigator.pop(context); // Tắt Loading

      if (targetUser != null) {
        // 3. Tiến hành reset password về "1"
        String userId = targetUser['id'].toString();
        
        // Tạo map dữ liệu mới, giữ nguyên các thông tin cũ, chỉ đổi password
        Map<String, dynamic> updateData = Map<String, dynamic>.from(targetUser);
        updateData['password'] = "1";

        bool isUpdated = await _apiService.updatePassword("users", userId, updateData);

        if (isUpdated) {
          _showSuccessDialog("Đã reset password về '1' thành công!");
        } else {
          _showSimpleDialog("Lỗi", "Không thể cập nhật mật khẩu trên server.");
        }
      } else {
        _showSimpleDialog("Thông báo", "Email không tồn tại trong hệ thống!");
      }
    } catch (e) {
      if (mounted) Navigator.pop(context);
      _showSimpleDialog("Lỗi", "Đã xảy ra lỗi kết nối!");
    }
  }

  void _showSimpleDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
        ],
      ),
    );
  }

  void _showSuccessDialog(String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Thông báo"),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Đóng Dialog
              Navigator.pop(context); // Quay về màn hình Login
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset password'), centerTitle: true),
      body: SingleChildScrollView( // Thêm để tránh lỗi tràn màn hình khi hiện bàn phím
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            const Icon(
              Icons.replay_circle_filled,
              size: 100,
              color: Colors.orange,
            ),
            const SizedBox(height: 30),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _handleResetPassword,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                child: const Text('Reset password'),
              ),
            ),
            const SizedBox(height: 12),
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
}