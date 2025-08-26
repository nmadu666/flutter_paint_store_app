import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/application/product_providers.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/price_formatter.dart';

class ProductSearchField extends ConsumerWidget {
  const ProductSearchField({super.key});

  void _showAddedToCartSnackbar(BuildContext context, Product product) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} đã được thêm vào báo giá.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProductsAsync = ref.watch(salesProductsProvider);
    final selectedPriceList = ref.watch(activeSelectedPriceListProvider);

    return allProductsAsync.when(
      data: (allProducts) => Autocomplete<Product>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<Product>.empty();
          }
          final query = textEditingValue.text.toLowerCase();
          return allProducts.where((product) {
            return product.name.toLowerCase().contains(query) ||
                (product.code ?? '').toLowerCase().contains(query);
          });
        },
        displayStringForOption: (Product option) => '',
        onSelected: (Product selection) {
          ref.read(quoteTabsProvider.notifier).addOrUpdateProduct(selection);
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
                        option.prices[selectedPriceList] ?? option.basePrice;

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
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return TextField(
            controller: controller,
            focusNode: focusNode,
            decoration: InputDecoration(
              hintText: 'Tìm và thêm sản phẩm...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
            ),
            onSubmitted: (_) {
              controller.clear();
              focusNode.requestFocus();
            },
          );
        },
      ),
      loading: () => const Center(child: LinearProgressIndicator()),
      error: (err, stack) => const TextField(
        decoration: InputDecoration(hintText: 'Lỗi tải sản phẩm'),
        enabled: false,
      ),
    );
  }
}
