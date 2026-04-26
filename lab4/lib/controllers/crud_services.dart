import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CRUDService {
  // Thay vì dùng biến cố định, ta tạo một getter để luôn lấy UID mới nhất từ Firebase
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? "";

  // 1. THÊM MỚI DANH BẠ
  Future<void> addNewContact(String name, String phone) async {
    if (userId.isEmpty) return; // Kiểm tra nếu chưa login

    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId) // Luôn lấy UID mới nhất ở đây
          .collection("contacts")
          .add({
        "name": name,
        "phone": phone,
        "createdAt": DateTime.now(),
      });
    } catch (e) {
      print("Lỗi khi thêm: $e");
    }
  }

  // 2. CẬP NHẬT DANH BẠ
  Future<void> updateContact(String docId, String name, String phone) async {
    if (userId.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("contacts")
          .doc(docId)
          .update({
        "name": name,
        "phone": phone,
      });
    } catch (e) {
      print("Lỗi khi cập nhật: $e");
    }
  }

  // 3. XÓA DANH BẠ
  Future<void> deleteContact(String docId) async {
    if (userId.isEmpty) return;
    try {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(userId)
          .collection("contacts")
          .doc(docId)
          .delete();
    } catch (e) {
      print("Lỗi khi xóa: $e");
    }
  }

  // 4. LẤY DANH SÁCH DANH BẠ (STREAM)
  Stream<QuerySnapshot> getContacts() {
    if (userId.isEmpty) {
      // Trả về một stream trống nếu chưa login để tránh lỗi đỏ màn hình
      return const Stream.empty();
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(userId)
        .collection("contacts")
        .orderBy("createdAt", descending: true)
        .snapshots();
  }
}