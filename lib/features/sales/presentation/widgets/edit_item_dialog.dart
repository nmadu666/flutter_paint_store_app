import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';

Future<void> showEditItemDialog(
  BuildContext context,
  WidgetRef ref,
  QuoteItem item,
) async {
  final quantityController = TextEditingController(text: item.quantity.toString());
  final priceController = TextEditingController(text: item.unitPrice.toString());
  final discountController = TextEditingController(text: item.discount.toString());
  final noteController = TextEditingController(text: item.note);
  bool isPercentage = item.discountIsPercentage;

  return showDialog<void>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Chỉnh sửa: ${item.product.name}'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextField(
                    controller: quantityController,
                    decoration: const InputDecoration(labelText: 'Số lượng'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: priceController,
                    decoration: const InputDecoration(labelText: 'Đơn giá (đ)'),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: discountController,
                          decoration: InputDecoration(
                            labelText: isPercentage ? 'Chiết khấu (%)' : 'Giảm giá (đ)',
                          ),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(isPercentage ? '%' : 'đ'),
                      Switch(
                        value: isPercentage,
                        onChanged: (value) {
                          setState(() {
                            isPercentage = value;
                          });
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: noteController,
                    decoration: const InputDecoration(labelText: 'Ghi chú'),
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Hủy'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              FilledButton(
                child: const Text('Lưu'),
                onPressed: () {
                  final updatedItem = item.copyWith(
                    quantity: int.tryParse(quantityController.text) ?? item.quantity,
                    unitPrice: double.tryParse(priceController.text) ?? item.unitPrice,
                    discount: double.tryParse(discountController.text) ?? item.discount,
                    discountIsPercentage: isPercentage,
                    note: noteController.text,
                  );
                  ref.read(quoteTabsProvider.notifier).updateItem(updatedItem);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    },
  );
}
