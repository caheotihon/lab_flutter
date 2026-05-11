import 'package:flutter/material.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  String? _username;
  final ApiService _apiService = ApiService();

  bool get isAuthenticated => _token != null;
  String? get username => _username;
  String? get token => _token;

  Future<String?> login(String email, String password) async {
    try {
      final result = await _apiService.login(email, password);
      if (result['token'] != null) {
        _token = result['token'];
        _username = result['username'];
        notifyListeners();
        return null;
      } else {
        return result['error'] ?? 'Unknown error';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> register(String username, String email, String password) async {
    try {
      final result = await _apiService.register(username, email, password);
      if (result['message'] != null) {
        return null;
      } else {
        return result['error'] ?? 'Unknown error';
      }
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> forgotPassword(String email, String newPassword) async {
    try {
      final result = await _apiService.forgotPassword(email, newPassword);
      if (result['message'] != null) {
        return null;
      } else {
        return result['error'] ?? 'Unknown error';
      }
    } catch (e) {
      return e.toString();
    }
  }

  void logout() {
    _token = null;
    _username = null;
    notifyListeners();
  }
}
