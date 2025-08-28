import 'package:cloud_functions/cloud_functions.dart';

class KiotVietApiClient {
  final FirebaseFunctions _functions = FirebaseFunctions.instanceFor(region: 'us-central1'); // TODO: Use your functions region

  /// Fetches data from the KiotViet API via a Firebase Functions proxy.
  ///
  /// The [endpoint] is the KiotViet API endpoint (e.g., 'branches').
  /// The [params] are the query parameters for the API call.
  Future<Map<String, dynamic>> get({
    required String endpoint,
    Map<String, dynamic>? params,
  }) async {
    try {
      final callable = _functions.httpsCallable('kiotVietGetProxy');
      final result = await callable.call<Map<String, dynamic>>({
        'endpoint': endpoint,
        'params': params,
      });
      return result.data;
    } on FirebaseFunctionsException catch (e) {
      // Handle Firebase-specific errors
      print('Firebase Functions Error: ${e.code} - ${e.message}');
      rethrow;
    } catch (e) {
      // Handle generic errors
      print('An unexpected error occurred: $e');
      rethrow;
    }
  }
}

