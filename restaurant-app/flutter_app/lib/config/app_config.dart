class AppConfig {
  // Thay đổi 'localhost' thành '10.0.2.2' nếu chạy trên giả lập Android
  static const String baseUrl = 'http://localhost:3000/api';
  
  static const String loginUrl = '$baseUrl/auth/login';
  static const String registerUrl = '$baseUrl/auth/register';
  static const String forgotPasswordUrl = '$baseUrl/auth/forgot-password';
  static const String categoriesUrl = '$baseUrl/categories';
  static const String foodsUrl = '$baseUrl/foods';
  static const String ordersUrl = '$baseUrl/orders';
  static const String cartUrl = '$baseUrl/cart';
}
