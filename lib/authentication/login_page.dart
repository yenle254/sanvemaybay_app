import 'package:flutter/material.dart';
import '../utils/auth_service.dart';
import 'register_page.dart';
import 'forgot_password_page.dart';
import '../page/home_page.dart';
import 'package:google_sign_in/google_sign_in.dart';

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

  // HÀM XỬ LÝ ĐĂNG NHẬP GOOGLE
  void _handleGoogleSignIn() async {
    try {

      await GoogleSignIn().signOut();


      final user = await AuthService().signInWithGoogle();

      if (user != null) {
        // Nếu chọn email thành công thì báo xanh
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Đăng nhập thành công: ${user.displayName}'), backgroundColor: Colors.green),
        );

        // Rút hẳn trang Login đi và đắp trang Home lên
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) =>  HomePage()),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi đăng nhập: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleSkip() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
    );
  }

  Future<void> _handleLogin() async {
    String email = _emailController.text.trim();
    String password = _passwordController.text.trim();

    // 1. Kiểm tra không được để trống
    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập Email và Mật khẩu!'), backgroundColor: Colors.red),
      );
      return;
    }

    try {
      // 2. Gọi Firebase để kiểm tra tài khoản
      final user = await AuthService().loginWithEmail(email, password);

      if (user != null) {
        // Thành công: Báo xanh và bay vào HomePage
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đăng nhập thành công!'), backgroundColor: Colors.green),
        );

        // Rút trang Login đi và mở Trang chủ
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomePage()),
        );
      } else {
        // Thất bại: Báo đỏ
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Sai Email hoặc Mật khẩu!'), backgroundColor: Colors.red),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _handleForgotPassword() {
    // Chuyển sang trang Quên Mật Khẩu
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  void _handleRegister() {
    // Chuyển sang trang Đăng Ký
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
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


                    InkWell(
                      onTap: _handleGoogleSignIn,
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [

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