import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:collection/collection.dart';

import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/features/color_palette/domain/color_tone_helper.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/models/product.dart';

class ColorPaletteScreen extends ConsumerWidget {
  const ColorPaletteScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredColors = ref.watch(filteredColorsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bảng màu'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kToolbarHeight + 10),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      ref.read(colorSearchQueryProvider.notifier).state = value;
                    },
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên, mã màu, hex, NCS...',
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
                const SizedBox(width: 8),
                IconButton.filledTonal(
                  icon: const Icon(Icons.filter_list),
                  tooltip: 'Bộ lọc nâng cao',
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (_) => const _AdvancedFiltersSheet(),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          const _ColorToneFilters(),
          const Divider(height: 1),
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (filteredColors.isEmpty) {
                  return const Center(child: Text('Không tìm thấy màu nào.'));
                }
                if (constraints.maxWidth < 600) {
                  return _buildMobileLayout(filteredColors);
                } else {
                  return _buildDesktopLayout(filteredColors);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(List<PaintColor> colors) {
    return ListView.builder(
      padding: const EdgeInsets.all(8.0),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        final subtitleParts = [
          'Code: ${color.code}',
          'Hex: ${color.hexString}',
          if (color.ncs != null) 'NCS: ${color.ncs}',
        ];
        return Card(
          child: InkWell(
            onTap: () => _showProductSelection(context, color),
            child: ListTile(
              leading: CircleAvatar(backgroundColor: color.color, radius: 20),
              title: Text('${color.name} (${color.brand})'),
              subtitle: Text(subtitleParts.join(' - ')),
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopLayout(List<PaintColor> colors) {
    return GridView.builder(
      padding: const EdgeInsets.all(16.0),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 200,
        childAspectRatio: 3 / 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
      ),
      itemCount: colors.length,
      itemBuilder: (context, index) {
        final color = colors[index];
        return InkWell(
          onTap: () => _showProductSelection(context, color),
          borderRadius: BorderRadius.circular(12),
          child: _ColorCard(color: color),
        );
      },
    );
  }

  void _showProductSelection(BuildContext context, PaintColor color) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.5,
        maxChildSize: 0.9,
        builder: (_, scrollController) => _ProductSelectionSheet(
          color: color,
          scrollController: scrollController,
        ),
      ),
    );
  }
}

class _AdvancedFiltersSheet extends ConsumerWidget {
  const _AdvancedFiltersSheet();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brands = ref.watch(brandsProvider);
    final collections = ref.watch(collectionsProvider);
    final selectedBrand = ref.watch(selectedBrandProvider);
    final selectedCollection = ref.watch(selectedCollectionProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Bộ lọc nâng cao',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const Divider(height: 24),
          _buildFilterSection(
            context: context,
            ref: ref,
            title: 'Nhãn hiệu:',
            items: brands,
            selectedItem: selectedBrand,
            onSelected: (value) {
              // When brand changes, reset collection filter
              ref.read(selectedCollectionProvider.notifier).state = null;
              ref.read(selectedBrandProvider.notifier).state = value;
            },
          ),
          const SizedBox(height: 16),
          _buildFilterSection(
            context: context,
            ref: ref,
            title: 'Bộ sưu tập:',
            items: collections,
            selectedItem: selectedCollection,
            onSelected: (value) {
              ref.read(selectedCollectionProvider.notifier).state = value;
            },
          ),
        ],
      ),
    );
  }
}

class _ProductSelectionSheet extends ConsumerStatefulWidget {
  const _ProductSelectionSheet({
    required this.color,
    required this.scrollController,
  });
  final PaintColor color;
  final ScrollController scrollController;

  @override
  ConsumerState<_ProductSelectionSheet> createState() =>
      _ProductSelectionSheetState();
}

