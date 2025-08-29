import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/admin/presentation/sync_screen.dart';
import 'package:flutter_paint_store_app/features/other/presentation/kiotviet_config_screen.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/presentation/kiot_viet_test_screen.dart';

class OtherScreen extends ConsumerWidget {
  final String userRole;
  const OtherScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Khác / Quản trị'),
      ),
      body: ListView(
        children: [
          if (userRole == 'admin') ...[
            _buildAdminSection(context),
            const Divider(),
          ],
          _buildDeveloperSection(context),
          const Divider(),
          _buildLogoutTile(context),
        ],
      ),
    );
  }

  Widget _buildAdminSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Quản trị',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
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
        ListTile(
          leading: const Icon(Icons.sync),
          title: const Text('Đồng bộ KiotViet'),
          subtitle: const Text('Đồng bộ dữ liệu từ KiotViet về Firebase'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const SyncScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildDeveloperSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: Text(
            'Công cụ phát triển',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
        ),
        ListTile(
          leading: const Icon(Icons.science_outlined),
          title: const Text('Test KiotViet API'),
          subtitle: const Text('Gửi yêu cầu đến KiotViet API proxy'),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const KiotVietTestScreen(),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return ListTile(
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
    );
  }
}
