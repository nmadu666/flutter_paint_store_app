import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/ui_state_providers.dart';

class SalesAppBar extends ConsumerWidget {
  final bool isMobile;

  const SalesAppBar({super.key, required this.isMobile});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (isMobile) {
      return _buildMobileAppBar(context, ref);
    } else {
      return _buildDesktopAppBar(context, ref);
    }
  }

  AppBar _buildMobileAppBar(BuildContext context, WidgetRef ref) {
    final isShowingCart = ref.watch(isShowingCartMobileProvider);

    return AppBar(
      title: Text(isShowingCart ? 'Giỏ hàng' : 'Bán hàng'),
      leading: isShowingCart
          ? IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () =>
                  ref.read(isShowingCartMobileProvider.notifier).state = false,
            )
          : null,
      bottom: isShowingCart
          ? null
          : PreferredSize(
              preferredSize: const Size.fromHeight(kToolbarHeight),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8.0,
                ),
                child: TextField(
                  onChanged: (query) {
                    ref.read(salesSearchQueryProvider.notifier).state = query;
                  },
                  decoration: InputDecoration(
                    hintText: 'Tìm kiếm sản phẩm...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
            ),
    );
  }

  AppBar _buildDesktopAppBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      title: const Text('Tạo Báo Giá / Đơn Hàng'),
      actions: const [
        SizedBox(width: 16),
      ],
    );
  }
}