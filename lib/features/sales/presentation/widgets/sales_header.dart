import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/customer_selector.dart';

class SalesHeader extends ConsumerWidget {
  const SalesHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Check screen size to determine layout
    final isDesktop = MediaQuery.of(context).size.width > 900;

    if (isDesktop) {
      // For desktop, use a Column as they will be in a narrow column
      return const Padding(
        padding: EdgeInsets.only(bottom: 24.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(child: CustomerSelector()),
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
          ],
        ),
      );
    }
  }
}
