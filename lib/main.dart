import 'package:edumate/core/theme/theme.dart';
import 'package:flutter/material.dart';
import 'routes/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Routing Demo',
      theme: wgerLightTheme,
      // Cách 1: Sử dụng routes map (đơn giản)
      routes: AppRoutes.getRoutes(),
      initialRoute: AppRoutes.home,
      
      // Cách 2: Sử dụng onGenerateRoute (linh hoạt hơn, xử lý được routes động)
      // onGenerateRoute: AppRoutes.onGenerateRoute,
      
      // Xử lý route không tồn tại (404 page)
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            appBar: AppBar(title: const Text('Error 404')),
            body: const Center(
              child: Text('Trang không tồn tại!'),
            ),
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
