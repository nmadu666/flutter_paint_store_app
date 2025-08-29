import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/data/kiot_viet_api_client.dart';

// Provider for the KiotVietApiClient
final kiotVietApiClientProvider = Provider((ref) => KiotVietApiClient());

// Provider for the KiotVietService
final kiotVietServiceProvider = Provider((ref) {
  final apiClient = ref.watch(kiotVietApiClientProvider);
  return KiotVietService(apiClient);
});

/// A callback to report progress during a long-running operation.
/// [fetched] is the number of items fetched so far.
/// [total] is the total number of items to fetch.
typedef ProgressCallback = void Function(int fetched, int total);

class KiotVietService {
  static const int _maxPageSize = 100;
  const KiotVietService(this._apiClient);
  final KiotVietApiClient _apiClient;

  /// Fetches a single page of data from a KiotViet endpoint.
  Future<Map<String, dynamic>> get(String endpoint,
      {Map<String, dynamic>? params}) async {
    try {
      final result = await _apiClient.get(endpoint: endpoint, params: params);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  /// Fetches all items from a paginated KiotViet endpoint.
  Future<List<Map<String, dynamic>>> getAll(
    String endpoint, {
    Map<String, dynamic>? params,
    ProgressCallback? onProgress,
  }) async {
    final allItems = <Map<String, dynamic>>[];
    int currentItem = 0;
    int total = 0;

    try {
      do {
        final pageParams = {
          ...?params,
          'pageSize': _maxPageSize,
          'currentItem': currentItem,
        };

        final response = await get(endpoint, params: pageParams);

        if (response.containsKey('data') && response['data'] is List) {
          final items = List<Map<String, dynamic>>.from(response['data']);
          allItems.addAll(items);

          total = response['total'] as int? ?? 0;
          currentItem += items.length;

          // Report progress
          onProgress?.call(allItems.length, total);

          if (items.length < _maxPageSize) {
            break;
          }
        } else {
          throw KiotVietApiClientException(
              code: 'invalid-response',
              message:
                  'KiotViet API response did not have the expected format.');
        }
      } while (currentItem < total);

      return allItems;
    } catch (e) {
      rethrow;
    }
  }

  // Generic method to make a POST request
  Future<Map<String, dynamic>> post(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final result = await _apiClient.post(endpoint: endpoint, body: body);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Generic method to make a PUT request
  Future<Map<String, dynamic>> put(String endpoint,
      {Map<String, dynamic>? body}) async {
    try {
      final result = await _apiClient.put(endpoint: endpoint, body: body);
      return result;
    } catch (e) {
      rethrow;
    }
  }

  // Generic method to make a DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    try {
      final result = await _apiClient.delete(endpoint: endpoint);
      return result;
    } catch (e) {
      rethrow;
    }
  }
}