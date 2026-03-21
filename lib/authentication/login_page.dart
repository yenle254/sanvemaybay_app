import 'package:flutter/material.dart';
import '../utils/auth_service.dart'; // THÊM DÒNG NÀY ĐỂ GỌI ĐƯỢC FIREBASE (Sửa lại đường dẫn nếu cần)

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isObscure = true;

  final LinearGradient primaryGradient = const LinearGradient(
    colors: [
      Color(0xFFC21500),
      Color(0xFFFFC500),
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // --- HÀM XỬ LÝ ĐĂNG NHẬP GOOGLE (Đã sửa để hiện bảng chọn Email) ---
  void _handleGoogleSignIn() async {
    try {
      // Gọi hàm đăng nhập xịn từ AuthService của bạn
      final user = await AuthService().signInWithGoogle();

      if (user != null) {
        // Nếu chọn email thành công
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công: ${user.displayName}'), backgroundColor: Colors.green),
        );
        // Chuyển sang trang chủ (Bạn sửa lại tên route '/home' cho khớp với app của bạn nhé)
        // Navigator.pushReplacementNamed(context, '/home');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleSkip() {
    Navigator.pop(context);
  }

  void _handleLogin() {
    print("Code xử lý đăng nhập Email ở đây");
  }

  void _handleForgotPassword() {
    print("Code xử lý quên mật khẩu ở đây");
  }

  void _handleRegister() {
    print("Code chuyển trang Đăng ký ở đây");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      // ĐÃ SỬA LỖI NỀN: Dùng Container full size thay vì Stack
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/plane.jpg'),
            fit: BoxFit.cover, // Đảm bảo ảnh luôn phủ kín màn hình
          ),
        ),
        child: Container(
          // Lớp phủ đen mờ 30% để dễ đọc chữ
          color: Colors.black.withValues(alpha: 0.3),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topRight,
                      child: TextButton(
                        onPressed: _handleSkip,
                        child: const Text(
                          "Bỏ qua",
                          style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(15),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: const Color(0xFFC21500), width: 3),
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          child: const Icon(Icons.flight_takeoff, size: 60, color: Color(0xFFC21500)),
                        ),
                        const SizedBox(height: 15),
                        const Text(
                          "SĂN VÉ MÁY BAY",
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 1.5),
                        ),
                      ],
                    ),
                    const SizedBox(height: 50),
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Đăng Nhập", style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                    ),
                    const SizedBox(height: 30),
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.email, color: Colors.white),
                        labelText: 'Email',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white54), borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                    ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: _passwordController,
                      obscureText: _isObscure,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock, color: Colors.white),
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: Colors.white),
                          onPressed: () => setState(() => _isObscure = !_isObscure),
                        ),
                        labelText: 'Mật khẩu',
                        labelStyle: const TextStyle(color: Colors.white70),
                        enabledBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white54), borderRadius: BorderRadius.circular(10)),
                        focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Colors.white, width: 2), borderRadius: BorderRadius.circular(10)),
                        filled: true,
                        fillColor: Colors.black26,
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: _handleForgotPassword,
                        child: const Text("Quên mật khẩu?", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      height: 55,
                      decoration: BoxDecoration(
                        gradient: primaryGradient,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.3), spreadRadius: 1, blurRadius: 5, offset: const Offset(0, 3))],
                      ),
                      child: ElevatedButton(
                        onPressed: _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        child: const Text("ĐĂNG NHẬP", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white, letterSpacing: 1.2)),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Row(
                      children: [
                        Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                        Padding(padding: EdgeInsets.symmetric(horizontal: 10.0), child: Text("Hoặc", style: TextStyle(color: Colors.white70, fontSize: 16))),
                        Expanded(child: Divider(color: Colors.white54, thickness: 1)),
                      ],
                    ),
                    const SizedBox(height: 25),

                    // --- ĐÃ SỬA LỖI VỠ KHUNG GOOGLE ---
                    InkWell(
                      onTap: _handleGoogleSignIn,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Thay ảnh bị lỗi bằng chữ G có màu giống Google
                            Text("G", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.blue)),
                            SizedBox(width: 15),
                            Text("Đăng nhập bằng Google", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87)),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                    GestureDetector(
                      onTap: _handleRegister,
                      child: ShaderMask(
                        shaderCallback: (bounds) => primaryGradient.createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
                        blendMode: BlendMode.srcIn,
                        child: const Text("Chưa có tài ? Đăng ký ngay", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, decoration: TextDecoration.underline, color: Colors.white)),
                      ),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}