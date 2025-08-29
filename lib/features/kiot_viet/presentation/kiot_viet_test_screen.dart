import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/kiot_viet/application/kiot_viet_service.dart';

// Helper function to format JSON in a separate isolate
Future<String> _formatJson(dynamic jsonData) async {
  return await compute((dynamic data) {
    return const JsonEncoder.withIndent('  ').convert(data);
  }, jsonData);
}

class KiotVietTestScreen extends ConsumerStatefulWidget {
  const KiotVietTestScreen({super.key});

  @override
  ConsumerState<KiotVietTestScreen> createState() => _KiotVietTestScreenState();
}

class _KiotVietTestScreenState extends ConsumerState<KiotVietTestScreen> {
  final _endpointController = TextEditingController(text: 'categories');
  final _paramsController = TextEditingController();
  final _bodyController = TextEditingController();

  dynamic _response;
  bool _isLoading = false;
  bool _fetchAll = false;
  String _progressMessage = '';

  Future<void> _makeRequest(String method) async {
    setState(() {
      _isLoading = true;
      _response = null;
      _progressMessage = 'Requesting...';
    });

    final kiotVietService = ref.read(kiotVietServiceProvider);
    final endpoint = _endpointController.text;
    final params = _paramsController.text.isNotEmpty
        ? jsonDecode(_paramsController.text)
        : null;
    final body = _bodyController.text.isNotEmpty
        ? jsonDecode(_bodyController.text)
        : null;

    try {
      dynamic result;
      switch (method) {
        case 'GET':
          if (_fetchAll) {
            result = await kiotVietService.getAll(
              endpoint,
              params: params,
              onProgress: (fetched, total) {
                setState(() {
                  _progressMessage = 'Fetched $fetched of $total items...';
                });
              },
            );
          } else {
            result = await kiotVietService.get(endpoint, params: params);
          }
          break;
        case 'POST':
          result = await kiotVietService.post(endpoint, body: body);
          break;
        case 'PUT':
          result = await kiotVietService.put(endpoint, body: body);
          break;
        case 'DELETE':
          result = await kiotVietService.delete(endpoint);
          break;
      }
      setState(() {
        _response = result;
      });
    } catch (e) {
      setState(() {
        _response = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
        _progressMessage = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('KiotViet API Test'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildRequestForm(),
          ),
          const Divider(height: 1),
          Expanded(child: _buildResponseArea()),
        ],
      ),
    );
  }

  Widget _buildRequestForm() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _endpointController,
            decoration: const InputDecoration(
              labelText: 'Endpoint (e.g., categories, products)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _paramsController,
            decoration: const InputDecoration(
              labelText: 'GET Params (JSON format)',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _bodyController,
            decoration: const InputDecoration(
              labelText: 'POST/PUT Body (JSON format)',
              border: OutlineInputBorder(),
            ),
            maxLines: 5,
          ),
          const SizedBox(height: 16),
          CheckboxListTile(
            title: const Text('Fetch all results (for GET requests)'),
            value: _fetchAll,
            onChanged: (bool? value) {
              setState(() {
                _fetchAll = value ?? false;
              });
            },
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8.0,
            runSpacing: 4.0,
            children: [
              ElevatedButton(onPressed: () => _makeRequest('GET'), child: const Text('GET')),
              ElevatedButton(onPressed: () => _makeRequest('POST'), child: const Text('POST')),
              ElevatedButton(onPressed: () => _makeRequest('PUT'), child: const Text('PUT')),
              ElevatedButton(onPressed: () => _makeRequest('DELETE'), child: const Text('DELETE')),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResponseArea() {
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 8),
            Text(_progressMessage),
          ],
        ),
      );
    }

    if (_response == null) {
      return const Center(child: Text('No response yet.'));
    }

    if (_response is String) {
      return SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: SelectableText(_response as String),
      );
    }

    if (_response is List) {
      final items = _response as List;
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Showing ${items.length} items', style: Theme.of(context).textTheme.titleMedium),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                final item = items[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ExpansionTile(
                    title: Text('Item ${index + 1}'),
                    children: [
                      FutureBuilder<String>(
                        future: _formatJson(item),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return Text('Error formatting JSON: ${snapshot.error}');
                          }
                          return Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: SelectableText(snapshot.data ?? ''),
                          );
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      );
    }

    // For single map objects
    return FutureBuilder<String>(
      future: _formatJson(_response),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error formatting JSON: ${snapshot.error}');
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: SelectableText(snapshot.data ?? ''),
        );
      },
    );
  }
}
