import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Lấy thông tin user hiện tại để hiển thị cho oách
  final user = FirebaseAuth.instance.currentUser;

  // Danh sách bạn bè mẫu (Sau này Tuấn có thể lấy từ Firestore)
  final List<Map<String, String>> friends = [
    {"name": "Crush", "id": "chat_crush_99", "email": "abc@gmail.com"},
    {"name": "Anh Đồng Nghiệp", "id": "chat_work_01", "email": "dongnghiep@gmail.com"},
    {"name": "Nhóm Dev Đắk Lắk", "id": "group_it_88", "email": "Group Chat"},
  ];

  // Hàm xử lý đăng xuất
  void _logout() async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Xác nhận"),
        content: const Text("Tuấn có muốn đăng xuất không?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Hủy"),
          ),
          TextButton(
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              if (mounted) Navigator.pop(context);
            },
            child: const Text("Đăng xuất", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text(
            "HahaTalk",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          centerTitle: false, // Để tiêu đề bên trái cho giống Messenger
          actions: [
            // Hiển thị email user thu nhỏ cạnh nút logout
            Center(
              child: Text(
                user?.email?.split('@')[0] ?? "",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ),
            IconButton(
              onPressed: _logout,
              icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            ),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(icon: Icon(Icons.person), text: "Bạn bè"),
              Tab(icon: Icon(Icons.group), text: "Nhóm"),
            ],
            indicatorColor: Colors.blueAccent,
            labelColor: Colors.blueAccent,
          ),
        ),
        body: TabBarView(
          children: [
            _buildFriendList(), // Tab Bạn bè
            const Center(child: Text("Tính năng nhóm sắp ra mắt!")), // Tab Nhóm
          ],
        ),
        // Nút thêm bạn mới (Floating Action Button) nhìn cho chuyên nghiệp
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Tính năng thêm bạn đang phát triển!")),
            );
          },
          backgroundColor: Colors.blueAccent,
          child: const Icon(Icons.message_rounded, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildFriendList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(vertical: 10),
      itemCount: friends.length,
      separatorBuilder: (context, index) => const Divider(indent: 70, height: 1),
      itemBuilder: (context, index) {
        final friend = friends[index];
        return ListTile(
          leading: CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blueAccent.withOpacity(0.1),
            child: Text(
              friend['name']![0], // Lấy chữ cái đầu làm Avatar
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
            ),
          ),
          title: Text(
            friend['name']!,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text("Nhấn để bắt đầu chat với ${friend['email']}"),
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
          onTap: () {
            // Chuyển sang màn hình chat và truyền ID
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  chatTitle: friend['name']!,
                  chatId: friend['id']!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}