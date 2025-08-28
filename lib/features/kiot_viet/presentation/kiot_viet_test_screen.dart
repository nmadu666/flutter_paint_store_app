import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';

// State provider to hold the API response or error
final apiResultProvider = StateProvider<AsyncValue<Map<String, dynamic>>>((ref) {
  return const AsyncValue.data({});
});

class KiotVietTestScreen extends ConsumerWidget {
  const KiotVietTestScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final apiResult = ref.watch(apiResultProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('KiotViet API Test'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  // Set loading state
                  ref.read(apiResultProvider.notifier).state = const AsyncValue.loading();
                  try {
                    // Call the service
                    final result = await ref.read(kiotVietServiceProvider).getBranches();
                    // Set data state
                    ref.read(apiResultProvider.notifier).state = AsyncValue.data(result);
                  } catch (e, st) {
                    // Set error state
                    ref.read(apiResultProvider.notifier).state = AsyncValue.error(e, st);
                  }
                },
                child: const Text('Test Get Branches API'),
              ),
              const SizedBox(height: 20),
              // Display the result
              apiResult.when(
                data: (data) => Expanded(
                  child: SingleChildScrollView(
                    child: Text(data.toString()),
                  ),
                ),
                loading: () => const CircularProgressIndicator(),
                error: (error, stackTrace) => Expanded(
                  child: SingleChildScrollView(
                    child: Text(
                      'Error:\n$error',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
