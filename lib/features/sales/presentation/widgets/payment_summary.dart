import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/features/sales/application/ui_state_providers.dart';
import 'price_formatter.dart';

class PaymentSummary extends ConsumerWidget {
  final VoidCallback onPrint;
  final bool useSpacer;
  const PaymentSummary({super.key, required this.onPrint, this.useSpacer = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quote = ref.watch(activeQuoteProvider);
    final subtotal = ref.watch(activeQuoteSubtotalProvider);
    final totalDiscount = ref.watch(activeQuoteTotalDiscountProvider);
    final total = ref.watch(activeQuoteTotalProvider);
    final isPrinting = ref.watch(isPrintingProvider);

    if (quote == null) {
      return const Center(child: Text('Không có báo giá nào được chọn.'));
    }

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
          formatPrice(subtotal),
        ),
        const SizedBox(height: 16),
        _buildSummaryRow(
          context,
          'Giảm giá',
          '-${formatPrice(totalDiscount)}',
        ),
        const SizedBox(height: 16),
        _buildSummaryRow(context, 'Thu khác', formatPrice(0)),
        const Divider(height: 32),
        _buildSummaryRow(
          context,
          'Cần thanh toán',
          formatPrice(total),
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
