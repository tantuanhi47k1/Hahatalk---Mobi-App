import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Cần thêm cái này để dùng Timestamp

class ChatBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;
  final Timestamp createdAt; // 1. Thêm biến thời gian vào đây

  const ChatBubble({
    super.key,
    required this.text,
    required this.sender,
    required this.isMe,
    required this.createdAt, // 2. Yêu cầu phải có thời gian khi gọi Bubble
  });

  @override
  Widget build(BuildContext context) {
    // Chuyển đổi Timestamp của Firebase thành giờ:phút của Dart
    final dateTime = createdAt.toDate();
    final String timeString = "${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}";

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        decoration: BoxDecoration(
          color: isMe ? Colors.blueAccent : Colors.grey[300],
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(15),
            topRight: const Radius.circular(15),
            bottomLeft: Radius.circular(isMe ? 15 : 0),
            bottomRight: Radius.circular(isMe ? 0 : 15),
          ),
        ),
        child: Column(
          crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              sender,
              style: TextStyle(
                fontSize: 10,
                color: isMe ? Colors.white70 : Colors.black54,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              text,
              style: TextStyle(
                color: isMe ? Colors.white : Colors.black87, 
                fontSize: 16
              ),
            ),
            const SizedBox(height: 4),
            // 3. Hiển thị giờ gửi nhỏ xinh ở góc dưới
            Text(
              timeString,
              style: TextStyle(
                fontSize: 9,
                color: isMe ? Colors.white60 : Colors.black45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}