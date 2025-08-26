import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';

class SalesTabBar extends ConsumerWidget {
  const SalesTabBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The parent widget (SalesScreen) uses .when() to ensure this widget
    // is only built when the state is AsyncData.
    final tabsState = ref.watch(quoteTabsProvider).value!;
    final notifier = ref.read(quoteTabsProvider.notifier);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        children: [
          Expanded(
            child: TabBar(
              isScrollable: true,
              tabs: List.generate(tabsState.quotes.length, (index) {
                return Tab(
                  child: Row(
                    children: [
                      Text(tabsState.quotes[index].name),
                      if (tabsState.quotes.length > 1)
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => notifier.closeTab(index),
                        ),
                    ],
                  ),
                );
              }),
              onTap: notifier.setActiveTab,
            ),
          ),
          if (tabsState.quotes.length < 20)
            IconButton(
              icon: const Icon(Icons.add),
              onPressed: notifier.addTab,
            ),
        ],
      ),
    );
  }
}
