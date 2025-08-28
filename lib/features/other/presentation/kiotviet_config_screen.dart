import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/kiotviet_config.dart';

final kiotvietConfigProvider = StreamProvider<KiotvietConfig?>((ref) {
  final firestore = FirebaseFirestore.instance;
  final docRef = firestore.collection('settings').doc('kiotviet');
  return docRef.snapshots().map((snapshot) {
    if (snapshot.exists) {
      return KiotvietConfig.fromJson(snapshot.data()!);
    }
    return null;
  });
});

class KiotVietConfigScreen extends ConsumerStatefulWidget {
  const KiotVietConfigScreen({super.key});

  @override
  ConsumerState<KiotVietConfigScreen> createState() => _KiotVietConfigScreenState();
}

class _KiotVietConfigScreenState extends ConsumerState<KiotVietConfigScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _retailerController;
  late final TextEditingController _clientIdController;
  late final TextEditingController _clientSecretController;

  @override
  void initState() {
    super.initState();
    _retailerController = TextEditingController();
    _clientIdController = TextEditingController();
    _clientSecretController = TextEditingController();

    // Initialize fields if data already exists
    final initialConfig = ref.read(kiotvietConfigProvider).value;
    if (initialConfig != null) {
      _retailerController.text = initialConfig.retailer;
      _clientIdController.text = initialConfig.clientId;
      _clientSecretController.text = initialConfig.clientSecret;
    }
  }

  @override
  void dispose() {
    _retailerController.dispose();
    _clientIdController.dispose();
    _clientSecretController.dispose();
    super.dispose();
  }

  Future<void> _saveConfig() async {
    if (_formKey.currentState!.validate()) {
      final config = KiotvietConfig(
        retailer: _retailerController.text,
        clientId: _clientIdController.text,
        clientSecret: _clientSecretController.text,
      );

      try {
        final firestore = FirebaseFirestore.instance;
        await firestore
            .collection('settings')
            .doc('kiotviet')
            .set(config.toJson());

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Lưu cấu hình thành công!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi lưu cấu hình: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<KiotvietConfig?>>(kiotvietConfigProvider, (_, state) {
      final config = state.value;
      if (config != null) {
        _retailerController.text = config.retailer;
        _clientIdController.text = config.clientId;
        _clientSecretController.text = config.clientSecret;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cấu hình KiotViet'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _retailerController,
                decoration: const InputDecoration(labelText: 'Retailer'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Retailer';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientIdController,
                decoration: const InputDecoration(labelText: 'Client ID'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Client ID';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _clientSecretController,
                decoration: const InputDecoration(labelText: 'Client Secret'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập Client Secret';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _saveConfig,
                child: const Text('Lưu'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
