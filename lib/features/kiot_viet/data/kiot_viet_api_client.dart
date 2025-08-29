import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

/// A custom exception class for KiotViet API client errors.
class KiotVietApiClientException implements Exception {
  final String message;
  final String code;
  final dynamic details;

  KiotVietApiClientException({
    required this.message,
    required this.code,
    this.details,
  });

  @override
  String toString() => 'KiotVietApiClientException: [$code] $message';
}

class KiotVietApiClient {
  final FirebaseFunctions _functions =
      FirebaseFunctions.instanceFor(region: 'asia-southeast1');

  /// A generic method to call the KiotViet proxy Firebase Function.
  Future<Map<String, dynamic>> _callProxy({
    required String method,
    required String endpoint,
    Map<String, dynamic>? params,
    Map<String, dynamic>? body,
  }) async {
    try {
      final callable = _functions.httpsCallable('kiotVietProxy');
      final result = await callable.call<Map<String, dynamic>>({
        'method': method,
        'endpoint': endpoint,
        'params': params,
        'body': body,
      });
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      // Log the error for debugging purposes
      debugPrint('Firebase Functions Error: ${e.code} - ${e.message}');
      // Wrap it in a custom exception to be handled by the service layer
      throw KiotVietApiClientException(
        code: e.code,
        message: e.message ?? 'An unknown Firebase error occurred.',
        details: e.details,
      );
    } catch (e) {
      // Handle other generic errors
      debugPrint('An unexpected error occurred: $e');
      // Wrap it in a custom exception
      throw KiotVietApiClientException(
        code: 'unknown',
        message: 'An unexpected error occurred: $e',
      );
    }
  }

  /// Makes a GET request to the KiotViet API.
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? params,
  }) =>
      _callProxy(method: 'GET', endpoint: endpoint, params: params);

  /// Makes a POST request to the KiotViet API.
  Future<Map<String, dynamic>> post({
    required String endpoint,
    Map<String, dynamic>? body,
  }) =>
      _callProxy(method: 'POST', endpoint: endpoint, body: body);

  /// Makes a PUT request to the KiotViet API.
  Future<Map<String, dynamic>> put({
    required String endpoint,
    Map<String, dynamic>? body,
  }) =>
      _callProxy(method: 'PUT', endpoint: endpoint, body: body);

  /// Makes a DELETE request to the KiotViet API.
  Future<Map<String, dynamic>> delete({
    required String endpoint,
  }) =>
      _callProxy(method: 'DELETE', endpoint: endpoint);
}