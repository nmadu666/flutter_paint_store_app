import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'price_formatter.dart';

void _showAddedToCartSnackbar(BuildContext context, Product product) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product.name} đã được thêm vào báo giá.'),
      duration: const Duration(seconds: 2),
    ),
  );
}

class SalesAppBar extends ConsumerWidget implements PreferredSizeWidget {
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
                  onChanged: (query) =>
                      ref.read(salesSearchQueryProvider.notifier).state = query,
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
    final allProductsAsync = ref.watch(salesProductsProvider);
    final selectedPriceList = ref.watch(selectedPriceListProvider);

    return AppBar(
      title: const Text('Tạo Báo Giá / Đơn Hàng'),
      actions: [
        SizedBox(
          width: 300,
          child: allProductsAsync.when(
            data: (allProducts) => Autocomplete<Product>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Product>.empty();
                }
                return allProducts.where((product) {
                  return product.name
                      .toLowerCase()
                      .contains(textEditingValue.text.toLowerCase());
                });
              },
              displayStringForOption: (Product option) => '',
              onSelected: (Product selection) {
                ref.read(quoteProvider.notifier).addItem(product: selection);
                _showAddedToCartSnackbar(context, selection);
              },
              optionsViewBuilder: (context, onSelected, options) {
                return Align(
                  alignment: Alignment.topLeft,
                  child: Material(
                    elevation: 4.0,
                    child: SizedBox(
                      height: 250,
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: options.length,
                        itemBuilder: (BuildContext context, int index) {
                          final Product option = options.elementAt(index);
                          final displayPrice =
                              option.prices[selectedPriceList] ??
                                  option.basePrice;

                          return ListTile(
                            title: Text(option.name),
                            subtitle: Text(
                              'Code: ${option.code} - Giá: ${formatPrice(displayPrice)}',
                            ),
                            onTap: () => onSelected(option),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                return TextField(
                  controller: controller,
                  focusNode: focusNode,
                  decoration: InputDecoration(
                    hintText: 'Tìm và thêm sản phẩm...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                    ),
                  ),
                  onSubmitted: (_) {
                    controller.clear();
                  },
                );
              },
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, stack) => const TextField(
              decoration: InputDecoration(hintText: 'Lỗi tải sản phẩm'),
              enabled: false,
            ),
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }

  @override
  Size get preferredSize {
    final needsBottom = isMobile;
    return Size.fromHeight(kToolbarHeight + (needsBottom ? kToolbarHeight : 0));
  }
}

