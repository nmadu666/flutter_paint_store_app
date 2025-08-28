import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/features/other/presentation/kiotviet_config_screen.dart';

class OtherScreen extends StatelessWidget {
  final String userRole;
  const OtherScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khác / Quản trị')),
      body: ListView(
        children: [
          if (userRole == 'admin')
            ListTile(
              leading: const Icon(Icons.settings_applications),
              title: const Text('Cấu hình KiotViet'),
              subtitle: const Text('Quản lý thông tin kết nối KiotViet API'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const KiotVietConfigScreen(),
                  ),
                );
              },
            ),
          const Divider(),
          ListTile(
            leading: Icon(
              Icons.logout,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Đăng xuất',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            onTap: () async {
              await FirebaseAuth.instance.signOut();
            },
          ),
        ],
      ),
    );
  }
}