import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> batchWrite(
    List<Map<String, dynamic>> data,
    String collectionPath,
    {void Function(int, int)? onProgress}
  ) async {
    if (data.isEmpty) {
      debugPrint('FirebaseService: Data is empty, skipping write.');
      return;
    }

    debugPrint('FirebaseService: Starting batch write for $collectionPath with ${data.length} items.');
    final collection = _firestore.collection(collectionPath);
    var batch = _firestore.batch();
    int counter = 0;
    int totalWritten = 0;

    for (int i = 0; i < data.length; i++) {
      final item = data[i];
      final docId = item['id']?.toString();

      if (docId != null && docId.isNotEmpty) {
        batch.set(collection.doc(docId), item);
        counter++;
      } else {
        debugPrint('FirebaseService: Skipping item at index $i in $collectionPath because it has no id.');
        debugPrint('FirebaseService: Item data: $item');
      }

      // Commit batch every 500 operations or on the last item
      if (counter == 500 || i == data.length - 1) {
        if (counter > 0) {
          debugPrint('FirebaseService: Committing batch of $counter items to $collectionPath.');
          await batch.commit();
          totalWritten += counter;
          onProgress?.call(totalWritten, data.length);
          debugPrint('FirebaseService: Committed $totalWritten of ${data.length} items.');
          batch = _firestore.batch();
          counter = 0;
        }
      }
    }
    debugPrint('FirebaseService: Batch write finished for $collectionPath.');
  }
}
