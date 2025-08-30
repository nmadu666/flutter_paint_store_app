import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/admin/application/firebase_service.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/data/kiot_viet_data_repository.dart';
import 'package:flutter_paint_store_app/models/branch.dart';
import 'package:flutter_paint_store_app/models/category.dart';
import 'package:flutter_paint_store_app/models/price_book.dart';
import 'package:flutter_paint_store_app/models/product.dart';

// Improvement: Use an enum for type safety instead of a String.
enum SyncableDataType { branches, categories, pricebooks, products }

enum SyncStatus { initial, loading, success, error }

class SyncItemState {
  final int kiotVietCount;
  final int firebaseCount;
  final SyncStatus status;
  final String? errorMessage;

  SyncItemState({
    this.kiotVietCount = 0,
    this.firebaseCount = 0,
    this.status = SyncStatus.initial,
    this.errorMessage,
  });

  SyncItemState copyWith({
    int? kiotVietCount,
    int? firebaseCount,
    SyncStatus? status,
    String? errorMessage,
  }) {
    return SyncItemState(
      kiotVietCount: kiotVietCount ?? this.kiotVietCount,
      firebaseCount: firebaseCount ?? this.firebaseCount,
      status: status ?? this.status,
      errorMessage: errorMessage,
    );
  }
}

class SyncState {
  final SyncItemState branches;
  final SyncItemState categories;
  final SyncItemState priceBooks;
  final SyncItemState products;

  SyncState({
    required this.branches,
    required this.categories,
    required this.priceBooks,
    required this.products,
  });

  factory SyncState.initial() {
    return SyncState(
      branches: SyncItemState(),
      categories: SyncItemState(),
      priceBooks: SyncItemState(),
      products: SyncItemState(),
    );
  }

  SyncState copyWith({
    SyncItemState? branches,
    SyncItemState? categories,
    SyncItemState? priceBooks,
    SyncItemState? products,
  }) {
    return SyncState(
      branches: branches ?? this.branches,
      categories: categories ?? this.categories,
      priceBooks: priceBooks ?? this.priceBooks,
      products: products ?? this.products,
    );
  }
}

final kiotVietDataRepositoryProvider = Provider<KiotVietDataRepository>((ref) {
  final kiotVietService = ref.watch(kiotVietServiceProvider);
  return KiotVietDataRepositoryImpl(kiotVietService);
});

final firebaseServiceProvider = Provider((ref) => FirebaseService(FirebaseFirestore.instance));

final syncProvider = StateNotifierProvider<SyncNotifier, SyncState>((ref) {
  return SyncNotifier(ref);
});

class SyncNotifier extends StateNotifier<SyncState> {
  final Ref _ref;

  SyncNotifier(this._ref) : super(SyncState.initial()) {
    _loadInitialCounts();
  }

  Future<void> _loadInitialCounts() async {
    await Future.wait([
      _loadFirebaseCount(
        'branches',
        (count) => state = state.copyWith(
          branches: state.branches.copyWith(firebaseCount: count),
        ),
      ),
      _loadFirebaseCount(
        'categories',
        (count) => state = state.copyWith(
          categories: state.categories.copyWith(firebaseCount: count),
        ),
      ),
      _loadFirebaseCount(
        'pricebooks',
        (count) => state = state.copyWith(
          priceBooks: state.priceBooks.copyWith(firebaseCount: count),
        ),
      ),
      _loadFirebaseCount(
        'products',
        (count) => state = state.copyWith(
          products: state.products.copyWith(firebaseCount: count),
        ),
      ),
    ]);
  }

  Future<void> _loadFirebaseCount(
    String collection,
    Function(int) onLoaded,
  ) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(collection)
          .count()
          .get();
      onLoaded(snapshot.count ?? 0);
    } catch (e) {
      onLoaded(0);
    }
  }

  Future<void> syncData(SyncableDataType dataType) async {
    switch (dataType) {
      case SyncableDataType.branches:
        await _sync<Branch>(
          collectionPath: 'branches',
          itemState: state.branches,
          updateState: (s) => state = state.copyWith(branches: s),
          fetchFromKiotViet: (repo) => repo.getBranches(),
        );
        break;
      case SyncableDataType.categories:
        await _sync<Category>(
          collectionPath: 'categories',
          itemState: state.categories,
          updateState: (s) => state = state.copyWith(categories: s),
          fetchFromKiotViet: (repo) => repo.getCategories(),
        );
        break;
      case SyncableDataType.pricebooks:
        await _sync<PriceBook>(
          collectionPath: 'pricebooks',
          itemState: state.priceBooks,
          updateState: (s) => state = state.copyWith(priceBooks: s),
          fetchFromKiotViet: (repo) => repo.getPriceBooks(),
        );
        break;
      case SyncableDataType.products:
        await _sync<Product>(
          collectionPath: 'products',
          itemState: state.products,
          updateState: (s) => state = state.copyWith(products: s),
          fetchFromKiotViet: (repo) => repo.getProducts(),
        );
        break;
    }
  }

  // Improvement: Pass the fetch function as a parameter (Strategy Pattern)
  // to make this method more generic and remove the `switch(T)` block.
  Future<void> _sync<T>({
    required String collectionPath,
    required SyncItemState itemState,
    required Function(SyncItemState) updateState,
    required Future<List<T>> Function(KiotVietDataRepository) fetchFromKiotViet,
  }) async {
    updateState(itemState.copyWith(status: SyncStatus.loading));
    try {
      final repo = _ref.read(kiotVietDataRepositoryProvider);
      final firebaseService = _ref.read(firebaseServiceProvider);

      final items = await fetchFromKiotViet(repo);

      final data = items.map((i) => (i as dynamic).toJson()).cast<Map<String, dynamic>>().toList();
      await firebaseService.batchWrite(data, collectionPath);

      updateState(
        itemState.copyWith(
          status: SyncStatus.success,
          kiotVietCount: items.length,
          firebaseCount: items.length,
        ),
      );
    } catch (e) {
      updateState(
        itemState.copyWith(
          status: SyncStatus.error,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
