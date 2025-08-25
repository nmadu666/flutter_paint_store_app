import 'package:flutter/material.dart';

class CustomerEditScreen extends StatelessWidget {
  const CustomerEditScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: _buildHeader(context),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Thông tin'),
              Tab(text: 'Thông tin xuất hoá đơn'),
              Tab(text: 'Dư nợ'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildInfoTab(context),
            const Center(child: Text('Đang xây dựng')),
            const Center(child: Text('Đang xây dựng')),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Tên khách hàng', // Replace with actual data
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Text(
              'Mã khách hàng', // Replace with actual data
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const Spacer(),
            Text(
              'Chi nhánh tạo', // Replace with actual data
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Text('Nợ: 0'), // Replace with actual data
            const SizedBox(width: 16),
            const Text('Tổng bán trừ trả hàng: 0'), // Replace with actual data
          ],
        ),
      ],
    );
  }

  Widget _buildInfoTab(BuildContext context) {
    // This can be the form from the previous turn.
    // For now, I'll just put a placeholder.
    return const Center(child: Text('Thông tin khách hàng'));
  }
}