class _ProductSelectionSheetState
    extends ConsumerState<_ProductSelectionSheet> {
  @override
  Widget build(BuildContext context) {
    final suitableParentsAsync =
        ref.watch(suitableParentProductsProvider(widget.color));
    final allColorPrices = ref.watch(allColorPricesProvider);

    return Column(
      children: [
        // M3 Grabber handle
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Center(
            child: Container(
              width: 32,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
          child: Text(
            'Chọn sản phẩm cho màu ${widget.color.name}',
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: suitableParentsAsync.when(
            data: (parentProducts) {
              if (parentProducts.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text(
                      'Không có dòng sản phẩm nào phù hợp với màu này.',
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              return ListView.builder(
                controller: widget.scrollController,
                itemCount: parentProducts.length,
                itemBuilder: (context, index) {
                  final parentProduct = parentProducts[index];

                  // Filter children to only show those suitable for this color.
                  final suitableChildren = parentProduct.children.where((child) {
                    if (child.base == null ||
                        parentProduct.tintingFormulaType == null) return false;
                    final isBasePhysicallySuitable =
                        isBaseSuitableForColor(child.base!, widget.color);
                    final hasPriceInfo = allColorPrices.any(
                      (price) =>
                          price.code == widget.color.code &&
                          price.base == child.base &&
                          price.tintingFormulaType ==
                              parentProduct.tintingFormulaType,
                    );
                    return isBasePhysicallySuitable && hasPriceInfo;
                  }).toList();

                  if (suitableChildren.isEmpty) {
                    return const SizedBox.shrink();
                  }

                  return ExpansionTile(
                    title: Text(parentProduct.name),
                    subtitle: Text(
                        '${parentProduct.brand} - ${parentProduct.category}'),
                    children: suitableChildren.map((childProduct) {
                      return _ProductSelectionListItem(
                        color: widget.color,
                        product: childProduct,
                      );
                    }).toList(),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => Center(child: Text('Đã xảy ra lỗi: $err')),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Thêm vào báo giá'),
              onPressed: () {
                final parentProducts = suitableParentsAsync.valueOrNull ?? [];
                int itemsAdded = 0;
                final quoteNotifier = ref.read(quoteProvider.notifier);

                for (final parent in parentProducts) {
                  for (final child in parent.children) {
                    final quantity = ref.read(quantityProvider(child.id));
                    if (quantity > 0) {
                      quoteNotifier.addItem(
                        product: child,
                        color: widget.color,
                        quantity: quantity,
                      );
                      itemsAdded++;
                      // Reset quantity after adding
                      ref.read(quantityProvider(child.id).notifier).state = 0;
                    }
                  }
                }

                Navigator.of(context).pop(); // Close the sheet
                if (itemsAdded > 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Đã thêm $itemsAdded sản phẩm vào báo giá.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Chưa có sản phẩm nào được chọn số lượng.'),
                      backgroundColor: Colors.orange,
                    ),
                  );
                }
              },
            ),
          ),
        ),
      ],
    );
  }
}

class _ProductSelectionListItem extends ConsumerWidget {
  const _ProductSelectionListItem({
    required this.color,
    required this.product,
  });

  final PaintColor color;
  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quantity = ref.watch(quantityProvider(product.id));
    final quantityNotifier = ref.read(
      quantityProvider(product.id).notifier,
    );

    // Calculate price using the provider
    final finalPrice = ref.watch(
      finalPriceProvider(
        ColorProductPair(color: color, product: product),
      ),
    );

    return ListTile(
      title: Text(product.name),
      subtitle: Text(
        'Dung tích: ${product.unitValue}L - Base ${product.base}',
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              finalPrice != null
                  ? NumberFormat.currency(
                      locale: 'vi_VN',
                      symbol: '₫',
                      decimalDigits: 0,
                    ).format(finalPrice)
                  : 'N/A',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
              textAlign: TextAlign.end,
            ),
          ),
          const SizedBox(width: 16),
          // Quantity Counter
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed: () {
                  if (quantity > 0) {
                    quantityNotifier.state--;
                  }
                },
              ),
              Text(
                '$quantity',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () {
                  quantityNotifier.state++;
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _buildFilterSection({
  required BuildContext context,
  required WidgetRef ref,
  required String title,
  required List<dynamic> items,
  required dynamic selectedItem,
  required ValueChanged<dynamic> onSelected,
  String Function(dynamic)? itemLabelBuilder,
}) {
  // Use a default label builder if one isn't provided.
  final getLabel = itemLabelBuilder ?? (item) => item.toString();

  // The main layout is a Wrap. It will arrange children in a row and
  // wrap to the next line if there isn't enough horizontal space, preventing RenderFlex errors.
  return Wrap(
    spacing: 8.0, // Horizontal space between chips
    runSpacing: 4.0, // Vertical space between lines
    crossAxisAlignment: WrapCrossAlignment.center, // Align items vertically
    children: [
      Text(title, style: Theme.of(context).textTheme.labelLarge),
      // The "All" chip
      ChoiceChip(
        label: const Text('Tất cả'),
        selected: selectedItem == null,
        onSelected: (_) => onSelected(null),
      ),
      // The rest of the filter chips
      ...items.map(
        (item) => ChoiceChip(
          label: Text(getLabel(item)),
          selected: selectedItem == item,
          onSelected: (_) => onSelected(item),
        ),
      ),
    ],
  );
}

class _ColorToneFilters extends ConsumerStatefulWidget {
  const _ColorToneFilters();

  @override
  ConsumerState<_ColorToneFilters> createState() => _ColorToneFiltersState();
}

class _ColorToneFiltersState extends ConsumerState<_ColorToneFilters> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorTones = ref.watch(colorTonesProvider);
    final selectedTone = ref.watch(selectedColorToneProvider);

    // Bọc SingleChildScrollView bằng Scrollbar để hiển thị thanh cuộn trên desktop/web
    return Scrollbar(
      controller: _scrollController,
      child: SingleChildScrollView(
        controller: _scrollController,
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Tone màu:', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(width: 8),
            ChoiceChip(
              label: const Text('Tất cả'),
              selected: selectedTone == null,
              onSelected: (_) {
                ref.read(selectedColorToneProvider.notifier).state = null;
              },
            ),
            // Generate the rest of the chips
            ...colorTones.map(
              (tone) => Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: ChoiceChip(
                  label: Text(getToneName(tone)),
                  selected: selectedTone == tone,
                  onSelected: (_) {
                    ref.read(selectedColorToneProvider.notifier).state = tone;
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorCard extends StatelessWidget {
  const _ColorCard({required this.color});
  final PaintColor color;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(flex: 3, child: Container(color: color.color)),
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              // Use a LayoutBuilder and SingleChildScrollView to prevent overflow
              // while still allowing vertical centering if content is small.
              child: LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minHeight: constraints.maxHeight,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            color.name,
                            style: textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            color.brand,
                            style: textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Code: ${color.code}',
                            style: textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'Hex: ${color.hexString}',
                            style: textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (color.ncs != null)
                            Text(
                              'NCS: ${color.ncs!}',
                              style: textTheme.bodySmall,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
