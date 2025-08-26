import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/price_formatter.dart';

class ReorderableDesktopCartTable extends ConsumerWidget {
  final List<QuoteItem> items;
  final void Function(int oldIndex, int newIndex) onReorder;

  const ReorderableDesktopCartTable({
    super.key,
    required this.items,
    required this.onReorder,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;

    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(32.0),
          child: Text('Chưa có sản phẩm nào trong báo giá.'),
        ),
      );
    }

    return Column(
      children: [
        // Table Header
        _buildHeader(colorScheme),
        // Table Body
        Expanded(
          child: ReorderableListView.builder(
            buildDefaultDragHandles: false, // We use a custom handle
            itemCount: items.length,
            onReorder: onReorder,
            itemBuilder: (context, index) {
              final item = items[index];
              return _CartItemRow(
                // Key quan trọng để sắp xếp lại các stateful widget
                key: ValueKey(item.id),
                item: item,
                index: index,
              );
            },
          ),
        ),
      ],
    );
  }

  // Header Widget
  Widget _buildHeader(ColorScheme colorScheme) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        border: Border(bottom: BorderSide(color: colorScheme.outlineVariant)),
      ),
      child: Row(
        children: [
          _buildHeaderCell('STT', flex: 1, alignment: TextAlign.center),
          _buildHeaderCell('Tên sản phẩm', flex: 5),
          _buildHeaderCell('Số lượng', flex: 2, alignment: TextAlign.center),
          _buildHeaderCell('Đơn giá', flex: 3, alignment: TextAlign.right),
          _buildHeaderCell('CK (%)', flex: 2, alignment: TextAlign.center),
          _buildHeaderCell('Thành tiền', flex: 3, alignment: TextAlign.right),
          _buildHeaderCell('Xóa', flex: 1, alignment: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(
    String text, {
    required int flex,
    TextAlign alignment = TextAlign.left,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignment,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _CartItemRow extends ConsumerStatefulWidget {
  final QuoteItem item;
  final int index;

  const _CartItemRow({super.key, required this.item, required this.index});

  @override
  ConsumerState<_CartItemRow> createState() => _CartItemRowState();
}

class _CartItemRowState extends ConsumerState<_CartItemRow> {
  late final TextEditingController _quantityController;
  late final TextEditingController _discountController;

  @override
  void initState() {
    super.initState();
    _quantityController = TextEditingController(
      text: widget.item.quantity.toString(),
    );
    _discountController = TextEditingController(
      text: widget.item.discountAsPercentage.toString(),
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _discountController.dispose();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _CartItemRow oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.item.quantity != oldWidget.item.quantity) {
      _quantityController.text = widget.item.quantity.toString();
    }
    if (widget.item.discountAsPercentage !=
        oldWidget.item.discountAsPercentage) {
      _discountController.text = widget.item.discountAsPercentage.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final item = widget.item;
    final index = widget.index;

    return Material(
      color: index.isEven
          ? colorScheme.surface
          : colorScheme.surfaceContainerLowest,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // STT and Drag Handle
            Expanded(
              flex: 1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('${index + 1}', textAlign: TextAlign.center),
                  const SizedBox(width: 8),
                  ReorderableDragStartListener(
                    index: index,
                    child: const MouseRegion(
                      cursor: SystemMouseCursors.grab,
                      child: Icon(Icons.drag_handle, size: 20),
                    ),
                  ),
                ],
              ),
            ),
            // Product Name
            Expanded(
              flex: 5,
              child: InkWell(
                onTap: () => _showEditItemDetailsDialog(context, item),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item.product.name, overflow: TextOverflow.ellipsis),
                      if (item.note != null && item.note!.isNotEmpty)
                        Text(
                          item.note!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(
                                  context,
                                ).colorScheme.onSurfaceVariant,
                              ),
                          overflow: TextOverflow.ellipsis,
                        ),
                    ],
                  ),
                ),
              ),
            ),
            // Quantity
            Expanded(
              flex: 2,
              child: _buildQuantityEditor(item, _quantityController),
            ),
            // Unit Price
            Expanded(
              flex: 3,
              child: Text(
                formatPrice(item.unitPrice),
                textAlign: TextAlign.right,
              ),
            ),
            // Discount
            Expanded(
              flex: 2,
              child: _buildDiscountEditor(item, _discountController),
            ),
            // Total
            Expanded(
              flex: 3,
              child: Text(
                formatPrice(item.totalPrice),
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            // Delete Action
            Expanded(
              flex: 1,
              child: Center(
                child: IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    ref.read(quoteTabsProvider.notifier).removeItem(item.id);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditItemDetailsDialog(BuildContext context, QuoteItem item) {
    final noteController = TextEditingController(text: item.note);

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text('Chỉnh sửa: ${item.product.name}'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: noteController,
                decoration: const InputDecoration(
                  labelText: 'Ghi chú',
                  border: OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Hủy'),
            ),
            FilledButton(
              onPressed: () {
                ref.read(quoteTabsProvider.notifier).updateItem(item.copyWith(note: noteController.text));
                Navigator.of(dialogContext).pop();
              },
              child: const Text('Lưu'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildQuantityEditor(
    QuoteItem item,
    TextEditingController controller,
  ) {
    void updateQuantity(int newQuantity) {
      if (newQuantity != item.quantity) {
        if (newQuantity > 0) {
          ref.read(quoteTabsProvider.notifier).updateItem(item.copyWith(quantity: newQuantity));
        } else {
          ref.read(quoteTabsProvider.notifier).removeItem(item.id);
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: const Icon(Icons.remove),
          onPressed: item.quantity > 1
              ? () => updateQuantity(item.quantity - 1)
              : null,
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        SizedBox(
          width: 40,
          child: Focus(
            onFocusChange: (hasFocus) {
              if (!hasFocus) {
                updateQuantity(int.tryParse(controller.text) ?? 1);
              }
            },
            child: TextFormField(
              controller: controller,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                isDense: true,
              ),
              onFieldSubmitted: (value) => updateQuantity(int.tryParse(value) ?? 1),
            ),
          ),
        ),
        IconButton(
          icon: const Icon(Icons.add),
          onPressed: () => updateQuantity(item.quantity + 1),
          iconSize: 18,
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  Widget _buildDiscountEditor(
    QuoteItem item,
    TextEditingController controller,
  ) {
    void updateDiscount() {
      final newDiscount = double.tryParse(controller.text) ?? 0.0;
      if (newDiscount != item.discountAsPercentage) {
        ref.read(quoteTabsProvider.notifier).updateItem(item.copyWith(discount: newDiscount, discountIsPercentage: true));
      }
    }

    return SizedBox(
      width: 60,
      child: Focus(
        onFocusChange: (hasFocus) {
          if (!hasFocus) {
            updateDiscount();
          }
        },
        child: TextFormField(
          controller: controller,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: const InputDecoration(
            isDense: true,
            suffixText: '%',
          ),
          onFieldSubmitted: (_) => updateDiscount(),
        ),
      ),
    );
  }
}