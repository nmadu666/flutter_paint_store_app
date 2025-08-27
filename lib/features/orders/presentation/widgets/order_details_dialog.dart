import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../models/order.dart';


// Helper widget for mobile layout
class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;
  final bool initiallyExpanded;

  const _InfoCard({required this.title, required this.child, this.initiallyExpanded = true});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      clipBehavior: Clip.antiAlias,
      child: ExpansionTile(
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        initiallyExpanded: initiallyExpanded,
        childrenPadding: const EdgeInsets.all(16).copyWith(top: 0),
        children: [child],
      ),
    );
  }
}

class OrderDetailsDialog extends StatelessWidget {
  final Order order;

  const OrderDetailsDialog({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // On mobile, make it take up more screen space
      insetPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Define a breakpoint to switch between layouts
          final bool isMobile = constraints.maxWidth < 650;
          return isMobile ? _buildMobileLayout(context) : _buildDesktopLayout(context);
        },
      ),
    );
  }

  // ===========================================================================
  // Mobile Layout
  // ===========================================================================
  Widget _buildMobileLayout(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildMobileAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildMobileHeaderInfo(context),
            const SizedBox(height: 16),
            _InfoCard(
              title: 'Danh sách sản phẩm',
              child: _buildMobileProductList(context, currencyFormat),
            ),
            _InfoCard(
              title: 'Ghi chú đơn hàng',
              initiallyExpanded: order.description?.isNotEmpty ?? false,
              child: Text(order.description ?? 'Không có ghi chú.'),
            ),
            _InfoCard(
              title: 'Thông tin khác',
              initiallyExpanded: false,
              child: _buildMobileOtherInfo(context),
            ),
          ],
        ),
      ),
    );
  }

  AppBar _buildMobileAppBar(BuildContext context) {
    return AppBar(
      elevation: 1,
      backgroundColor: Colors.white,
      title: const Text('Chi tiết đơn hàng', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      leading: IconButton(
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: ElevatedButton.icon(
            icon: const Icon(Icons.edit, size: 16),
            label: const Text('Chỉnh sửa'),
            onPressed: () { /* TODO: Edit action */ },
          ),
        ),
        PopupMenuButton<String>(
          onSelected: (value) { /* TODO: Handle more actions */ },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
            const PopupMenuItem<String>(value: 'copy', child: Text('Sao chép')),
            const PopupMenuItem<String>(value: 'export', child: Text('Xuất file')),
            const PopupMenuItem<String>(value: 'process', child: Text('Xử lý đơn hàng')),
            const PopupMenuItem<String>(value: 'save', child: Text('Lưu')),
            const PopupMenuDivider(),
            const PopupMenuItem<String>(value: 'finish', child: Text('Kết thúc')),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileHeaderInfo(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Card(
      color: Colors.blueGrey.shade50,
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Mã đặt hàng', style: textTheme.bodySmall),
                Text(order.code ?? 'N/A', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text('Trạng thái', style: textTheme.bodySmall),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.green.shade700,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    order.statusValue ?? 'N/A',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileProductList(BuildContext context, NumberFormat currencyFormat) {
    final details = order.orderDetails ?? [];
    if (details.isEmpty) return const Text('Không có sản phẩm.');

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: details.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final item = details[index];
        final price = (item.price ?? 0).toDouble();
        final quantity = (item.quantity ?? 0).toDouble();

        return ListTile(
          contentPadding: EdgeInsets.zero,
          title: Text(item.productName ?? 'N/A', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mã: ${item.productCode ?? 'N/A'}'),
              if (item.note?.isNotEmpty ?? false) Text('Ghi chú: ${item.note!}', style: TextStyle(color: Colors.grey.shade600, fontStyle: FontStyle.italic)),
            ],
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(currencyFormat.format(price), style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('SL: ${quantity.toStringAsFixed(0)}'),
            ],
          ),
        );
      },
    );
  }

  Widget _buildMobileOtherInfo(BuildContext context) {
    return Column(
      children: [
        _buildDetailRow(context, 'Bảng giá:', 'Bảng giá chung'), // Placeholder
        _buildDetailRow(context, 'Kênh bán:', order.branchName ?? 'N/A'),
        _buildDetailRow(context, 'Người bán:', 'admin'), // Placeholder
        _buildDetailRow(context, 'Người tạo:', 'admin'), // Placeholder
        _buildDetailRow(context, 'Chi nhánh:', order.branchName ?? 'N/A'),
      ],
    );
  }

  // ===========================================================================
  // Desktop Layout (Existing Layout)
  // ===========================================================================
  Widget _buildDesktopLayout(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Thông tin chi tiết đơn đặt hàng', style: textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
              IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.of(context).pop()),
            ],
          ),
          const SizedBox(height: 24),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDesktopInfoSection(textTheme),
                  const SizedBox(height: 24),
                  _buildItemsTableForDesktop(context, currencyFormat),
                  const SizedBox(height: 24),
                  _buildSummaryAndNotes(textTheme, currencyFormat),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          _buildDesktopActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildDesktopInfoSection(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _buildInfoItem(textTheme, 'Người tạo:', 'admin')), // Placeholder
          Expanded(child: _buildInfoItem(textTheme, 'Người nhận:', order.customerName ?? 'Khách lẻ')),
        ]),
        const SizedBox(height: 8),
        Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Expanded(child: _buildInfoItem(textTheme, 'Ngày đặt:', order.createdDate != null ? DateFormat('dd/MM/yyyy HH:mm').format(order.createdDate!) : 'N/A')),
          Expanded(child: _buildInfoItem(textTheme, 'Trạng thái:', order.statusValue ?? 'N/A')),
        ]),
        const SizedBox(height: 8),
        _buildInfoItem(textTheme, 'Kênh bán hàng:', order.branchName ?? 'N/A'),
      ],
    );
  }

  Widget _buildItemsTableForDesktop(BuildContext context, NumberFormat currencyFormat) {
    final details = order.orderDetails ?? [];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Chi tiết hàng hóa', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        SizedBox(
          width: double.infinity,
          child: DataTable(
            columnSpacing: 16,
            headingRowColor: MaterialStateProperty.all(Colors.grey.shade200),
            columns: const [
              DataColumn(label: Text('Mã hàng')), DataColumn(label: Text('Tên hàng')), DataColumn(label: Text('SL')), DataColumn(label: Text('Đơn giá')), DataColumn(label: Text('Giảm giá')), DataColumn(label: Text('Giá bán')), DataColumn(label: Text('Thành tiền')),
            ],
            rows: details.map((item) {
              final unitPrice = (item.price ?? 0).toDouble();
              final quantity = (item.quantity ?? 0).toDouble();
              final discount = (item.discount ?? 0).toDouble();
              final salePrice = unitPrice - discount;
              final total = salePrice * quantity;
              return DataRow(cells: [
                DataCell(Text(item.productCode ?? 'N/A')), DataCell(Text(item.productName ?? 'N/A')), DataCell(Text(quantity.toStringAsFixed(0))), DataCell(Text(currencyFormat.format(unitPrice))), DataCell(Text(currencyFormat.format(discount))), DataCell(Text(currencyFormat.format(salePrice))), DataCell(Text(currencyFormat.format(total))),
              ]);
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryAndNotes(TextTheme textTheme, NumberFormat currencyFormat) {
    final subTotal = (order.orderDetails ?? []).fold<double>(0.0, (sum, item) => sum + ((item.price ?? 0).toDouble() * (item.quantity ?? 0).toDouble()));
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Expanded(flex: 2, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Ghi chú', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        Container(width: double.infinity, padding: const EdgeInsets.all(12), decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), borderRadius: BorderRadius.circular(8)), child: Text(order.description ?? 'Không có ghi chú.', style: textTheme.bodyMedium)),
      ])),
      const SizedBox(width: 24),
      Expanded(flex: 1, child: Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
        _buildSummaryItem(textTheme, 'Tổng tiền:', currencyFormat.format(subTotal)),
        _buildSummaryItem(textTheme, 'Giảm giá phiếu đặt:', currencyFormat.format(order.discount ?? 0)),
        _buildSummaryItem(textTheme, 'Tổng cộng:', currencyFormat.format(order.total ?? 0), isBold: true),
        const Divider(height: 16),
        _buildSummaryItem(textTheme, 'Khách đã trả:', currencyFormat.format(order.totalPayment ?? 0)),
      ])),
    ]);
  }

  Widget _buildDesktopActionButtons(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Wrap(spacing: 8.0, runSpacing: 8.0, alignment: WrapAlignment.end, children: [
        TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Hủy')),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.copy, size: 16), label: const Text('Sao chép')),
        TextButton.icon(onPressed: () {}, icon: const Icon(Icons.print_outlined, size: 16), label: const Text('Xuất file')),
        ElevatedButton(onPressed: () {}, child: const Text('Xử lý đơn hàng')),
        ElevatedButton(onPressed: () {}, child: const Text('Lưu')),
        ElevatedButton(onPressed: () {}, style: ElevatedButton.styleFrom(backgroundColor: Theme.of(context).primaryColor, foregroundColor: Theme.of(context).colorScheme.onPrimary), child: const Text('Kết thúc')),
      ]),
    );
  }

  // ===========================================================================
  // Common Helper Widgets
  // ===========================================================================
  Widget _buildInfoItem(TextTheme textTheme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: RichText(text: TextSpan(style: textTheme.bodyMedium, children: [TextSpan(text: '$label ', style: const TextStyle(fontWeight: FontWeight.bold)), TextSpan(text: value)])));
  }

  Widget _buildSummaryItem(TextTheme textTheme, String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)), Text(value, style: textTheme.bodyMedium?.copyWith(fontWeight: isBold ? FontWeight.bold : FontWeight.normal))]));
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: Theme.of(context).textTheme.bodyMedium), Text(value, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold))]),
    );
  }
}
