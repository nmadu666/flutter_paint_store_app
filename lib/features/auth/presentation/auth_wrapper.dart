import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/features/auth/presentation/login_screen.dart';
import 'package:flutter_paint_store_app/features/shell/presentation/responsive_shell.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<String> _getUserRole(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.containsKey('role')) {
        return userDoc.data()!['role'] as String;
      }
      return 'sale'; // Default role
    } catch (e) {
      debugPrint('Lỗi khi lấy role người dùng: $e');
      return 'sale'; // Default role on error
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (authSnapshot.hasData) {
          final user = authSnapshot.data!;
          return FutureBuilder<String>(
            future: _getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (roleSnapshot.hasError) {
                return const Scaffold(
                  body: Center(
                    child: Text('Đã xảy ra lỗi khi tải dữ liệu người dùng.'),
                  ),
                );
              }
              if (roleSnapshot.hasData) {
                return ResponsiveShell(userRole: roleSnapshot.data!);
              }
              return const LoginScreen();
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}
