import '../../../models/order.dart';

abstract class OrderRepository {
  /// Fetches a list of orders and validates their related entities against Firebase.
  Future<List<Order>> getOrders();

  /// Fetches a single, detailed order by its ID from the data source.
  Future<Order> getOrderById(int id);
}
