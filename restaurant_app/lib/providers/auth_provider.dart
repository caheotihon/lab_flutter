import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Đăng ký tài khoản và lưu vào Firestore
  Future<void> signUp(String email, String password, String fullName) async {
    try {
      // 1. Tạo tài khoản Firebase
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // 2. Lưu tên và email vào collection USERS trên Firebase, dùng uid làm document id
      final uid = userCredential.user?.uid ?? email;
      await _firestore.collection('USERS').doc(uid).set({
        'email': email,
        'fullName': fullName,
        'uid': uid,
      });

      notifyListeners();
    } on FirebaseAuthException catch (e) {
      // Map common Firebase auth errors to user-friendly messages
      String message;
      switch (e.code) {
        case 'email-already-in-use':
          message = 'Email này đã được sử dụng bởi tài khoản khác. Vui lòng đăng nhập hoặc đặt lại mật khẩu.';
          break;
        case 'invalid-email':
          message = 'Email không hợp lệ.';
          break;
        case 'weak-password':
          message = 'Mật khẩu quá yếu. Vui lòng chọn mật khẩu mạnh hơn.';
          break;
        default:
          message = 'Lỗi đăng ký: ${e.message}';
      }
      print('Lỗi đăng ký: ${e.code} - ${e.message}');
      throw Exception(message);
    } catch (e) {
      print("Lỗi đăng ký: $e");
      rethrow;
    }
  }

  // Đăng nhập
  Future<void> login(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      // Đăng nhập thành công thì thông báo cho UI cập nhật
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'Không tìm thấy tài khoản với email này.';
          break;
        case 'wrong-password':
          message = 'Mật khẩu không đúng.';
          break;
        default:
          message = 'Lỗi đăng nhập: ${e.message}';
      }
      print('Lỗi đăng nhập: ${e.code} - ${e.message}');
      throw Exception(message);
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      rethrow;
    }
  }

  // Đăng xuất
  Future<void> logout() async {
    await _auth.signOut();
    notifyListeners();
  }
}