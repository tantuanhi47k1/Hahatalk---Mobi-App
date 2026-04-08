import 'package:flutter/material.dart';
import 'chat_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('HahaTalk', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      // Dùng ListView để tạo danh sách cuộn được
      body: ListView.builder(
        itemCount: 10, // Giả sử có 10 cuộc hội thoại
        itemBuilder: (context, index) {
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blue[100],
              child: Icon(Icons.person, color: Colors.blue[800]), // Avatar mặc định
            ),
            title: Text('Người dùng ${index + 1}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: const Text('Ê, đi cafe không bạn yêu?'),
            trailing: const Text('15:30', style: TextStyle(color: Colors.grey, fontSize: 12)),
            onTap: () {
              // Chuyển sang màn hình Chat khi bấm vào
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatScreen(userName: 'Người dùng ${index + 1}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}