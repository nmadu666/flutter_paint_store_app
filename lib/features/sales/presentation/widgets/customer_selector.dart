import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/models/customer.dart';
import 'package:flutter_paint_store_app/features/sales/application/sales_state.dart';
import 'customer_dialog.dart';

class CustomerSelector extends ConsumerWidget {
  const CustomerSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customers = ref.watch(customersProvider);
    final selectedCustomer = ref.watch(selectedCustomerProvider);

    return Autocomplete<Customer>(
      // Sử dụng Key để đảm bảo Autocomplete được xây dựng lại với giá trị
      // ban đầu mới khi khách hàng được chọn thay đổi từ bên ngoài.
      // Đây là cách làm chuẩn trong Flutter để reset state của một widget.
      key: ValueKey(selectedCustomer),
      initialValue: TextEditingValue(
        text: selectedCustomer?.name ?? '',
        // Di chuyển con trỏ đến cuối khi có giá trị
        selection: TextSelection.fromPosition(
          TextPosition(offset: selectedCustomer?.name.length ?? 0),
        ),
      ),
      optionsBuilder: (TextEditingValue textEditingValue) {
        // LƯU Ý: Việc sử dụng optionsBuilder bất đồng bộ (async) có thể gây ra
        // lỗi trên các phiên bản Flutter cũ. Logic được giữ ở dạng đồng bộ
        // để tránh race condition khi trường văn bản mất focus trong lúc
        // các tùy chọn đang được tải.

        final query = textEditingValue.text.toLowerCase();
        return customers.where((Customer option) {
          // Luôn lọc bỏ "Khách lẻ" khỏi danh sách tùy chọn
          if (option.id == '1') {
            return false;
          }
          // Nếu không có truy vấn, hiển thị tất cả khách hàng khác.
          // Ngược lại, lọc theo tên.
          return query.isEmpty ||
              option.name.toLowerCase().contains(query);
        });
      },
      displayStringForOption: (Customer option) => option.name,
      onSelected: (Customer selection) {
        ref.read(quoteProvider.notifier).selectCustomer(selection);
        FocusScope.of(context).unfocus();
      },
      fieldViewBuilder: (BuildContext context,
          TextEditingController fieldTextEditingController,
          FocusNode fieldFocusNode,
          VoidCallback onFieldSubmitted) {
        return TextFormField(
          controller: fieldTextEditingController,
          focusNode: fieldFocusNode,
          // Khi nhấn vào trường text, nếu là khách lẻ thì xóa để tìm kiếm
          onTap: () {
            if (selectedCustomer?.id == '1') {
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
                      ref.read(quoteProvider.notifier).selectCustomer(retailCustomer);
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
