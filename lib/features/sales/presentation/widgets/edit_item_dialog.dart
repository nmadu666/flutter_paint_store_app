import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/quote.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';

Future<void> showEditItemDialog(
  BuildContext context,
  WidgetRef ref,
  QuoteItem item,
) async {
  final quantityController = TextEditingController(text: item.quantity.toString());
  final priceController = TextEditingController(text: item.unitPrice.toStringAsFixed(0));
  final discountController = TextEditingController(text: item.discountValue.toStringAsFixed(0));
  final noteController = TextEditingController(text: item.note);
  bool isPercentage = item.isDiscountPercentage;

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
                  final notifier = ref.read(quoteProvider.notifier);
                  final newQuantity = int.tryParse(quantityController.text) ?? item.quantity;
                  final newPrice = double.tryParse(priceController.text) ?? item.unitPrice;
                  final newDiscount = double.tryParse(discountController.text) ?? item.discountValue;
                  final newNote = noteController.text;

                  notifier.updateQuantity(item.id, newQuantity);
                  notifier.updateUnitPrice(item.id, newPrice);
                  notifier.applyDiscount(item.id, newDiscount, isPercentage);
                  notifier.updateNote(item.id, newNote);

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