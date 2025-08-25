import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/dialogs/customer_dialog.dart';

class CustomerSelector extends ConsumerWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
      child: Row(
        children: [
          Expanded(
            child: selectedCustomer == null
                ? _buildCustomerDropdown(ref, customers)
                : _buildSelectedCustomer(context, ref, selectedCustomer),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => const CustomerDialog(),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDropdown(WidgetRef ref, List<Customer> customers) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<Customer>(
        value: null,
        onChanged: (Customer? newValue) {
          if (newValue != null) {
            ref.read(selectedCustomerProvider.notifier).state = newValue;
          }
        },
        items: customers.map<DropdownMenuItem<Customer>>((Customer customer) {
          return DropdownMenuItem<Customer>(
            value: customer,
            child: Text(customer.name),
          );
        }).toList(),
        hint: const Row(
          children: [
            Icon(Icons.person_outline, size: 20),
            SizedBox(width: 8),
            Text("Chọn khách hàng"),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedCustomer(
      BuildContext context, WidgetRef ref, Customer customer) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => CustomerDialog(customer: customer),
        );
      },
      child: Row(
        children: [
          const Icon(Icons.person, size: 20),
          const SizedBox(width: 8),
          Expanded(child: Text(customer.name, overflow: TextOverflow.ellipsis)),
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: () {
              ref.read(selectedCustomerProvider.notifier).state = null;
            },
            tooltip: 'Bỏ chọn',
          )
        ],
      ),
    );
  }
}
