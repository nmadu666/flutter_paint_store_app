import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/order.dart';
import '../../application/order_provider.dart'; // Import OrderWithCustomer
import 'order_details_dialog.dart';

class OrderListItem extends StatelessWidget {
  final OrderWithCustomer orderWithCustomer;

  const OrderListItem({super.key, required this.orderWithCustomer});

  // Helper to format currency
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return format.format(amount);
  }

  // Helper to get status properties
  Color _getStatusColor(int? status) {
    switch (status) {
      case 2: // Đang xử lý
        return Colors.orange.shade700;
      case 1: // Hoàn thành
        return Colors.green.shade700;
      case 3: // Đã huỷ
        return Colors.red.shade700;
      default:
        return Colors.grey.shade700;
    }
  }

  @override
  Widget build(BuildContext context) {
    final order = orderWithCustomer.order; // Get the order
    final statusColor = _getStatusColor(order.status);
    final statusText = order.statusValue ?? 'Không xác định';
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _showOrderDetailsDialog(context, order),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(context, statusText, statusColor, textTheme),
            _buildActionButtons(context, order),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(
      BuildContext context, String statusText, Color statusColor, TextTheme textTheme) {
    final order = orderWithCustomer.order;
    final customer = orderWithCustomer.customer;
    final customerName = customer?.name ?? order.customerName ?? 'Khách lẻ';

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            customerName,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Mã ĐH: ${order.code ?? 'N/A'}', style: textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền: ${_formatCurrency((order.total ?? 0).toDouble())}',
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, Order order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.03),
        border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _actionButton(
            context,
            icon: Icons.info_outline,
            label: 'Chi tiết',
            onPressed: () => _showOrderDetailsDialog(context, order),
          ),
          _actionButton(
            context,
            icon: Icons.print_outlined,
            label: 'In',
            onPressed: () { /* TODO: Implement print */ },
          ),
          _actionButton(
            context,
            icon: Icons.share_outlined,
            label: 'Chia sẻ',
            onPressed: () { /* TODO: Implement share */ },
          ),
          if (order.status != 3) // Not cancelled
            _actionButton(
              context,
              icon: Icons.cancel_outlined,
              label: 'Huỷ đơn',
              color: Colors.red.shade700,
              onPressed: () { /* TODO: Implement cancel */ },
            ),
        ],
      ),
    );
  }

  Widget _actionButton(BuildContext context, {required IconData icon, required String label, required VoidCallback onPressed, Color? color}) {
    return TextButton.icon(
      icon: Icon(icon, size: 18),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: color ?? Theme.of(context).colorScheme.onSurface,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      ),
      onPressed: onPressed,
    );
  }

  void _showOrderDetailsDialog(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return OrderDetailsDialog(order: order);
      },
    );
  }
}