import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/quote.dart';

// 1. Provider for the search query
final salesSearchQueryProvider = StateProvider<String>((ref) => '');

// 2. Provider to fetch all products (currently mocked)
final productsProvider = FutureProvider<List<Product>>((ref) async {
  // Simulate network delay
  await Future.delayed(const Duration(milliseconds: 500));
  // In a real app, you would fetch this from Firestore or an API
  return List.generate(
    20,
    (i) => Product(
      id: '$i',
      name: 'Sản phẩm sơn $i',
      code: 'SP$i',
      pricing: [
        ProductPricing(priceGroup: 'Giá bán lẻ', cost: 150000 + i * 1000),
        ProductPricing(priceGroup: 'Giá đại lý cấp 1', cost: 135000 + i * 1000),
        ProductPricing(priceGroup: 'Giá dự án', cost: 120000 + i * 1000),
      ],
    ),
  );
});

// 3. Provider for the filtered list of products
final filteredProductsProvider = Provider<List<Product>>((ref) {
  final query = ref.watch(salesSearchQueryProvider);
  final productsAsyncValue = ref.watch(productsProvider);

  return productsAsyncValue.when(
    data: (products) {
      if (query.isEmpty) {
        return products;
      }
      return products
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.code.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    },
    loading: () => [], // Return empty list while loading
    error: (err, stack) => [], // Return empty list on error
  );
});

// 4. StateNotifier for the cart
class CartNotifier extends StateNotifier<List<QuoteItem>> {
  CartNotifier(this.ref) : super([]);
  final Ref ref;

  void addToCart(Product product) {
    final selectedPriceList = ref.read(selectedPriceListProvider);
    final productPrice = product.pricing.firstWhere(
      (p) => p.priceGroup == selectedPriceList,
      // Fallback to the first available price if not found
      orElse: () => product.pricing.first,
    );
    final unitPrice = productPrice.cost;

    final existingItemIndex = state.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingItemIndex != -1) {
      // Item exists, update quantity
      final existingItem = state[existingItemIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + 1,
        unitPrice: unitPrice, // Update price in case price list changed
        totalPrice: unitPrice * (existingItem.quantity + 1),
      );
      final newState = List<QuoteItem>.from(state);
      newState[existingItemIndex] = updatedItem;
      state = newState;
    } else {
      // Item does not exist, add new
      final newItem = QuoteItem(
        productId: product.id,
        productName: product.name,
        colorName: "Màu mặc định",
        hexCode: "FFFFFF",
        base: "P",
        quantity: 1,
        unitPrice: unitPrice,
        totalPrice: unitPrice,
        sku: "${product.code}_P_FFFFFF", // Giả lập SKU
      );
      state = [...state, newItem];
    }
  }

  void decrementFromCart(Product product) {
    final existingItemIndex = state.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingItemIndex != -1) {
      final existingItem = state[existingItemIndex];
      if (existingItem.quantity > 1) {
        final updatedItem = existingItem.copyWith(
          quantity: existingItem.quantity - 1,
          totalPrice: existingItem.unitPrice * (existingItem.quantity - 1),
        );
        final newState = List<QuoteItem>.from(state);
        newState[existingItemIndex] = updatedItem;
        state = newState;
      } else {
        // If quantity is 1, remove it from cart
        _removeItemByProductId(product.id);
      }
    }
  }

  void _removeItemByProductId(String productId) {
    state = state.where((item) => item.productId != productId).toList();
  }

  void updateCartPrices() {
    final productsAsync = ref.read(productsProvider);
    final newPriceList = ref.read(selectedPriceListProvider);

    // Only update prices if the product list is available
    productsAsync.whenData((products) {
      // Create a map for efficient product lookup
      final productMap = {for (var p in products) p.id: p};

      final updatedCart = state.map((item) {
        final product = productMap[item.productId];
        if (product == null) {
          return item; // Keep item as is if product not found
        }

        final productPrice = product.pricing.firstWhere(
          (p) => p.priceGroup == newPriceList,
          orElse: () => product.pricing.first, // Fallback
        );
        final newUnitPrice = productPrice.cost;

        return item.copyWith(
          unitPrice: newUnitPrice,
          totalPrice: newUnitPrice * item.quantity,
        );
      }).toList();
      state = updatedCart;
    });
  }

  void removeFromCartByIndex(int index) {
    state = List.from(state)..removeAt(index);
  }

  void clear() {
    state = [];
  }
}

// 5. Provider for the CartNotifier
final cartProvider = StateNotifierProvider<CartNotifier, List<QuoteItem>>((
  ref,
) {
  final notifier = CartNotifier(ref);

  // When the price list changes, trigger a price update for all items in the cart.
  ref.listen<String>(selectedPriceListProvider, (previous, next) {
    notifier.updateCartPrices();
  });

  return notifier;
});

// 6. Provider for mobile UI state
final isShowingCartMobileProvider = StateProvider<bool>((ref) => false);

// 7. Provider to manage the printing state
final isPrintingProvider = StateProvider<bool>((ref) => false);

// 7. Provider to calculate the cart total
final cartTotalProvider = Provider<double>((ref) {
  final cartItems = ref.watch(cartProvider);
  if (cartItems.isEmpty) {
    return 0.0;
  }
  return cartItems.fold(0.0, (sum, item) => sum + item.totalPrice);
});

// 7. Customer Providers
final customersProvider = Provider<List<Customer>>((ref) {
  // In a real app, fetch from Firestore
  return [
    Customer(id: '1', name: 'Khách lẻ', phone: '', address: ''),
    Customer(id: '2', name: 'Anh Sơn - Cầu Giấy', phone: '', address: ''),
    Customer(id: '3', name: 'Công ty Xây dựng ABC', phone: '', address: ''),
  ];
});

final selectedCustomerProvider = StateProvider<Customer?>((ref) => null);

// 8. Price List Providers
final priceListsProvider = Provider<List<String>>((ref) {
  return ['Giá bán lẻ', 'Giá đại lý cấp 1', 'Giá dự án'];
});

final selectedPriceListProvider = StateProvider<String>((ref) {
  return ref.watch(priceListsProvider).first;
});
