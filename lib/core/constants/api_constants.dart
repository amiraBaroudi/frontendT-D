class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.naql.app/api/v1';
  // Change to your local IP during development, e.g.:
  // static const String baseUrl = 'http://192.168.1.100:3000/api/v1';

  static const Duration connectTimeout = Duration(seconds: 15);
  static const Duration receiveTimeout = Duration(seconds: 30);

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refresh = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String verifyOtp = '/auth/verify-otp';
  static const String resendOtp = '/auth/resend-otp';

  // Orders
  static const String orders = '/orders';
  static const String orderHistory = '/orders/history';
  static String orderById(String id) => '/orders/$id';
  static String orderStatus(String id) => '/orders/$id/status';
  static String orderPhotos(String id) => '/orders/$id/photos';
  static String orderTracking(String id) => '/orders/$id/tracking';
  static String orderCancel(String id) => '/orders/$id/cancel';

  // Drivers
  static const String nearbyDrivers = '/drivers/nearby';

  // Profile
  static const String profile = '/profile';
  static const String savedAddresses = '/profile/addresses';
  static const String updateProfile = '/profile/update';

  // Reviews
  static String submitReview(String orderId) => '/orders/$orderId/review';

  // Socket Events
  static const String socketBaseUrl = 'wss://api.naql.app';
  static const String eventOrderTracking = 'order:tracking';
  static const String eventOrderStatusChanged = 'order:status_changed';
  static const String eventChatMessage = 'chat:message';
  static const String eventDriverLocation = 'driver:location';
}
