import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/models/quote.dart';

import '../edit_item_dialog.dart';
import '../price_formatter.dart';

class MobileCartItem extends ConsumerStatefulWidget {
  final QuoteItem item;
  const MobileCartItem({required this.item, Key? key}) : super(key: key);

  @override
  ConsumerState<MobileCartItem> createState() => _MobileCartItemState();
}

class _MobileCartItemState extends ConsumerState<MobileCartItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
    _animation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(-0.8, 0),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final quote = ref.watch(activeQuoteProvider);
    return GestureDetector(
      onHorizontalDragUpdate: (details) {
        if (details.primaryDelta! < -5) _controller.forward();
        if (details.primaryDelta! > 5) _controller.reverse();
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned.fill(
            child: Container(
              color: Theme.of(context).colorScheme.surfaceVariant,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  SizedBox(
                    width: 80,
                    child: SlidableAction(
                      icon: Icons.copy_outlined,
                      label: 'Nhân bản',
                      onPressed: () {
                        ref.read(quoteTabsProvider.notifier).addDuplicateItem(item);
                        _controller.reverse();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: SlidableAction(
                      icon: Icons.edit_outlined,
                      label: 'Sửa',
                      onPressed: () {
                        showEditItemDialog(context, ref, item);
                        _controller.reverse();
                      },
                    ),
                  ),
                  SizedBox(
                    width: 80,
                    child: SlidableAction(
                      icon: Icons.delete_outline,
                      label: 'Xóa',
                      onPressed: () {
                        ref.read(quoteTabsProvider.notifier).removeItem(item.id);
                        _controller.reverse();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          SlideTransition(
            position: _animation,
            child: Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text(item.product.name),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.quantity} x ${formatPrice(item.unitPrice)} = ${formatPrice(item.totalPrice)}',
                    ),
                    if (item.note != null && item.note!.isNotEmpty)
                      Text(
                        'Ghi chú: ${item.note}',
                        style: const TextStyle(
                          fontStyle: FontStyle.italic,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                trailing: ReorderableDragStartListener(
                  index: quote?.items.indexOf(item) ?? 0,
                  child: const Icon(Icons.drag_handle),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlidableAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;
  const SlidableAction({
    required this.icon,
    required this.label,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
