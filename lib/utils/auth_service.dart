import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 1. ĐĂNG KÝ BẰNG EMAIL & PASSWORD
  Future<User?> registerWithEmail(String email, String password, String name) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User? user = result.user;

      if (user != null) {
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': email,
          'fullName': name,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      return user;
    } catch (e) {
      print("Lỗi đăng ký: $e");
      return null;
    }
  }

  // 2. ĐĂNG NHẬP BẰNG EMAIL
  Future<User?> loginWithEmail(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      print("Lỗi đăng nhập: $e");
      return null;
    }
  }

  // 3. ĐĂNG NHẬP BẰNG GOOGLE (Chuẩn lại code ở đây)
  Future<User?> signInWithGoogle() async {
    try {
      // Khởi tạo đối tượng GoogleSignIn trong hàm luôn để tránh lỗi
      final GoogleSignIn googleSignIn = GoogleSignIn();

      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // Hủy đăng nhập

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential result = await _auth.signInWithCredential(credential);
      User? user = result.user;

      // Lưu user mới vào Firestore
      if (user != null) {
        DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
        if (!doc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'fullName': user.displayName ?? "Người dùng Google",
            'createdAt': FieldValue.serverTimestamp(),
          });
        }
      }
      return user;
    } catch (e) {
      print("Lỗi đăng nhập Google: $e");
      return null;
    }

  }

  // 4. ĐĂNG XUẤT
  Future<void> signOut() async {
    await GoogleSignIn().signOut();
    await _auth.signOut();
  }

 //forgot password

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
      print("Đã gửi email khôi phục mật khẩu!");
    } catch (e) {
      print("Lỗi gửi email reset: $e");
      // Ném lỗi ra ngoài để UI hứng và hiển thị thông báo cho user
      throw e;
    }
  }
}