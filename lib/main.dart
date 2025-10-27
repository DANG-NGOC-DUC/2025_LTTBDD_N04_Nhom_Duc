import 'package:flutter/material.dart';
import 'routes.dart'; // import file chứa appRoutes

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      initialRoute: '/login', // chạy thẳng vào trang login khi mở app
      routes: appRoutes, // sử dụng routes bạn đã định nghĩa
    );
  }
}
