import 'package:flutter/material.dart';

import 'package:flutter_paint_store_app/common/app_breakpoints.dart';
import 'customer_selector.dart';
import 'price_list_selector.dart';

// Widget này chỉ phục vụ mục đích layout, vì vậy nó có thể là một StatelessWidget.
// Nó không cần phải là ConsumerWidget vì không sử dụng `ref`.
class SalesHeader extends StatelessWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context) {
    // Check screen size to determine layout
    final isDesktop = MediaQuery.of(context).size.width > AppBreakpoints.desktop;

    if (isDesktop) {
      // For desktop, use a Row with specific alignment and padding.
      return const Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomerSelector(),
            ),
            SizedBox(width: 8),
            PriceListSelector(),
          ],
        ),
      );
    } else {
      // For mobile, use a Row
      return const Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            Expanded(child: CustomerSelector()),
            SizedBox(width: 8),
            Expanded(child: PriceListSelector()),
          ],
        ),
      );
    }
  }
}
