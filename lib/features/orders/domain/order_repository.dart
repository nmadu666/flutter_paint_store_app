import '../../../models/customer.dart';
import '../../../models/order.dart';

/// Abstract interface for the orders data layer.
abstract class OrderRepository {
  Future<List<Order>> getOrders();

  Future<List<Customer>> getCustomers();
}

