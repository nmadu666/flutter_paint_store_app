import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../application/order_provider.dart';
import 'widgets/order_list_item.dart';

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final RefreshController refreshController = RefreshController(
      initialRefresh: false,
    );
    final ordersAsync = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh sách Đơn hàng'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.onPrimary,
      ),
      body: ordersAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Lỗi: $err'),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(kiotVietOrdersProvider);
                },
                child: const Text('Thử lại'),
              ),
            ],
          ),
        ),
        data: (orders) {
          if (orders.isEmpty) {
            return const Center(
              child: Text(
                'Không có đơn hàng nào.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }
          return SmartRefresher(
            controller: refreshController,
            onRefresh: () async {
              ref.invalidate(kiotVietOrdersProvider);
              refreshController.refreshCompleted();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: orders.length,
              itemBuilder: (context, index) =>
                  OrderListItem(orderWithCustomer: orders[index]),
            ),
          );
        },
      ),
    );
  }
}