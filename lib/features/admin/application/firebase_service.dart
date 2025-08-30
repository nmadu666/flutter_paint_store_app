import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/models/price_book.dart';
import 'package:flutter_paint_store_app/models/product.dart';

// Firestore giới hạn mỗi batch write tối đa 500 operations.
// Việc định nghĩa nó như một hằng số giúp mã nguồn rõ ràng hơn.
const int _firestoreBatchSize = 500;

class FirebaseService {
  final FirebaseFirestore _firestore;

  // Áp dụng Dependency Injection: FirebaseFirestore được truyền vào từ bên ngoài.
  // Điều này giúp cho việc viết unit test trở nên dễ dàng hơn rất nhiều.
  FirebaseService(this._firestore);

  /// Ghi một danh sách dữ liệu vào một collection trên Firestore theo từng batch.
  ///
  /// Mỗi item trong danh sách [data] phải chứa một key 'id' sẽ được dùng làm
  /// document ID trên Firestore.
  ///
  /// Ném ra một [ArgumentError] nếu có bất kỳ item nào thiếu 'id'.
  Future<void> batchWrite(
    List<Map<String, dynamic>> data,
    String collectionPath, {
    void Function(int written, int total)? onProgress,
  }) async {
    if (data.isEmpty) {
      onProgress?.call(0, 0);
      return;
    }

    final collection = _firestore.collection(collectionPath);
    final totalItems = data.length;
    int itemsWritten = 0;

    for (int i = 0; i < totalItems; i += _firestoreBatchSize) {
      final batch = _firestore.batch();

      // Xác định điểm cuối của chunk hiện tại.
      final end = (i + _firestoreBatchSize > totalItems) ? totalItems : i + _firestoreBatchSize;
      final chunk = data.sublist(i, end);

      for (final item in chunk) {
        // Đảm bảo mỗi item có 'id' hợp lệ để làm document ID.
        final docId = item['id']?.toString();
        if (docId == null || docId.isEmpty) {
          throw ArgumentError(
            'FirebaseService.batchWrite: Một item trong collection "$collectionPath" bị thiếu trường "id" hợp lệ. Item: $item',
          );
        }

        batch.set(collection.doc(docId), item);
      }

      await batch.commit();
      itemsWritten += chunk.length;
      onProgress?.call(itemsWritten, totalItems);
    }
  }

  /// Phương thức generic để lấy toàn bộ documents từ một collection
  /// và chuyển đổi chúng thành một danh sách các đối tượng Dart.
  ///
  /// - [collectionPath]: Đường dẫn đến collection trên Firestore.
  /// - [fromJson]: Hàm để chuyển đổi một `Map<String, dynamic>` thành đối tượng kiểu `T`.
  Future<List<T>> _getCollectionData<T>(
    String collectionPath,
    T Function(Map<String, dynamic> data) fromJson,
  ) async {
    try {
      final snapshot = await _firestore.collection(collectionPath).get();
      if (snapshot.docs.isEmpty) {
        return [];
      }
      // Chuyển đổi mỗi document thành đối tượng T
      return snapshot.docs.map((doc) => fromJson(doc.data())).toList();
    } on FirebaseException catch (e, stack) {
      // Ghi lại lỗi và ném ra một exception rõ ràng hơn cho tầng trên xử lý.
      print('Lỗi Firebase khi lấy dữ liệu từ "$collectionPath": $e');
      print(stack);
      throw Exception('Không thể tải dữ liệu từ $collectionPath.');
    } catch (e, stack) {
      print('Lỗi không xác định khi lấy dữ liệu từ "$collectionPath": $e');
      print(stack);
      throw Exception('Đã xảy ra lỗi không mong muốn khi tải dữ liệu.');
    }
  }

  /// Lấy danh sách tất cả sản phẩm.
  Future<List<Product>> getProducts() => _getCollectionData('products', Product.fromJson);

  /// Lấy danh sách tất cả khách hàng.
  Future<List<Customer>> getCustomers() => _getCollectionData('customers', Customer.fromJson);

  /// Lấy danh sách tất cả bảng giá.
  Future<List<PriceBook>> getPriceBooks() => _getCollectionData('pricebooks', PriceBook.fromJson);
}

// Provider để cung cấp instance của FirebaseService cho toàn ứng dụng.
final firebaseServiceProvider = Provider<FirebaseService>((ref) {
  return FirebaseService(FirebaseFirestore.instance);
});
