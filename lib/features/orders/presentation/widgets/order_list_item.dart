import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/order.dart';


class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

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
    final statusColor = _getStatusColor(order.status);
    final statusText = order.statusValue ?? 'Không xác định';
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: _buildTitle(context, statusText, statusColor, textTheme),
        children: [_buildActionButtons(context)],
      ),
    );
  }

  Widget _buildTitle(
      BuildContext context, String statusText, Color statusColor, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.customerName ?? 'Khách lẻ',
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

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      color: Colors.grey.shade100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          TextButton.icon(
            icon: const Icon(Icons.print_outlined),
            label: const Text('In'),
            onPressed: () {
              // TODO: Implement print functionality
            },
          ),
          TextButton.icon(
            icon: const Icon(Icons.share_outlined),
            label: const Text('Chia sẻ'),
            onPressed: () {
              // TODO: Implement share functionality
            },
          ),
          if (order.status != 3) // 3: Đã huỷ
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Huỷ đơn'),
              style: TextButton.styleFrom(foregroundColor: Colors.red.shade700),
              onPressed: () {
                // TODO: Implement cancel functionality
              },
            ),
        ],
      ),
    );
  }
}

