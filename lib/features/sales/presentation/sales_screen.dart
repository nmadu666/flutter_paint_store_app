import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/features/sales/infrastructure/quote_pdf_service.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_app_bar.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/product_list.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/cart/desktop_cart_table.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/cart/mobile_cart_item.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/price_formatter.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_header.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  Future<void> _handlePrintQuote(BuildContext context, WidgetRef ref) async {
    final quote = ref.read(quoteProvider);
    final quoteItems = quote.items;
    if (quoteItems.isEmpty) {
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
      final total = ref.read(quoteTotalProvider);
      await QuotePdfService().generateAndPrintQuote(
        cartItems: quoteItems,
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
        final isMobile = constraints.maxWidth < 900;
        if (isMobile) {
          return _buildMobileLayout(context, ref);
        } else {
          return _buildDesktopLayout(context, ref);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final isShowingCart = ref.watch(isShowingCartMobileProvider);
    final quoteItems = ref.watch(quoteProvider).items;

    return Scaffold(
      appBar: const SalesAppBar(isMobile: true),
      body: isShowingCart
          ? MobileCartView(onPrint: () => _handlePrintQuote(context, ref))
          : const ProductList(),
      floatingActionButton: !isShowingCart && quoteItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () =>
                  ref.read(isShowingCartMobileProvider.notifier).state = true,
              label: Text('Xem giỏ hàng (${quoteItems.length})'),
              icon: const Icon(Icons.shopping_cart_outlined),
            )
          : null,
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteProvider);

    return Scaffold(
      appBar: const SalesAppBar(isMobile: false),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 3,
            child: ReorderableDesktopCartTable(
              items: quote.items,
              onReorder: (oldIndex, newIndex) {
                ref
                    .read(quoteProvider.notifier)
                    .reorderItem(oldIndex, newIndex);
              },
            ),
          ),
          Expanded(
            flex: 1,
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: PaymentSummary(onPrint: () => _handlePrintQuote(context, ref)),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileCartView extends StatelessWidget {
  final VoidCallback onPrint;
  const MobileCartView({super.key, required this.onPrint});

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        final quoteItems = ref.watch(quoteProvider).items;

        if (quoteItems.isEmpty) {
          return const Center(child: Text('Giỏ hàng của bạn đang trống.'));
        }

        return Column(
          children: [
            const SalesHeader(),
            const Divider(height: 1),
            Expanded(
              child: ReorderableListView.builder(
                itemCount: quoteItems.length,
                itemBuilder: (context, index) {
                  final item = quoteItems[index];
                  return MobileCartItem(key: ValueKey(item.id), item: item);
                },
                onReorder: (oldIndex, newIndex) {
                  ref.read(quoteProvider.notifier).reorderItem(oldIndex, newIndex);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PaymentSummary(onPrint: onPrint, useSpacer: false),
            ),
          ],
        );
      },
    );
  }
}

class PaymentSummary extends ConsumerWidget {
  final VoidCallback onPrint;
  final bool useSpacer;
  const PaymentSummary({super.key, required this.onPrint, this.useSpacer = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(quoteProvider);
    final cartTotal = ref.watch(quoteTotalProvider);
    final isPrinting = ref.watch(isPrintingProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Tổng Quan Thanh Toán',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 24),
        _buildSummaryRow(
          context,
          'Tiền hàng',
          formatPrice(cartTotal),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow(
          context,
          'Giảm giá',
          '-${formatPrice(quote.items.fold<double>(0.0, (sum, item) => sum + item.totalDiscount))}',
        ),
        const SizedBox(height: 16),
        _buildSummaryRow(context, 'Thu khác', formatPrice(0)),
        const Divider(height: 32),
        _buildSummaryRow(
          context,
          'Cần thanh toán',
          formatPrice(cartTotal),
          isTotal: true,
        ),
        if (useSpacer) const Spacer(),
        if (!useSpacer) const SizedBox(height: 24),
        FilledButton.icon(
          onPressed: isPrinting ? null : onPrint,
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
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value, {
    bool isTotal = false,
  }) {
    final style = isTotal
        ? Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
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