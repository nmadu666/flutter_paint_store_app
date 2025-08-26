import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- Data Model ---
enum OrderStatus { processing, delivered, cancelled }

class Order {
  final String customerName;
  final String id;
  final double totalAmount;
  final OrderStatus status;

  Order({
    required this.customerName,
    required this.id,
    required this.totalAmount,
    required this.status,
  });
}

// --- Mock Data ---
final List<Order> _mockOrders = [
  Order(
    customerName: 'Nguyễn Văn A',
    id: '#12345',
    totalAmount: 2500000,
    status: OrderStatus.processing,
  ),
  Order(
    customerName: 'Trần Thị B',
    id: '#12346',
    totalAmount: 1800000,
    status: OrderStatus.delivered,
  ),
  Order(
    customerName: 'Lê Văn C',
    id: '#12347',
    totalAmount: 3200000,
    status: OrderStatus.cancelled,
  ),
  Order(
    customerName: 'Phạm Thị D',
    id: '#12348',
    totalAmount: 950000,
    status: OrderStatus.processing,
  ),
];

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Đơn hàng'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: _mockOrders.length,
        itemBuilder: (context, index) {
          final order = _mockOrders[index];
          return OrderListItem(order: order);
        },
      ),
    );
  }
}

class OrderListItem extends StatelessWidget {
  final Order order;

  const OrderListItem({super.key, required this.order});

  // Helper to format currency
  String _formatCurrency(double amount) {
    final format = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return format.format(amount);
  }

  // Helper to get status properties
  ({String text, Color color}) _getStatusProperties(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return (text: 'Đang xử lý', color: Colors.orange.shade700);
      case OrderStatus.delivered:
        return (text: 'Đã giao', color: Colors.green.shade700);
      case OrderStatus.cancelled:
        return (text: 'Đã huỷ', color: Colors.red.shade700);
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = _getStatusProperties(order.status);
    final textTheme = Theme.of(context).textTheme;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 8.0),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: _buildTitle(context, status, textTheme),
        children: [_buildActionButtons(context)],
      ),
    );
  }

  Widget _buildTitle(BuildContext context, ({Color color, String text}) status, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.customerName,
            style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Mã ĐH: ${order.id}', style: textTheme.bodySmall),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tổng tiền: ${_formatCurrency(order.totalAmount)}',
                style: textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: status.color,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status.text,
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
          if (order.status != OrderStatus.cancelled)
            TextButton.icon(
              icon: const Icon(Icons.cancel_outlined),
              label: const Text('Huỷ đơn'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade700,
              ),
              onPressed: () {
                // TODO: Implement cancel functionality
              },
            ),
        ],
      ),
    );
  }
}