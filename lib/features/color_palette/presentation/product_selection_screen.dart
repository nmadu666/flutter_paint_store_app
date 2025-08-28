import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import 'package:flutter_paint_store_app/features/color_palette/application/product_selection_state.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/cost_item.dart';

import '../application/color_palette_state.dart';
import 'price_details_dialog.dart';

class ProductSelectionScreen extends ConsumerWidget {
  const ProductSelectionScreen({super.key, required this.color});
  final PaintColor color;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen<ParentProduct?>(selectedParentProductProvider, (previous, next) {
      if (previous != null) {
        for (final child in previous.children) {
          ref.read(quantityProvider(child.id).notifier).state = 0;
        }
      }
    });

    return ProviderScope(
      overrides: [currentColorProvider.overrideWithValue(color)],
      child: LayoutBuilder(builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;
        return isDesktop ? const _DesktopLayout() : const _MobileLayout();
      }),
    );
  }
}

// --- Layouts ---

class _MobileLayout extends ConsumerWidget {
  const _MobileLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(currentColorProvider);
    final selectedParent = ref.watch(selectedParentProductProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn sản phẩm')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _ColorInfoCard(color: color),
            const SizedBox(height: 24),
            if (selectedParent == null) ...[
              const _CategorySelection(),
              const SizedBox(height: 16),
              const _ParentProductSelection(),
            ] else ...[
              const _SelectedParentProductCard(),
              const SizedBox(height: 24),
              const _SizeSelectionList(),
              const SizedBox(height: 24),
              _CostSummaryCard(),
            ],
          ],
        ),
      ),
      bottomNavigationBar: const _ActionButtons(),
    );
  }
}

class _DesktopLayout extends ConsumerWidget {
  const _DesktopLayout();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedParent = ref.watch(selectedParentProductProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Chọn sản phẩm')),
      body: Row(
        children: [
          SizedBox(
            width: 350,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (selectedParent == null) const _CategorySelection(),
                  const Spacer(),
                  _CostSummaryCard(),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  _ColorInfoCard(color: ref.watch(currentColorProvider)),
                  const SizedBox(height: 24),
                  if (selectedParent == null) ...[
                    const _ParentProductSelection(),
                  ] else ...[
                    const _SelectedParentProductCard(),
                    const SizedBox(height: 24),
                    const _SizeSelectionGrid(),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const _ActionButtons(isDesktop: true),
    );
  }
}

// --- Component Widgets ---

class _ColorInfoCard extends StatelessWidget {
  const _ColorInfoCard({required this.color});
  final PaintColor color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
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
                  Text(color.name, style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  Text('${color.brand} - Code: ${color.code}', style: textTheme.bodyMedium),
                  if (color.ncs != null) Text('NCS: ${color.ncs!}', style: textTheme.bodySmall),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategorySelection extends ConsumerWidget {
  const _CategorySelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);
    final selected = ref.watch(selectedCategoryProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('1. Chọn Dòng Sản Phẩm', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: ['Tất cả', ...categories].map((cat) {
            final isSelected = (cat == 'Tất cả' && selected == null) || cat == selected;
            return ChoiceChip(
              label: Text(cat),
              selected: isSelected,
              onSelected: (_) {
                ref.read(selectedCategoryProvider.notifier).state = cat == 'Tất cả' ? null : cat;
              },
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _ParentProductSelection extends ConsumerWidget {
  const _ParentProductSelection();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredParentProductsProvider);
    final color = ref.watch(currentColorProvider);

    if (filteredProducts.isEmpty) {
      return const Center(child: Text('Không có sản phẩm phù hợp.'));
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filteredProducts.length,
      itemBuilder: (context, index) {
        final product = filteredProducts[index];
        final bases = ref.watch(suitableBasesProvider(SuitableChildrenRequest(parent: product, color: color)));
        return Card(
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: () {
              ref.read(selectedParentProductProvider.notifier).state = product;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Image.network(product.imageUrl, fit: BoxFit.cover, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),)
                ),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(product.name, style: Theme.of(context).textTheme.titleMedium),
                       Text('Base khả dụng: $bases', style: Theme.of(context).textTheme.bodySmall),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SelectedParentProductCard extends ConsumerWidget {
  const _SelectedParentProductCard();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final product = ref.watch(selectedParentProductProvider);
    if (product == null) return const SizedBox.shrink();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            SizedBox(height: 60, width: 60, child: Image.network(product.imageUrl, errorBuilder: (context, error, stackTrace) => const Icon(Icons.image_not_supported),)),
            const SizedBox(width: 16),
            Expanded(child: Text(product.name, style: Theme.of(context).textTheme.titleMedium)),
            IconButton(icon: const Icon(Icons.close), onPressed: () {
               ref.read(selectedParentProductProvider.notifier).state = null;
            })
          ],
        ),
      ),
    );
  }
}

class _SizeSelectionList extends ConsumerWidget {
  const _SizeSelectionList();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parent = ref.watch(selectedParentProductProvider);
    if (parent == null) return const SizedBox.shrink();
    final color = ref.watch(currentColorProvider);
    final suitableChildren = ref.watch(suitableChildrenProvider(SuitableChildrenRequest(parent: parent, color: color)));

    return Column(
       crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('2. Chọn Kích Cỡ & Số Lượng', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: suitableChildren.length,
          separatorBuilder: (_, __) => const SizedBox(height: 8),
          itemBuilder: (context, index) {
            final childProduct = suitableChildren[index];
            return _SizeListItem(product: childProduct);
          },
        ),
      ],
    );
  }
}

class _SizeSelectionGrid extends ConsumerWidget {
  const _SizeSelectionGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parent = ref.watch(selectedParentProductProvider);
    if (parent == null) return const SizedBox.shrink();
    final color = ref.watch(currentColorProvider);
    final suitableChildren = ref.watch(suitableChildrenProvider(SuitableChildrenRequest(parent: parent, color: color)));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('2. Chọn Kích Cỡ & Số Lượng', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 200,
            childAspectRatio: 0.9,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: suitableChildren.length,
          itemBuilder: (context, index) {
            final childProduct = suitableChildren[index];
            return _SizeGridItem(product: childProduct);
          },
        ),
      ],
    );
  }
}

class _SizeListItem extends ConsumerWidget {
  const _SizeListItem({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(currentColorProvider);
    final price = ref.watch(finalPriceProvider(ColorProductPair(color: color, product: product)));

    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(child: Text('${product.unitValue}L - Base ${product.base}')),
            Text(price != null ? NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(price) : 'N/A'),
            const SizedBox(width: 16),
            _QuantityCounter(productId: product.id),
          ],
        ),
      ),
    );
  }
}

