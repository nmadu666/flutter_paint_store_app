import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/features/sales/application/price_book_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/models/price_book.dart';

class PriceListSelector extends ConsumerWidget {
  const PriceListSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the async provider for price books
    final priceBooksAsync = ref.watch(priceBooksProvider);
    // Watch the currently selected price list name from the active quote
    final selectedPriceListName = ref.watch(activeSelectedPriceListProvider);

    // Use .when to handle loading, error, and data states gracefully.
    return priceBooksAsync.when(
      loading: () => _buildChild(context, 'Đang tải...',
          const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))),
      error: (err, stack) => _buildChild(
          context, 'Lỗi', const Icon(Icons.error_outline, size: 18, color: Colors.red)),
      data: (priceBooks) {
        final validPriceBooks =
            priceBooks.where((pb) => pb.name != null && pb.name!.isNotEmpty).toList();

        // If there are no valid price books, show a disabled state.
        if (validPriceBooks.isEmpty) {
          return _buildChild(context, 'Không có bảng giá', null, enabled: false);
        }

        // Determine the text to display on the button.
        final displayPriceList =
            selectedPriceListName ?? validPriceBooks.first.name ?? 'Bảng giá';

        return PopupMenuButton<String>(
          onSelected: (String priceListName) {
            // When a new price list is selected, update the active quote.
            ref
                .read(quoteTabsProvider.notifier)
                .updatePriceListForActiveQuote(priceListName);
          },
          itemBuilder: (BuildContext context) {
            // Map the list of valid PriceBook objects to PopupMenuItems.
            return validPriceBooks.map((PriceBook priceBook) {
              return PopupMenuItem<String>(
                value: priceBook.name!, // Safe to use ! due to the filter above
                child: Text(priceBook.name!),
              );
            }).toList();
          },
          // The child of the button shows the currently selected value.
          child: _buildChild(context, displayPriceList,
              const Icon(Icons.arrow_drop_down, size: 18)),
        );
      },
    );
  }

  // Helper widget to build the button's appearance, avoiding code duplication.
  Widget _buildChild(BuildContext context, String text, Widget? trailingIcon,
      {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      decoration: ShapeDecoration(
        shape: const StadiumBorder(),
        color: enabled
            ? Theme.of(context).colorScheme.surfaceContainerHighest
            : Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.sell_outlined, size: 20),
          const SizedBox(width: 8),
          Flexible(
            child: Text(text, overflow: TextOverflow.ellipsis),
          ),
          if (trailingIcon != null) trailingIcon,
        ],
      ),
    );
  }
}
