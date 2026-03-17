import 'package:flutter/material.dart';
import '../core/screens/home_screen.dart';
import '../core/screens/profile_screen.dart';
import '../core/screens/details_screen.dart';
import '../core/screens/login_screen.dart';
import '../core/screens/register_screen.dart';
import '../core/screens/intro_screen.dart';
import '../core/screens/chat_screen.dart';

/// Class quản lý tất cả routes trong app
class AppRoutes {
  // Định nghĩa tên các routes
  static const String home = '/';
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String details = '/details';
  static const String login = '/login';
  static const String register = '/register';
  static const String intro = '/intro';
  static const String chat = '/chat';

  /// Map chứa tất cả routes và màn hình tương ứng
  static Map<String, WidgetBuilder> getRoutes() {
    return {
      home: (context) => const HomeScreen(),
      profile: (context) => const ProfileScreen(),
      details: (context) => const DetailsScreen(),
      login: (context) => const LoginScreen(),
      register: (context) => const RegisterScreen(),
      intro: (context) => const IntroScreen(),
    };
  }

  /// Hàm xử lý route động (nếu cần)
  /// Dùng khi bạn muốn xử lý routes phức tạp hơn
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case profile:
        return MaterialPageRoute(builder: (context) => const ProfileScreen());
      case details:
        return MaterialPageRoute(
          builder: (context) => const DetailsScreen(),
          settings: settings,
        );
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (context) => const RegisterScreen());
      case intro:
        return MaterialPageRoute(builder: (context) => const IntroScreen());
      case chat:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (context) => ChatScreen(
            documentTitle: args?['title'] ?? 'Tài liệu mới',
            documentIcon: args?['icon'] ?? Icons.description_outlined,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error')),
            body: const Center(child: Text('Page not found!')),
          ),
        );
    }
  }
}
