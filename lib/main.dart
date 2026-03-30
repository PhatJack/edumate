import 'package:edumate/core/config/app_config.dart';
import 'package:edumate/core/providers/documents_provider.dart';
import 'package:edumate/core/providers/profile_provider.dart';
import 'package:edumate/core/theme/theme.dart';
import 'package:edumate/data/services/api_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'routes/app_routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await dotenv.load(fileName: '.env');
  } catch (_) {
    // Allow app to run with fallback config for local/test scenarios.
  }

  if (kIsWeb) {
    final webOptions = AppConfig.firebaseWebOptions;
    if (webOptions == null) {
      throw StateError(
        'Missing Firebase web config. Set FIREBASE_* (or VITE_FIREBASE_*) in .env.',
      );
    }
    await Firebase.initializeApp(options: webOptions);
  } else {
    await Firebase.initializeApp();
  }

  ApiService();
  final documentsNotifier = ValueNotifier<List<DocumentItem>>([]);
  final profileNotifier = ValueNotifier<ProfileSessionState>(
    const ProfileSessionState.initial(),
  );

  runApp(
    ProviderScope(
      child: ProfileProvider(
        notifier: profileNotifier,
        child: DocumentsProvider(
          notifier: documentsNotifier,
          child: const MyApp(),
        ),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool get _isLoggedIn {
    // TODO: Replace this with real auth/session state.
    return false;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'EduMate',
      theme: wgerLightTheme,
      // Sử dụng onGenerateRoute để hỗ trợ truyền arguments qua named routes
      onGenerateRoute: AppRoutes.onGenerateRoute,
      initialRoute: _isLoggedIn ? AppRoutes.home : AppRoutes.intro,

      // Xử lý route không tồn tại (404 page)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error 404')),
            body: const Center(child: Text('Trang không tồn tại!')),
          ),
        );
      },
    );
  }
}

/*
  HƯỚNG DẪN NAVIGATION TRONG FLUTTER:
  
  1. Navigator.push() - Đẩy màn hình mới lên stack
     Navigator.push(context, MaterialPageRoute(builder: (context) => NewScreen()));
  
  2. Navigator.pushNamed() - Đẩy màn hình mới bằng tên route
     Navigator.pushNamed(context, '/profile');
  
  3. Navigator.pop() - Quay lại màn hình trước
     Navigator.pop(context);
  
  4. Navigator.pushReplacement() - Thay thế màn hình hiện tại
     Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => NewScreen()));
  
  5. Navigator.pushReplacementNamed() - Thay thế bằng named route
     Navigator.pushReplacementNamed(context, '/home');
  
  6. Navigator.pushAndRemoveUntil() - Xóa tất cả màn hình cho đến một điều kiện
     Navigator.pushAndRemoveUntil(context, 
       MaterialPageRoute(builder: (context) => HomeScreen()),
       (route) => false
     );
  
  7. Navigator.pushNamed() với arguments
     Navigator.pushNamed(context, '/details', arguments: {'id': 123});
  
  Checkout các file trong lib/core/screens/ để xem ví dụ chi tiết!
*/
