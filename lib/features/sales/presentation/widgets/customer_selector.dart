import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/features/sales/application/customer_providers.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'customer_dialog.dart';

class CustomerSelector extends ConsumerWidget {
  const CustomerSelector({super.key});

  void _onCustomerSelected(WidgetRef ref, BuildContext context, Customer selection) {
    ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(selection);
    FocusScope.of(context).unfocus();
  }

  void _clearSelection(WidgetRef ref) {
    final retailCustomer = ref.read(retailCustomerProvider);
    ref.read(quoteTabsProvider.notifier).updateCustomerForActiveQuote(retailCustomer);
    // Unfocusing is handled by the Autocomplete widget implicitly
  }

  void _editCustomer(BuildContext context, Customer customer) {
    showDialog(
      context: context,
      builder: (context) => CustomerDialog(customer: customer),
    );
  }

  void _addNewCustomer(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const CustomerDialog(), // New customer mode
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    final retailCustomer = ref.watch(retailCustomerProvider);
    final selectedCustomer = ref.watch(activeSelectedCustomerProvider);

    return Autocomplete<Customer>(
      key: ValueKey(selectedCustomer), // Ensures the field rebuilds when customer changes
      initialValue: TextEditingValue(text: selectedCustomer?.name ?? ''),
      optionsBuilder: (TextEditingValue textEditingValue) {
        // First, get a list of customers that are actually selectable (not the default retail one)
        final selectableCustomers = customers.where((c) => c.id != retailCustomer.id);

        final query = textEditingValue.text.toLowerCase();
        if (query.isEmpty) {
          return selectableCustomers;
        }
        // Then, filter the selectable list based on the query
        return selectableCustomers.where((c) => c.name.toLowerCase().contains(query));
      },
      displayStringForOption: (Customer option) => option.name,
      onSelected: (Customer selection) => _onCustomerSelected(ref, context, selection),
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return _buildFieldView(ref, context, controller, focusNode, selectedCustomer);
      },
      optionsViewBuilder: (context, onSelected, options) {
        return _buildOptionsView(context, onSelected, options);
      },
    );
  }

  Widget _buildFieldView(
    WidgetRef ref,
    BuildContext context,
    TextEditingController controller,
    FocusNode focusNode,
    Customer? selectedCustomer,
  ) {
    final retailCustomer = ref.read(retailCustomerProvider);

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onTap: () {
        // Clear the text field when the user taps to search, if it's the retail customer
        if (selectedCustomer?.id == retailCustomer.id) {
          controller.clear();
        }
      },
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.person_outline, size: 20),
        hintText: 'Chọn hoặc tạo khách hàng',
        suffixIcon: _buildSuffixIcons(ref, context, selectedCustomer),
        filled: true,
        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSuffixIcons(
    WidgetRef ref,
    BuildContext context,
    Customer? selectedCustomer,
  ) {
    final retailCustomer = ref.read(retailCustomerProvider);
    final isRetailCustomer = selectedCustomer?.id == retailCustomer.id;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (!isRetailCustomer && selectedCustomer != null)
          IconButton(
            tooltip: 'Sửa khách hàng',
            icon: const Icon(Icons.edit_outlined, size: 18),
            onPressed: () => _editCustomer(context, selectedCustomer),
          ),
        if (!isRetailCustomer && selectedCustomer != null)
          IconButton(
            tooltip: 'Xóa lựa chọn',
            icon: const Icon(Icons.clear, size: 18),
            onPressed: () => _clearSelection(ref),
          ),
        if (isRetailCustomer)
          IconButton(
            tooltip: 'Thêm khách hàng mới',
            icon: const Icon(Icons.add, size: 18),
            onPressed: () => _addNewCustomer(context),
          ),
      ],
    );
  }

  Widget _buildOptionsView(
    BuildContext context,
    AutocompleteOnSelected<Customer> onSelected,
    Iterable<Customer> options,
  ) {
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
              return ListTile(
                title: Text(option.name),
                onTap: () => onSelected(option),
              );
            },
          ),
        ),
      ),
    );
  }
}