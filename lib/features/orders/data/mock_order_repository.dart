/* import '../../../data/mock_data.dart';
import '../../../models/customer.dart';
import '../../../models/order.dart';
import '../domain/order_repository.dart';

/// A mock implementation of the [OrderRepository] for development and testing.
///
/// It simulates network delays and returns data from a static mock source.
class MockOrderRepository implements OrderRepository {
  @override
  Future<List<Order>> getOrders() async {
    // Simulate a network delay to mimic real-world API calls
    await Future.delayed(const Duration(milliseconds: 500));
    return mockOrders;
  }

  @override
  Future<List<Customer>> getCustomers() async {
    // Simulate a network delay
    await Future.delayed(const Duration(milliseconds: 300));
    return mockCustomers;
  }
}

 */