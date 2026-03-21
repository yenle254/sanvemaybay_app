import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Nhớ import đường dẫn file login_page.dart của ông vào đây
import 'authentication/login_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

// Bọc MaterialApp để quản lý chuyển trang (Navigator) không bị lỗi
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Săn Vé Máy Bay',
      debugShowCheckedModeBanner: false, // Tắt chữ Debug góc phải
      home: LoginPage(), // Ép app mở lên là vào thẳng trang Login
    );
  }
}