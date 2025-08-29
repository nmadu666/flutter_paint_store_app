import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/admin/application/firebase_service.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';

enum SyncStatus { idle, inProgress, success, error, disabled }

class SyncItem {
  final String title;
  final String endpoint;
  final String collectionPath;
  final SyncStatus status;
  final String progressMessage;
  final double progress;

  SyncItem({
    required this.title,
    required this.endpoint,
    required this.collectionPath,
    this.status = SyncStatus.idle,
    this.progressMessage = '',
    this.progress = 0.0,
  });

  SyncItem copyWith({
    SyncStatus? status,
    String? progressMessage,
    double? progress,
  }) {
    return SyncItem(
      title: title,
      endpoint: endpoint,
      collectionPath: collectionPath,
      status: status ?? this.status,
      progressMessage: progressMessage ?? this.progressMessage,
      progress: progress ?? this.progress,
    );
  }
}

class SyncNotifier extends StateNotifier<List<SyncItem>> {
  SyncNotifier(this._kiotVietService, this._firebaseService) : super([
    SyncItem(title: 'Categories', endpoint: 'categories', collectionPath: 'categories', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Products', endpoint: 'products', collectionPath: 'products', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Customers', endpoint: 'customers', collectionPath: 'customers', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Branches', endpoint: 'branches', collectionPath: 'branches', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Users', endpoint: 'users', collectionPath: 'users', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    // Endpoint for vouchers might be incorrect, causing 404 errors.
    SyncItem(title: 'Vouchers', endpoint: 'vouchers', collectionPath: 'vouchers', status: SyncStatus.disabled, progressMessage: 'Endpoint might be incorrect. Verify with KiotViet support.'),
    SyncItem(title: 'Customer Groups', endpoint: 'customers/group', collectionPath: 'customergroups', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Price Books', endpoint: 'pricebooks', collectionPath: 'pricebooks', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
    SyncItem(title: 'Sale Channels', endpoint: 'salechannel', collectionPath: 'salechannels', progressMessage: 'Đã đồng bộ ngày 29/08/2025'),
  ]);

  final KiotVietService _kiotVietService;
  final FirebaseService _firebaseService;

  List<Map<String, dynamic>> _transformData(List<Map<String, dynamic>> data, String endpoint) {
    if (data.isEmpty) {
      return [];
    }

    String idField;
    switch (endpoint) {
      case 'categories':
        idField = 'categoryId';
        break;
      default:
        idField = 'id';
    }

    return data.map((item) {
      final newItem = {...item};
      if (newItem.containsKey(idField)) {
        newItem['id'] = newItem[idField];
      }
      return newItem;
    }).toList();
  }

  Future<void> startSync(SyncItem item) async {
    if (item.status == SyncStatus.disabled) return;

    debugPrint('Starting sync for ${item.title}');
    _updateItem(item, status: SyncStatus.inProgress, progressMessage: 'Fetching from KiotViet...', progress: 0.0);

    try {
      final data = await _kiotVietService.getAll(
        item.endpoint,
        onProgress: (fetched, total) {
          _updateItem(item, progressMessage: 'Fetched $fetched of $total from KiotViet...', progress: total > 0 ? fetched / total * 0.5 : 0.0);
        },
      );
      debugPrint('Fetched ${data.length} items from KiotViet for ${item.title}.');

      final transformedData = _transformData(data, item.endpoint);

      if (transformedData.isNotEmpty) {
        debugPrint('First item for ${item.title} after transform: ${transformedData.first}');
      }

      _updateItem(item, progressMessage: 'Writing ${transformedData.length} items to Firebase...', progress: 0.5);

      try {
        await _firebaseService.batchWrite(
          transformedData,
          item.collectionPath,
          onProgress: (written, total) {
            debugPrint('Wrote $written of $total to Firebase for ${item.title}.');
            _updateItem(item, progressMessage: 'Wrote $written of $total to Firebase...', progress: 0.5 + (total > 0 ? written / total * 0.5 : 0.0));
          },
        );
      } catch (e) {
        debugPrint('Error writing to Firebase for ${item.title}: $e');
        rethrow;
      }

      _updateItem(item, status: SyncStatus.success, progressMessage: 'Sync completed successfully.', progress: 1.0);
      debugPrint('Sync completed successfully for ${item.title}');
    } catch (e) {
      debugPrint('An error occurred during sync for ${item.title}: $e');
      _updateItem(item, status: SyncStatus.error, progressMessage: 'Error: ${e.toString()}', progress: 0.0);
    }
  }

  void _updateItem(SyncItem item, {SyncStatus? status, String? progressMessage, double? progress}) {
    state = [
      for (final i in state)
        if (i.title == item.title)
          i.copyWith(status: status, progressMessage: progressMessage, progress: progress)
        else
          i,
    ];
  }
}

final syncNotifierProvider = StateNotifierProvider<SyncNotifier, List<SyncItem>>((ref) {
  final kiotVietService = ref.watch(kiotVietServiceProvider);
  final firebaseService = FirebaseService();
  return SyncNotifier(kiotVietService, firebaseService);
});

class SyncScreen extends ConsumerWidget {
  const SyncScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final syncItems = ref.watch(syncNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync KiotViet Data'),
      ),
      body: ListView.builder(
        itemCount: syncItems.length,
        itemBuilder: (context, index) {
          final item = syncItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: ListTile(
              title: Text(item.title),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 4),
                  Text(item.progressMessage),
                  if (item.status == SyncStatus.inProgress)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: LinearProgressIndicator(value: item.progress),
                    ),
                ],
              ),
              trailing: _buildTrailingWidget(item, ref),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTrailingWidget(SyncItem item, WidgetRef ref) {
    switch (item.status) {
      case SyncStatus.inProgress:
        return const CircularProgressIndicator();
      case SyncStatus.success:
        return const Icon(Icons.check_circle, color: Colors.green);
      case SyncStatus.error:
        return const Icon(Icons.error, color: Colors.red);
      case SyncStatus.disabled:
        return const Icon(Icons.warning, color: Colors.orange);
      case SyncStatus.idle:
      default:
        return ElevatedButton(
          onPressed: item.status == SyncStatus.inProgress || item.status == SyncStatus.disabled ? null : () => ref.read(syncNotifierProvider.notifier).startSync(item),
          child: const Text('Sync'),
        );
    }
  }
}
