import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/features/sales/infrastructure/quote_pdf_service.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(Product product, WidgetRef ref, BuildContext context) {
    ref.read(cartProvider.notifier).addToCart(product);

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} đã được thêm vào giỏ hàng.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Future<void> _handlePrintQuote(BuildContext context, WidgetRef ref) async {
    final cart = ref.read(cartProvider);
    if (cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giỏ hàng đang trống!'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (ref.read(isPrintingProvider)) return;

    ref.read(isPrintingProvider.notifier).state = true;
    try {
      final customer = ref.read(selectedCustomerProvider);
      final total = ref.read(cartTotalProvider);
      await QuotePdfService().generateAndPrintQuote(
        cartItems: cart,
        customer: customer,
        totalAmount: total,
      );
    } finally {
      if (ref.context.mounted) {
        ref.read(isPrintingProvider.notifier).state = false;
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _buildMobileLayout(context, ref);
        } else {
          return _buildDesktopLayout(context, ref);
        }
      },
    );
  }

  // Giao diện cho Mobile
  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final isShowingCart = ref.watch(isShowingCartMobileProvider);
    final cartItems = ref.watch(cartProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(isShowingCart ? 'Giỏ hàng' : 'Bán hàng'),
        leading: isShowingCart
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () =>
                    ref.read(isShowingCartMobileProvider.notifier).state =
                        false,
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
                        ref.read(salesSearchQueryProvider.notifier).state =
                            query,
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
      ),
      body: isShowingCart
          ? _buildMobileCartView(context, ref)
          : _buildMobileProductList(context, ref),
      floatingActionButton: !isShowingCart && cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(isShowingCartMobileProvider.notifier).state = true,
              label: Text('Xem giỏ hàng (${cartItems.length})'),
              icon: const Icon(Icons.shopping_cart_outlined),
            )
          : null,
    );
  }

  // Widget danh sách sản phẩm cho mobile
  Widget _buildMobileProductList(BuildContext context, WidgetRef ref) {
    final filteredProducts = ref.watch(filteredProductsProvider);
    final productsAsync = ref.watch(productsProvider);
    final selectedPriceList = ref.watch(selectedPriceListProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Lỗi: $err')),
      data: (_) => Column(
        children: [
          const _SalesHeader(),
          const Divider(height: 1),
          Expanded(
            child: ListView.builder(
              itemCount: filteredProducts.length,
              itemBuilder: (context, index) {
                final product = filteredProducts[index];

                // Find the price for the current product based on the selected price list
                final productPrice = product.pricing.firstWhere(
                  (p) => p.priceGroup == selectedPriceList,
                  // Fallback to the first price if not found or if pricing is empty
                  orElse: () => product.pricing.isNotEmpty
                      ? product.pricing.first
                      : const ProductPricing(priceGroup: 'N/A', cost: 0),
                );

                final priceString = '${productPrice.cost.toStringAsFixed(0)}đ';

                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Code: ${product.code} - Giá: $priceString'),
                  trailing: _ProductCounter(product: product),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Widget giỏ hàng cho mobile
  Widget _buildMobileCartView(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final isPrinting = ref.watch(isPrintingProvider);
    final totalString = '${cartTotal.toStringAsFixed(0)}đ';

    if (cartItems.isEmpty) {
      return const Center(child: Text('Giỏ hàng của bạn đang trống.'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: cartItems.length,
            itemBuilder: (context, index) {
              final item = cartItems[index];
              return ListTile(
                title: Text(item.productName),
                subtitle: Text('Số lượng: ${item.quantity}'),
                trailing: Text('${item.totalPrice.toStringAsFixed(0)}đ'),
              );
            },
          ),
        ),
        // Phần thanh toán
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryRow(
                context,
                'Tổng cộng',
                totalString,
                isTotal: true,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: isPrinting
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.print_outlined),
                label: Text(isPrinting ? 'Đang xử lý...' : 'In Báo Giá'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: isPrinting
                    ? null
                    : () => _handlePrintQuote(context, ref),
              ),
              const SizedBox(height: 8),
              FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('Tạo Đơn Hàng'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Giao diện cho Desktop/Tablet
  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final allProductsAsync = ref.watch(productsProvider);
    final selectedPriceList = ref.watch(selectedPriceListProvider);
    final cartTotal = ref.watch(cartTotalProvider);
    final isPrinting = ref.watch(isPrintingProvider);
    final totalString = '${cartTotal.toStringAsFixed(0)}đ';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Báo Giá / Đơn Hàng'),
        actions: [
          const _CustomerSelector(),
          const SizedBox(width: 8),
          const _PriceListSelector(),
          const SizedBox(width: 8),
          SizedBox(
            width: 300,
            child: allProductsAsync.when(
              data: (allProducts) => Autocomplete<Product>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  if (textEditingValue.text.isEmpty) {
                    return const Iterable<Product>.empty();
                  }
                  return allProducts.where((product) {
                    return product.name.toLowerCase().contains(
                      textEditingValue.text.toLowerCase(),
                    );
                  });
                },
                // Return an empty string to clear the field on selection from custom options view
                displayStringForOption: (Product option) => '',
                onSelected: (Product selection) {
                  _addToCart(selection, ref, context);
                },
                optionsViewBuilder: (context, onSelected, options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      elevation: 4.0,
                      child: SizedBox(
                        // Constrain the height of the options view
                        height: 250,
                        child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final Product option = options.elementAt(index);
                            final productPrice = option.pricing.firstWhere(
                              (p) => p.priceGroup == selectedPriceList,
                              orElse: () => option.pricing.isNotEmpty
                                  ? option.pricing.first
                                  : const ProductPricing(
                                      priceGroup: 'N/A',
                                      cost: 0,
                                    ),
                            );
                            final priceString =
                                '${productPrice.cost.toStringAsFixed(0)}đ';

                            return ListTile(
                              title: Text(option.name),
                              subtitle: Text(
                                'Code: ${option.code} - Giá: $priceString',
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
                          // Xóa text sau khi submit để có thể tìm kiếm tiếp
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
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: cartItems.isEmpty
                ? const Center(
                    child: Text('Chưa có sản phẩm nào trong giỏ hàng.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text(
                            'Màu: ${item.colorName} - Base: ${item.base}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.quantity} x ${item.unitPrice.toStringAsFixed(0)}đ',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  ref
                                      .read(cartProvider.notifier)
                                      .removeFromCartByIndex(index);
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(
                context,
              ).colorScheme.surfaceContainerHighest.withOpacity(0.3),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tổng Quan Thanh Toán',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryRow(context, 'Tiền hàng', totalString),
                  const SizedBox(height: 16),
                  _buildSummaryRow(context, 'Giảm giá', '0đ'),
                  const SizedBox(height: 16),
                  _buildSummaryRow(context, 'Thu khác', '0đ'),
                  const Divider(height: 32),
                  _buildSummaryRow(
                    context,
                    'Cần thanh toán',
                    totalString,
                    isTotal: true,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: isPrinting
                        ? null
                        : () => _handlePrintQuote(context, ref),
                    icon: isPrinting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : const Icon(Icons.print_outlined),
                    label: Text(
                      isPrinting ? 'Đang xử lý...' : 'In & Lưu Báo Giá',
                    ),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Tạo Đơn Hàng'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isTotal = false,
  }) {
    final style = isTotal
        ? Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }
}

/// Header for Mobile view, containing customer and price list selection.
class _SalesHeader extends ConsumerWidget {
  const _SalesHeader();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          Expanded(child: _CustomerSelector()),
          SizedBox(width: 8),
          Expanded(child: _PriceListSelector()),
        ],
      ),
    );
  }
}

/// A dropdown-like widget to select a customer.
class _CustomerSelector extends ConsumerWidget {
  const _CustomerSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);

    return PopupMenuButton<Customer>(
      onSelected: (Customer customer) {
        ref.read(selectedCustomerProvider.notifier).state = customer;
      },
      itemBuilder: (BuildContext context) {
        return customers.map((Customer customer) {
          return PopupMenuItem<Customer>(
            value: customer,
            child: Text(customer.name),
          );
        }).toList();
      },
      child: InputChip(
        avatar: const Icon(Icons.person_outline),
        label: Text(
          selectedCustomer?.name ?? 'Chọn khách hàng',
          overflow: TextOverflow.ellipsis,
        ),
        onPressed: null, // The PopupMenuButton handles the tap
        deleteIcon: const Icon(Icons.arrow_drop_down, size: 18),
        onDeleted: () {}, // Dummy to show the dropdown icon
      ),
    );
  }
}

/// A dropdown-like widget to select a price list.
class _PriceListSelector extends ConsumerWidget {
  const _PriceListSelector();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceLists = ref.watch(priceListsProvider);
    final selectedPriceList = ref.watch(selectedPriceListProvider);

    return PopupMenuButton<String>(
      onSelected: (String priceList) {
        ref.read(selectedPriceListProvider.notifier).state = priceList;
      },
      itemBuilder: (BuildContext context) {
        return priceLists.map((String priceList) {
          return PopupMenuItem<String>(
            value: priceList,
            child: Text(priceList),
          );
        }).toList();
      },
      child: InputChip(
        avatar: const Icon(Icons.sell_outlined),
        label: Text(selectedPriceList, overflow: TextOverflow.ellipsis),
        onPressed: null, // The PopupMenuButton handles the tap
        deleteIcon: const Icon(Icons.arrow_drop_down, size: 18),
        onDeleted: () {}, // Dummy to show the dropdown icon
      ),
    );
  }
}

/// A counter widget to add/remove a product from the cart directly from the product list.
class _ProductCounter extends ConsumerWidget {
  const _ProductCounter({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cartItems = ref.watch(cartProvider);
    final itemIndex = cartItems.indexWhere(
      (item) => item.productId == product.id,
    );
    final quantityInCart = itemIndex != -1
        ? cartItems[itemIndex].quantity.toInt()
        : 0;

    if (quantityInCart == 0) {
      return IconButton(
        icon: const Icon(Icons.add_shopping_cart_outlined),
        tooltip: 'Thêm vào giỏ',
        onPressed: () {
          ref.read(cartProvider.notifier).addToCart(product);
        },
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          tooltip: 'Bớt',
          onPressed: () {
            ref.read(cartProvider.notifier).decrementFromCart(product);
          },
        ),
        Text(
          quantityInCart.toString(),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          tooltip: 'Thêm',
          onPressed: () {
            ref.read(cartProvider.notifier).addToCart(product);
          },
        ),
      ],
    );
  }
}
