import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/price_formatter.dart';

import '../edit_item_dialog.dart';

class ReorderableDesktopCartTable extends ConsumerWidget {
  final List<QuoteItem> items;
  final void Function(int, int) onReorder;

  const ReorderableDesktopCartTable({required this.items, required this.onReorder, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        const DesktopCartHeader(),
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles:false,
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return DesktopCartRow(
                key: ValueKey(item.id),
                item: item,
                index: index,
              );
            },
            onReorder: onReorder,
          ),
        ),
      ],
    );
  }
}

class DesktopCartHeader extends StatelessWidget {
  const DesktopCartHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          children: [
            const SizedBox(width: 40), // For reorder handle
            Expanded(flex: 3, child: Text('Sản phẩm', style: textTheme.titleSmall)),
            Expanded(flex: 2, child: Text('Ghi chú', style: textTheme.titleSmall)),
            SizedBox(width: 60, child: Text('SL', style: textTheme.titleSmall, textAlign: TextAlign.right)),
            SizedBox(width: 100, child: Text('Đơn giá', style: textTheme.titleSmall, textAlign: TextAlign.right)),
            SizedBox(width: 80, child: Text('CK', style: textTheme.titleSmall, textAlign: TextAlign.right)),
            SizedBox(width: 120, child: Text('Thành tiền', style: textTheme.titleSmall, textAlign: TextAlign.right)),
             SizedBox(width: 150, child: Center(child: Text('Hành động', style: textTheme.titleSmall))),
          ],
        ),
      ),
    );
  }
}

class DesktopCartRow extends ConsumerWidget {
  final QuoteItem item;
  final int index;

  const DesktopCartRow({required this.item, required this.index, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: Row(
          children: [
            ReorderableDragStartListener(
              index: index,
              child: const Icon(Icons.drag_handle),
            ),
            const SizedBox(width: 8),
            Expanded(flex: 3, child: Text(item.product.name)),
            Expanded(flex: 2, child: Text(item.note ?? '', style: const TextStyle(fontStyle: FontStyle.italic))),
            SizedBox(width: 60, child: Text(item.quantity.toString(), textAlign: TextAlign.right)),
            SizedBox(width: 100, child: Text(formatPrice(item.unitPrice), textAlign: TextAlign.right)),
            SizedBox(width: 80, child: Text('${item.discountValue.toStringAsFixed(0)}${item.isDiscountPercentage ? '%' : ''}', textAlign: TextAlign.right)),
            SizedBox(width: 120, child: Text(formatPrice(item.totalPrice), textAlign: TextAlign.right, style: const TextStyle(fontWeight: FontWeight.bold))),
            SizedBox(
              width: 150,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.copy_outlined, size: 20),
                    tooltip: 'Thêm dòng mới',
                    onPressed: () => ref.read(quoteProvider.notifier).addDuplicateItem(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    tooltip: 'Chỉnh sửa',
                    onPressed: () => showEditItemDialog(context, ref, item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20),
                    tooltip: 'Xóa',
                    onPressed: () => ref.read(quoteProvider.notifier).removeItem(item.id),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

