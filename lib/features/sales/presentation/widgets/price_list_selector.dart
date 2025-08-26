import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/ui_state_providers.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';

class PriceListSelector extends ConsumerWidget {
  const PriceListSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final priceLists = ref.watch(priceListsProvider);
    final selectedPriceList = ref.watch(activeSelectedPriceListProvider);

    final displayPriceList = selectedPriceList ?? (priceLists.isNotEmpty ? priceLists.first : 'Bảng giá');

    return PopupMenuButton<String>(
      onSelected: (String priceList) {
        ref.read(quoteTabsProvider.notifier).updatePriceListForActiveQuote(priceList);
      },
      itemBuilder: (BuildContext context) {
        return priceLists.map((String priceList) {
          return PopupMenuItem<String>(
            value: priceList,
            child: Text(priceList),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: ShapeDecoration(
          shape: const StadiumBorder(),
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sell_outlined, size: 20),
            const SizedBox(width: 8),
            Flexible(
              child: Text(displayPriceList, overflow: TextOverflow.ellipsis),
            ),
            const Icon(Icons.arrow_drop_down, size: 18),
          ],
        ),
      ),
    );
  }
}
