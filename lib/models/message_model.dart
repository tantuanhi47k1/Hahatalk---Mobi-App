import 'package:cloud_firestore/cloud_firestore.dart';

class MessageModel {
  final String sender;
  final String text;
  final Timestamp createdAt;
  final String chatId; // Để phân biệt tin này của nhóm nào hoặc bạn bè nào

  MessageModel({
    required this.sender,
    required this.text,
    required this.createdAt,
    required this.chatId,
  });

  // Chuyển dữ liệu từ Firebase (Json) sang Model của mình
  factory MessageModel.fromMap(Map<String, dynamic> map) {
    return MessageModel(
      sender: map['sender'] ?? '',
      text: map['text'] ?? '',
      createdAt: map['createdAt'] ?? Timestamp.now(),
      chatId: map['chatId'] ?? '',
    );
  }

  // Chuyển từ Model sang Json để đẩy lên Firebase
  Map<String, dynamic> toMap() {
    return {
      'sender': sender,
      'text': text,
      'createdAt': createdAt,
      'chatId': chatId,
    };
  }
}