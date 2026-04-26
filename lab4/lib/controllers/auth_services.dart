import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // 1. Đăng ký tài khoản mới (Email & Password)
  Future<String?> signUp({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message; // Trả về thông báo lỗi từ Firebase
    }
  }

  // 2. Đăng nhập
  Future<String?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Success";
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  // 3. Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // 4. Lấy thông tin User hiện tại (nếu có)
  User? get currentUser => _auth.currentUser;

  // 5. Stream lắng nghe trạng thái đăng nhập (để tự động đổi màn hình)
  Stream<User?> get authStateChanges => _auth.authStateChanges();
}