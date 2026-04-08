import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(const HahaTalkApp());
}

class HahaTalkApp extends StatelessWidget {
  const HahaTalkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HahaTalk',
      theme: ThemeData(
        primarySwatch: Colors.blue, // Bạn có thể đổi màu chủ đạo ở đây
      ),
      home: const HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}