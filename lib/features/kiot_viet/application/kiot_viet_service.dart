import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/data/kiot_viet_api_client.dart';

// Provider for the KiotVietApiClient
final kiotVietApiClientProvider = Provider((ref) => KiotVietApiClient());

// Provider for the KiotVietService
final kiotVietServiceProvider = Provider((ref) {
  final apiClient = ref.watch(kiotVietApiClientProvider);
  return KiotVietService(apiClient);
});

class KiotVietService {
  const KiotVietService(this._apiClient);
  final KiotVietApiClient _apiClient;

  // Example function to get branches
  Future<Map<String, dynamic>> getBranches() async {
    try {
      // 'branches' is a common endpoint, good for a test.
      final result = await _apiClient.get(endpoint: 'branches');
      return result;
    } catch (e) {
      // Rethrow to be handled by the UI layer
      rethrow;
    }
  }
}