class _SizeGridItem extends ConsumerWidget {
  const _SizeGridItem({required this.product});
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final color = ref.watch(currentColorProvider);
    final price = ref.watch(finalPriceProvider(ColorProductPair(color: color, product: product)));

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Center(
              child: Text('${product.unitValue}L', style: Theme.of(context).textTheme.headlineSmall),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text('Base ${product.base}'),
                Text(price != null ? NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0).format(price) : 'N/A', style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                _QuantityCounter(productId: product.id),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _QuantityCounter extends ConsumerWidget {
  const _QuantityCounter({required this.productId});
  final String productId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider(productId));
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(icon: const Icon(Icons.remove_circle_outline), onPressed: () {
          if (quantity > 0) ref.read(quantityProvider(productId).notifier).state--;
        }),
        Text(quantity.toString(), style: Theme.of(context).textTheme.titleMedium),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: () {
          ref.read(quantityProvider(productId).notifier).state++;
        }),
      ],
    );
  }
}

class _CostSummaryCard extends ConsumerWidget {
  const _CostSummaryCard();

    @override
  Widget build(BuildContext context, WidgetRef ref) {
    final costDetails = ref.watch(costDetailsProvider);
    if (costDetails.items.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Text('Vui lòng chọn số lượng.'),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Chi tiết chi phí', style: Theme.of(context).textTheme.titleMedium),
            const Divider(height: 16),
            _CostRow(
              'Tổng giá Base',
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                  .format(costDetails.totalBasePrice),
            ),
            _CostRow(
              'Tổng chi phí pha màu',
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                  .format(costDetails.totalTintCost),
            ),
            const Divider(height: 16),
            DefaultTextStyle(
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
              child: _CostRow(
                'Tổng cộng',
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫', decimalDigits: 0)
                    .format(costDetails.totalCost),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class _CostRow extends StatelessWidget {
  const _CostRow(this.label, this.value);
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [Text(label), Flexible(child: Text(value, textAlign: TextAlign.end,))],
      ),
    );
  }
}


class _ActionButtons extends ConsumerWidget {
  const _ActionButtons({this.isDesktop = false});
  final bool isDesktop;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parent = ref.watch(selectedParentProductProvider);
    final costDetails = ref.watch(costDetailsProvider);
    if (parent == null) return const SizedBox.shrink();

    final totalItems = costDetails.items.fold<int>(0, (sum, item) => sum + item.quantity);

    final completeButton = SizedBox(
      width: isDesktop ? 200 : double.infinity,
      child: FilledButton(
        onPressed: totalItems == 0
            ? null
            : () async {
                final selectedProduct = ref.read(selectedParentProductProvider);
                final color = ref.read(currentColorProvider);
                final finalCostDetails = ref.read(costDetailsProvider);

                if (selectedProduct != null) {
                  final result = await showDialog<List<CostItem>>(
                    context: context,
                    builder: (context) => PriceDetailsDialog(
                      product: selectedProduct,
                      color: color,
                      initialItems: finalCostDetails.items,
                    ),
                  );

                  if (result != null && result.isNotEmpty && context.mounted) {
                    Navigator.of(context).pop(result);
                  }
                }
              },
        child: const Text('Hoàn tất'),
      ),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isDesktop
            ? completeButton
            : SizedBox(
                width: double.infinity,
                child: completeButton,
              ),
      ),
    );
  }
}