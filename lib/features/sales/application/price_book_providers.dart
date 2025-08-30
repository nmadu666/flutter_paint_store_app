import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/price_book.dart';

import '../../admin/application/firebase_service.dart';

// Provider để lấy danh sách tất cả bảng giá từ Firebase.
final priceBooksProvider = FutureProvider<List<PriceBook>>((ref) {
  final firebaseService = ref.watch(firebaseServiceProvider);
  return firebaseService.getPriceBooks();
}, name: 'priceBooksProvider');
