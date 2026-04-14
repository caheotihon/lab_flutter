import 'package:dio/dio.dart';

class ApiService {
  final Dio dio = Dio();

  final String baseUrl = "https://69dde302410caa3d47ba20dd.mockapi.io/";

  Future<void> send(String endpoint, Map<String, dynamic> data) async {
    try {
      final Response response = await dio.post("$baseUrl$endpoint", data: data);

      print("Thành công: ${response.data}");
    } catch (e) {
      print("Dio error: $e");
    }
  }

  // Thêm hàm này vào class ApiService
  Future<List<dynamic>> getUsers(String endpoint) async {
    try {
      final response = await dio.get("$baseUrl$endpoint");
      return response.data;
    } catch (e) {
      print("Lỗi lấy dữ liệu: $e");
      return [];
    }
  }

  // Hàm cập nhật mật khẩu mới (Reset về "1")
  Future<bool> updatePassword(String endpoint, String userId, Map<String, dynamic> data) async {
    try {
      // Sử dụng put để ghi đè dữ liệu user đó theo ID
      final response = await dio.put("$baseUrl$endpoint/$userId", data: data);
      return response.statusCode == 200; 
    } catch (e) {
      print("Lỗi cập nhật: $e");
      return false;
    }
  }
}
