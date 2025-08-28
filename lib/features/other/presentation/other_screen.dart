import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/other/presentation/kiotviet_config_screen.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/presentation/kiot_viet_test_screen.dart';

// Provider to control the drawer state. Let's default to true for desktop.
final otherScreenDrawerProvider = StateProvider<bool>((ref) => true);

class OtherScreen extends ConsumerWidget {
  final String userRole;
  const OtherScreen({super.key, required this.userRole});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDrawerOpen = ref.watch(otherScreenDrawerProvider);

    // The original content of the screen
    final mainContent = ListView(
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
    );

    // The new drawer that will be shown on the side
    final sideDrawer = NavigationDrawer(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(28, 16, 16, 10),
          child: Text(
            'Developer Menu',
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.science_outlined),
          title: const Text('Test KiotViet API'),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('Khác / Quản trị'),
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            ref.read(otherScreenDrawerProvider.notifier).update((state) => !state);
          },
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // This is the new side drawer, toggled by the provider
          if (isDrawerOpen)
            SizedBox(
                width: 250, // Typical drawer width
                child: sideDrawer),
          // A divider between the drawer and the content
          if (isDrawerOpen) const VerticalDivider(thickness: 1, width: 1),
          // The original content, now expanded to fill the rest of the space
          Expanded(
            child: mainContent,
          ),
        ],
      ),
    );
  }
}
