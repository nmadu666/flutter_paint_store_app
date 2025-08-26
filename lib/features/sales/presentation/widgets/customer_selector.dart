import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/features/sales/application/customer_providers.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'customer_dialog.dart';

class CustomerSelector extends ConsumerWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    final selectedCustomer = ref.watch(activeSelectedCustomerProvider);

    return Autocomplete<Customer>(
      key: ValueKey(selectedCustomer),
      initialValue: TextEditingValue(
        text: selectedCustomer?.name ?? '',
        selection: TextSelection.fromPosition(
          TextPosition(offset: selectedCustomer?.name.length ?? 0),
        ),
      ),
      optionsBuilder: (TextEditingValue textEditingValue) {
        final query = textEditingValue.text.toLowerCase();
        return customers.where((Customer option) {
          if (option.id == 1) {
            return false;
          }
          return query.isEmpty ||
              option.name.toLowerCase().contains(query);
        });
      },
      displayStringForOption: (Customer option) => option.name,
      onSelected: (Customer selection) {
        ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(selection);
        FocusScope.of(context).unfocus();
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          onTap: () {
            if (selectedCustomer?.id == 1) {
              fieldTextEditingController.clear();
            }
          },
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.person_outline, size: 20),
            hintText: 'Chọn hoặc tạo khách hàng',
            suffixIcon: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (selectedCustomer != null && selectedCustomer.id != 1)
                  IconButton(
                    tooltip: 'Sửa khách hàng',
                    icon: const Icon(Icons.edit_outlined, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) =>
                            CustomerDialog(customer: selectedCustomer),
                      );
                    },
                  ),
                if (selectedCustomer != null && selectedCustomer.id != 1)
                  IconButton(
                    tooltip: 'Xóa lựa chọn',
                    icon: const Icon(Icons.clear, size: 18),
                    onPressed: () {
                      final retailCustomer =
                          customers.firstWhere((c) => c.id == 1);
                      ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(retailCustomer);
                      fieldFocusNode.unfocus();
                    },
                  ),
                if (selectedCustomer?.id == 1)
                  IconButton(
                    tooltip: 'Thêm khách hàng mới',
                    icon: const Icon(Icons.add, size: 18),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => const CustomerDialog(), // Chế độ tạo mới
                      );
                    },
                  ),
              ],
            ),
            filled: true,
            fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(100),
              borderSide: BorderSide.none,
            ),
          ),
        );
      },
      optionsViewBuilder: (BuildContext context,
          AutocompleteOnSelected<Customer> onSelected,
          Iterable<Customer> options) {
        return Align(
          alignment: Alignment.topLeft,
          child: Material(
            elevation: 4.0,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 250, maxWidth: 350),
              child: ListView.builder(
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: options.length,
                itemBuilder: (BuildContext context, int index) {
                  final Customer option = options.elementAt(index);
                  return InkWell(
                    onTap: () => onSelected(option),
                    child: ListTile(title: Text(option.name)),
                  );
                },
              ),
            ),
          ),
        );
      },
    );
  }
}
