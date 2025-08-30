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

// ID for the default "Retail Customer".
// TODO: Consider moving this to a configuration file or using a more robust identification method
// instead of a hardcoded ID, if possible.
const int retailCustomerId = 1;

// Provider to get the specific "Retail Customer" object.
// This centralizes the logic and avoids scattering the magic ID `1` across the UI.
final retailCustomerProvider = Provider<Customer>((ref) {
  final customers = ref.watch(customersProvider);
  // Using firstWhere is acceptable if we are certain the retail customer always exists.
  return customers.firstWhere((c) => c.id == retailCustomerId);
});
