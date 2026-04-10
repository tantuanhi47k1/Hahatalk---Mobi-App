import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import thêm cái này để lấy User
import '../widgets/chat_bubble.dart'; 
import '../models/message_model.dart'; 

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  final String chatId;

  const ChatScreen({super.key, required this.chatTitle, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // TỰ ĐỘNG LẤY EMAIL: Không cần nhập tay nữa Tuấn nhé
  late String myName; 

  @override
  void initState() {
    super.initState();
    // Lấy email người dùng hiện tại, nếu không có thì để là "Ẩn danh"
    // split('@')[0] giúp lấy tên trước chữ @ cho gọn (VD: tuanbtpk04033)
    myName = FirebaseAuth.instance.currentUser?.email?.split('@')[0] ?? "User";
  }

  void _sendMessage() async {
    if (_controller.text.trim().isNotEmpty) {
      final newMessage = MessageModel(
        sender: myName,
        text: _controller.text.trim(),
        createdAt: Timestamp.now(),
        chatId: widget.chatId,
      );

      await _firestore.collection('messages').add(newMessage.toMap());
      _controller.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Nền hơi xám cho nổi bong bóng chat
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.chatTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text("Đang dùng tài khoản: $myName", 
                 style: const TextStyle(fontSize: 11, color: Colors.blueAccent)),
          ],
        ),
        elevation: 1,
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('messages')
                  .where('chatId', isEqualTo: widget.chatId)
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasError) return const Center(child: Text("Lỗi kết nối Firebase"));
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                final docs = snapshot.data!.docs;
                
                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  padding: const EdgeInsets.all(10),
                  itemBuilder: (context, index) {
                    var data = docs[index].data() as Map<String, dynamic>;
                    var msg = MessageModel.fromMap(data);
                    
                    // Logic phân biệt: Nếu sender trùng với myName thì là tin của mình
                    return ChatBubble(
                      text: msg.text,
                      sender: msg.sender,
                      isMe: msg.sender == myName,
                      createdAt: msg.createdAt, 
                    );
                  },
                );
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
      ),
      child: SafeArea( // Đảm bảo không bị dính vào vạch dưới của iPhone/Android đời mới
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Aa',
                  filled: true,
                  fillColor: Colors.grey[100],
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.send_rounded, color: Colors.blueAccent, size: 28),
              onPressed: _sendMessage,
            ),
          ],
        ),
      ),
    );
  }
}