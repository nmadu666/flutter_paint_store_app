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
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Iterable<Product> _searchProducts(
      String query, List<Product> allProducts) {
    if (query.isEmpty) {
      return const Iterable<Product>.empty();
    }
    final lowerCaseQuery = query.toLowerCase();
    return allProducts.where((product) {
      final code = product.code;
      return product.name.toLowerCase().contains(lowerCaseQuery) ||
          code.toLowerCase().contains(lowerCaseQuery);
    });
  }

  void _onProductSelected(WidgetRef ref, BuildContext context, Product selection) {
    ref.read(quoteTabsProvider.notifier).addOrUpdateProduct(selection);
    _showAddedToCartSnackbar(context, selection);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final allProductsAsync = ref.watch(salesProductsProvider);
    final selectedPriceList = ref.watch(activeSelectedPriceListProvider);

    return allProductsAsync.when(
      data: (allProducts) => Autocomplete<Product>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          return _searchProducts(textEditingValue.text, allProducts);
        },
        onSelected: (Product selection) {
          _onProductSelected(ref, context, selection);
        },
        // Return an empty string to clear the field after selection
        displayStringForOption: (Product option) => '',
        optionsViewBuilder: (context, onSelected, options) =>
            _buildOptionsView(context, onSelected, options, selectedPriceList),
        fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
          return _buildFieldView(context, controller, focusNode, () {
            // Clear the controller and refocus on submit
            controller.clear();
            focusNode.requestFocus();
          });
        },
      ),
      loading: () => const LinearProgressIndicator(),
      error: (err, stack) {
        debugPrint('Error loading products: $err\n$stack');
        return _buildErrorView(ref, context, err);
      },
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<Product> onSelected,
    Iterable<Product> options,
    String? selectedPriceList,
  ) {
    return Align(
      alignment: Alignment.topLeft,
      child: Material(
        elevation: 4.0,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxHeight: 350),
          child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: options.length,
            itemBuilder: (BuildContext context, int index) {
              final Product option = options.elementAt(index);
              final displayPrice =
                  option.prices[selectedPriceList] ?? option.basePrice;

              return ListTile(
                title: Text(option.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                subtitle: Text(
                  'Mã: ${option.code} - Giá: ${formatPrice(displayPrice)}',
                ),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildFieldView(
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    VoidCallback onFieldSubmitted,
  ) {
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
        fillColor: Colors.grey[200],
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
      onSubmitted: (_) => onFieldSubmitted(),
    );
  }

  Widget _buildErrorView(WidgetRef ref, BuildContext context, Object error) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Lỗi tải sản phẩm',
              errorText: 'Không thể tải dữ liệu. Vui lòng thử lại.',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              filled: true,
            ),
            enabled: false,
          ),
        ),
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () {
            ref.invalidate(salesProductsProvider);
          },
          tooltip: 'Thử lại',
        ),
      ],
    );
  }
}