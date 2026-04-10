import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart';
import 'screens/login_screen.dart';

void main() async {
  // Đảm bảo Flutter framework đã sẵn sàng trước khi gọi Firebase
  WidgetsFlutterBinding.ensureInitialized();
  
  // Khởi tạo Firebase với cấu hình mới nhất bạn vừa cập nhật (API Key mới)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const HahaTalkApp());
}

class HahaTalkApp extends StatelessWidget {
  const HahaTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HahaTalk',
      // Style Blue hiện đại, chuẩn Material 3
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
        // Thêm font hoặc các tùy chỉnh AppBar chung ở đây nếu muốn
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
        ),
      ),
      
      // BỘ LỌC ĐĂNG NHẬP: Đây là trái tim của hệ thống tài khoản
      home: StreamBuilder<User?>(
        // Lắng nghe mọi thay đổi: Đăng nhập, Đăng xuất, Token hết hạn...
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. Nếu Firebase đang bận kiểm tra dữ liệu
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          // 2. Nếu đã có dữ liệu User -> Cho vào thẳng HomeScreen
          if (snapshot.hasData) {
            return const HomeScreen();
          }
          
          // 3. Nếu chưa đăng nhập hoặc đã đăng xuất -> Bắt ở lại LoginScreen
          return const LoginScreen();
        },
      ),
    );
  }
}