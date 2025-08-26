import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/data/mock_data.dart';
import 'package:flutter_paint_store_app/models/customer.dart';

// --- Notifier để quản lý danh sách khách hàng ---
class CustomersNotifier extends StateNotifier<List<Customer>> {
  CustomersNotifier() : super(mockCustomers);

  // Thêm một khách hàng mới vào danh sách
  void addCustomer(Customer customer) {
    state = [...state, customer];
  }

  // Cập nhật một khách hàng đã có
  void updateCustomer(Customer updatedCustomer) {
    state = [
      for (final customer in state)
        if (customer.id == updatedCustomer.id) updatedCustomer else customer,
    ];
  }
}

// Provider cho CustomersNotifier
final customersProvider =
    StateNotifierProvider<CustomersNotifier, List<Customer>>((ref) {
  return CustomersNotifier();
});
