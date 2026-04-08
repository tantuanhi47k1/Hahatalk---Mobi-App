import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  const ChatScreen({super.key, required this.userName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userName), // Hiển thị tên người đang chat
      ),
      body: Column(
        children: [
          // Phần hiển thị tin nhắn (Chiếm hết khoảng trống phía trên)
          Expanded(
            child: ListView.builder(
              reverse: true, // Tin nhắn mới nhất nằm ở dưới cùng
              itemCount: 5, 
              itemBuilder: (context, index) {
                bool isMe = index % 2 == 0; // Giả lập tin nhắn của mình và của bạn
                return Align(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isMe ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Text(
                      'Đây là nội dung tin nhắn HahaTalk $index',
                      style: TextStyle(color: isMe ? Colors.white : Colors.black),
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Phần khung nhập tin nhắn ở dưới cùng
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            color: Colors.white,
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo, color: Colors.blue),
                  onPressed: () {}, // Nút gửi ảnh
                ),
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Nhập tin nhắn...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: () {}, // Nút gửi tin nhắn
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}