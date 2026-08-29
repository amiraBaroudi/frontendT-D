import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/secure_storage_service.dart';
import '../../features/auth/presentation/pages/splash_page.dart';
import '../../features/auth/presentation/pages/onboarding_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/otp_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/booking/presentation/pages/booking_step1_page.dart';
import '../../features/booking/presentation/pages/booking_step2_page.dart';
import '../../features/booking/presentation/pages/booking_step3_page.dart';
import '../../features/booking/presentation/pages/price_estimate_page.dart';
import '../../features/booking/presentation/pages/finding_driver_page.dart';
import '../../features/tracking/presentation/pages/tracking_page.dart';
import '../../features/tracking/presentation/pages/delivery_confirmation_page.dart';
import '../../features/tracking/presentation/pages/rating_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/profile/presentation/pages/order_history_page.dart';
import '../../features/profile/presentation/pages/order_detail_page.dart';

class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String otp = '/otp';
  static const String home = '/home';
  static const String bookingStep1 = '/booking/step1';
  static const String bookingStep2 = '/booking/step2';
  static const String bookingStep3 = '/booking/step3';
  static const String priceEstimate = '/booking/price';
  static const String findingDriver = '/booking/finding-driver';
  static const String tracking = '/tracking/:orderId';
  static const String deliveryConfirmation = '/delivery/:orderId';
  static const String rating = '/rating/:orderId';
  static const String profile = '/profile';
  static const String orderHistory = '/orders';
  static const String orderDetail = '/orders/:orderId';

  static String trackingPath(String id) => '/tracking/$id';
  static String deliveryPath(String id) => '/delivery/$id';
  static String ratingPath(String id) => '/rating/$id';
  static String orderDetailPath(String id) => '/orders/$id';
}

class AppRouter {
  final SecureStorageService _storageService;
  AppRouter(this._storageService);

  late final GoRouter router = GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.splash,
        pageBuilder: (c, s) => _fade(const SplashPage(), s),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (c, s) => _fade(const OnboardingPage(), s),
      ),
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (c, s) => _fade(const LoginPage(), s),
      ),
      GoRoute(
        path: AppRoutes.register,
        pageBuilder: (c, s) => _fade(const RegisterPage(), s),
      ),
      GoRoute(
        path: AppRoutes.otp,
        pageBuilder: (c, s) => _fade(OtpPage(phone: s.extra as String), s),
      ),
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (c, s) => _fade(const HomePage(), s),
      ),
      GoRoute(
        path: AppRoutes.bookingStep1,
        pageBuilder: (c, s) => _fade(const BookingStep1Page(), s),
      ),
      GoRoute(
        path: AppRoutes.bookingStep2,
        pageBuilder: (c, s) => _fade(const BookingStep2Page(), s),
      ),
      GoRoute(
        path: AppRoutes.bookingStep3,
        pageBuilder: (c, s) => _fade(const BookingStep3Page(), s),
      ),
      GoRoute(
        path: AppRoutes.priceEstimate,
        pageBuilder: (c, s) => _fade(const PriceEstimatePage(), s),
      ),
      GoRoute(
        path: AppRoutes.findingDriver,
        pageBuilder: (c, s) => _fade(const FindingDriverPage(), s),
      ),
      GoRoute(
        path: AppRoutes.tracking,
        pageBuilder: (c, s) => _fade(
          TrackingPage(orderId: s.pathParameters['orderId']!), s,
        ),
      ),
      GoRoute(
        path: AppRoutes.deliveryConfirmation,
        pageBuilder: (c, s) => _fade(
          DeliveryConfirmationPage(orderId: s.pathParameters['orderId']!), s,
        ),
      ),
      GoRoute(
        path: AppRoutes.rating,
        pageBuilder: (c, s) => _fade(
          RatingPage(orderId: s.pathParameters['orderId']!), s,
        ),
      ),
      GoRoute(
        path: AppRoutes.profile,
        pageBuilder: (c, s) => _fade(const ProfilePage(), s),
      ),
      GoRoute(
        path: AppRoutes.orderHistory,
        pageBuilder: (c, s) => _fade(const OrderHistoryPage(), s),
      ),
      GoRoute(
        path: AppRoutes.orderDetail,
        pageBuilder: (c, s) => _fade(
          OrderDetailPage(orderId: s.pathParameters['orderId']!), s,
        ),
      ),
    ],
  );

  CustomTransitionPage _fade(Widget child, GoRouterState state) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
      transitionDuration: const Duration(milliseconds: 250),
    );
  }
}
