import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/price_formatter.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_header.dart';


void _showAddedToCartSnackbar(BuildContext context, Product product) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('${product.name} đã được thêm vào báo giá.'),
      duration: const Duration(seconds: 2),
    ),
  );
}

class ProductList extends ConsumerWidget {
  const ProductList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredSalesProductsProvider);
    final productsAsync = ref.watch(salesProductsProvider);
    final selectedPriceList = ref.watch(selectedPriceListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Lỗi: $err')),
      data: (_) => Column(
        children: [
          const SalesHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];
                final displayPrice =
                    product.prices[selectedPriceList] ?? product.basePrice;
                
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Code: ${product.code} - Giá: ${formatPrice(displayPrice)}'),
                  trailing: ProductCounter(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ProductCounter extends ConsumerWidget {
  const ProductCounter({required this.product, super.key});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quoteItems = ref.watch(quoteProvider).items;
    final itemsInCart = quoteItems
        .where((item) => item.product.id == product.id && item.color == null)
        .toList();

    if (itemsInCart.isEmpty) {
      return IconButton(
        icon: const Icon(Icons.add_shopping_cart_outlined),
        tooltip: 'Thêm vào giỏ',
        onPressed: () {
          ref.read(quoteProvider.notifier).addItem(product: product);
          _showAddedToCartSnackbar(context, product);
        },
      );
    }

    if (itemsInCart.length > 1) {
      return Chip(label: Text('${itemsInCart.length} dòng trong giỏ'));
    }

    final item = itemsInCart.first;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Bớt',
          onPressed: () => ref
              .read(quoteProvider.notifier)
              .updateQuantity(item.id, item.quantity - 1),
        ),
        Text(
          item.quantity.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Thêm',
          onPressed: () => ref
              .read(quoteProvider.notifier)
              .updateQuantity(item.id, item.quantity + 1),
        ),
      ],
    );
  }
}
