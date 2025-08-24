import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/features/color_palette/application/price_details_state.dart';

class PriceDetailsDialog extends ConsumerStatefulWidget {
  const PriceDetailsDialog({
    super.key,
    required this.product,
    required this.color,
    required this.initialItems,
  });

  final ParentProduct product;
  final PaintColor color;
  final List<CostItem> initialItems;

  @override
  ConsumerState<PriceDetailsDialog> createState() => _PriceDetailsDialogState();
}

class _PriceDetailsDialogState extends ConsumerState<PriceDetailsDialog> {
  @override
  void initState() {
    super.initState();
    Future(() {
      ref
          .read(priceDetailsProvider.notifier)
          .initItems(widget.initialItems, widget.product);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1200),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final isDesktop = constraints.maxWidth > 800;
              return isDesktop
                  ? _buildDesktopLayout(context, ref)
                  : _buildMobileLayout(context, ref);
            },
          ),
        ),
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final priceState = ref.watch(priceDetailsProvider);

    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Chi tiết Giá',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          _buildLeftPanel(context, ref, widget.product, widget.color),
          const SizedBox(height: 16),
          _buildRightPanel(context, ref, priceState),
        ],
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final priceState = ref.watch(priceDetailsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 2,
          child: _buildLeftPanel(context, ref, widget.product, widget.color),
        ),
        const SizedBox(width: 24),
        Expanded(flex: 3, child: _buildRightPanel(context, ref, priceState)),
      ],
    );
  }

  Widget _buildLeftPanel(
    BuildContext context,
    WidgetRef ref,
    ParentProduct parentProduct,
    PaintColor color,
  ) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin sản phẩm', style: textTheme.titleLarge),
          const Divider(height: 24),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(backgroundColor: color.color, radius: 24),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          color.name,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${color.brand} - Code: ${color.code}',
                          style: textTheme.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 150,
                  width: double.infinity,
                  child: Image.network(
                    parentProduct.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.image_not_supported),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(parentProduct.name, style: textTheme.titleMedium),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRightPanel(
    BuildContext context,
    WidgetRef ref,
    PriceDetailsState priceState,
  ) {
    final textTheme = Theme.of(context).textTheme;
    final totalItems = priceState.items.fold<int>(
      0,
      (sum, item) => sum + item.quantity,
    );

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text('Chi tiết đơn hàng', style: textTheme.titleLarge),
              _buildPriceListDropdown(ref, priceState),
            ],
          ),
          const Divider(height: 24),
          ...priceState.items.map((item) => _buildItemRow(context, ref, item)),
          const Divider(height: 24),
          _buildSummary(context, priceState),
          const Divider(height: 24),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Chọn báo giá',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          const TextField(
            decoration: InputDecoration(
              labelText: 'Khách hàng',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            icon: const Icon(Icons.add_shopping_cart),
            label: Text('Thêm $totalItems vào báo giá'),
            onPressed: totalItems == 0
                ? null
                : () {
                    final itemsToAdd = ref
                        .read(priceDetailsProvider)
                        .items
                        .where((item) => item.quantity > 0)
                        .toList();
                    Navigator.of(context).pop(itemsToAdd);
                  },
          ),
        ],
      ),
    );
  }

  Widget _buildPriceListDropdown(WidgetRef ref, PriceDetailsState priceState) {
    return DropdownButton<String>(
      value: priceState.selectedPriceList,
      hint: const Text('Chọn bảng giá'),
      items: [
        const DropdownMenuItem<String>(value: null, child: Text('Giá Gốc')),
        ...priceState.availablePriceLists.map((listName) {
          return DropdownMenuItem<String>(
            value: listName,
            child: Text(listName),
          );
        }),
      ],
      onChanged: (value) {
        ref.read(priceDetailsProvider.notifier).selectPriceList(value);
      },
    );
  }

  Widget _buildItemRow(BuildContext context, WidgetRef ref, CostItem item) {
    final numberFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              item.product.name ?? 'N/A',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              numberFormat.format(item.unitPrice),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(flex: 2, child: _buildDiscountInput(ref, item)),
          const SizedBox(width: 8),
          Expanded(
            flex: 2,
            child: Text(
              numberFormat.format(item.tintCost),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(width: 60, child: _buildQuantityInput(ref, item)),
        ],
      ),
    );
  }

  Widget _buildDiscountInput(WidgetRef ref, CostItem item) {
    return TextFormField(
      initialValue: item.discount.toString(),
      decoration: InputDecoration(
        labelText: 'Giảm giá',
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        // TODO: Add suffix icon to toggle between % and VND
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final val = double.tryParse(value) ?? 0;
        ref
            .read(priceDetailsProvider.notifier)
            .updateDiscount(item.product.id, val);
      },
      style: Theme.of(ref.context).textTheme.bodySmall,
    );
  }

  Widget _buildQuantityInput(WidgetRef ref, CostItem item) {
    return TextFormField(
      initialValue: item.quantity.toString(),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        labelText: 'SL',
        border: const OutlineInputBorder(),
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      ),
      keyboardType: TextInputType.number,
      onChanged: (value) {
        final val = int.tryParse(value) ?? 0;
        ref
            .read(priceDetailsProvider.notifier)
            .updateQuantity(item.product.id, val);
      },
      style: Theme.of(ref.context).textTheme.bodySmall,
    );
  }

  Widget _buildSummary(BuildContext context, PriceDetailsState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _CostRow('Tổng tiền base', state.totalBasePrice),
        _CostRow('Tổng giảm giá', state.totalDiscount),
        _CostRow('Tổng chi phí pha màu', state.totalTintCost),
        const Divider(),
        DefaultTextStyle(
          style: Theme.of(
            context,
          ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          child: _CostRow('Tổng tiền thành phẩm', state.grandTotal),
        ),
      ],
    );
  }

  Widget _CostRow(String label, double value) {
    final numberFormat = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
      decimalDigits: 0,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Text(numberFormat.format(value))],
      ),
    );
  }
}
