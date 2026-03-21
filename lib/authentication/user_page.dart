import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'authentication/login_page.dart';
import 'package:sanvemaybay_app_fixed/page/home_page.dart';

import 'login_page.dart';

class UserPage extends StatefulWidget {
  const UserPage({super.key});

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? currentUser;

  @override
  void initState() {
    super.initState();
    // Lấy thông tin user hiện tại khi mở trang
    currentUser = _auth.currentUser;
  }

  // Hàm Đăng xuất
  Future<void> _handleSignOut() async {
    await _auth.signOut();
    // Cập nhật lại giao diện ngay lập tức thành "Chưa đăng nhập"
    setState(() {
      currentUser = null;
    });
  }

  // Hàm Thay đổi tên hiển thị
  Future<void> _editName() async {
    TextEditingController nameController = TextEditingController(text: currentUser?.displayName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Đổi tên hiển thị"),
        content: TextField(
          controller: nameController,
          decoration: const InputDecoration(hintText: "Nhập tên mới"),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
          ElevatedButton(
            onPressed: () async {
              if (nameController.text.trim().isNotEmpty) {
                // Cập nhật tên trên Firebase Auth
                await currentUser?.updateDisplayName(nameController.text.trim());
                // Cập nhật tên trên Firestore (nếu ông có lưu ở collection 'users')
                await FirebaseFirestore.instance.collection('users').doc(currentUser!.uid).update({
                  'fullName': nameController.text.trim(),
                });

                // Tải lại dữ liệu user mới nhất
                await currentUser?.reload();
                setState(() {
                  currentUser = _auth.currentUser;
                });
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Cập nhật tên thành công!'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text("Lưu"),
          ),
        ],
      ),
    );
  }

  // Hàm Thay đổi Avatar (Tạm thời giữ chỗ, cần cài package image_picker để chọn ảnh thật)
  void _changeAvatar() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Tính năng chọn ảnh từ thư viện đang được phát triển!')),
    );
    // Sau này ông cài package image_picker và firebase_storage để up ảnh ở đây nhé.
  }

  @override
  Widget build(BuildContext context) {
    // NẾU CHƯA ĐĂNG NHẬP (Hoặc vừa Đăng xuất) -> Hiện giao diện GUEST
    if (currentUser == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.account_circle, size: 100, color: Colors.grey),
                const SizedBox(height: 20),
                const Text("Bạn chưa đăng nhập", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 10),
                const Text("Vui lòng đăng nhập để quản lý tài khoản và vé máy bay của bạn.", textAlign: TextAlign.center, style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 40),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginPage())),
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFC21500), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                    child: const Text("ĐĂNG NHẬP", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 15),
                TextButton(
                  onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage())),
                  child: const Text("Bỏ qua, về Trang chủ", style: TextStyle(color: Colors.black54, fontSize: 16)),
                ),
              ],
            ),
          ),
        ),
      );
    }


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text("Tài khoản của bạn", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () => Navigator.pop(context), // Đóng trang
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Phần Avatar
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey.shade300,
                    backgroundImage: currentUser?.photoURL != null ? NetworkImage(currentUser!.photoURL!) : null,
                    child: currentUser?.photoURL == null ? const Icon(Icons.person, size: 50, color: Colors.white) : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: _changeAvatar,
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(color: Colors.black87, shape: BoxShape.circle, border: Border.all(color: Colors.white, width: 2)),
                        child: const Icon(Icons.camera_alt, color: Colors.white, size: 16),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 15),

            // Tên và Nút sửa tên
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  currentUser?.displayName ?? "Chưa thiết lập tên",
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.edit, size: 18, color: Colors.grey),
                  onPressed: _editName,
                ),
              ],
            ),

            // Email người dùng
            Text(
              currentUser?.email ?? "Không có email",
              style: const TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 30),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),

            // Nút Log Out duy nhất ở dưới
            ListTile(
              leading: const Icon(Icons.power_settings_new, color: Colors.red),
              title: const Text("Đăng xuất", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              onTap: () {
                // Xác nhận trước khi đăng xuất
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text("Đăng xuất"),
                    content: const Text("Bạn có chắc chắn muốn đăng xuất khỏi tài khoản này?"),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text("Hủy")),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        onPressed: () {
                          Navigator.pop(context); // Đóng bảng hỏi
                          _handleSignOut(); // Tiến hành đăng xuất
                        },
                        child: const Text("Đăng xuất", style: TextStyle(color: Colors.white)),
                      ),
                    ],
                  ),
                );
              },
            ),
            const Divider(thickness: 1, color: Color(0xFFEEEEEE)),
          ],
        ),
      ),
    );
  }
}