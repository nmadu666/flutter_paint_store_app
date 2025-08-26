import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_paint_store_app/features/sales/application/quote_tabs_provider.dart';
import 'package:flutter_paint_store_app/features/sales/application/ui_state_providers.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/cart/reorderable_desktop_cart_table.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/payment_summary.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_app_bar.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/product_list.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/cart/mobile_cart_item.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_header.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/widgets/sales_tab_bar.dart';

import 'widgets/product_search_field.dart';

class SalesScreen extends ConsumerWidget {
  const SalesScreen({super.key});

  Future<void> _handlePrintQuote(BuildContext context, WidgetRef ref) async {
    final quote = ref.read(quoteTabsProvider).value?.activeQuote;
    if (quote == null || quote.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Báo giá trống. Vui lòng thêm sản phẩm.')),
      );
      return;
    }
    // TODO: Implement PDF generation and printing
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 900;
        if (isMobile) {
          return _buildMobileLayout(context, ref);
        } else {
          return _buildDesktopLayout(context, ref);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context, WidgetRef ref) {
    final isShowingCart = ref.watch(isShowingCartMobileProvider);
    return Scaffold(
      appBar: const SalesAppBar(isMobile: true),
      body: isShowingCart
          ? MobileCartView(onPrint: () => _handlePrintQuote(context, ref))
          : const ProductList(),
    );
  }

  Widget _buildDesktopLayout(BuildContext context, WidgetRef ref) {
    final tabsAsyncState = ref.watch(quoteTabsProvider);

    return tabsAsyncState.when(
      loading: () => const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (err, stack) => Scaffold(body: Center(child: Text('Lỗi: $err'))),
      data: (tabsState) {
        return DefaultTabController(
          length: tabsState.quotes.length,
          initialIndex: tabsState.activeTabIndex,
          child: Builder(builder: (context) {
            final tabController = DefaultTabController.of(context);
            tabController.addListener(() {
              if (!tabController.indexIsChanging) {
                ref.read(quoteTabsProvider.notifier).setActiveTab(tabController.index);
              }
            });

            return Scaffold(
              appBar: const SalesAppBar(isMobile: false),
              body: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Expanded(child: ProductSearchField()),
                              const SizedBox(width: 16),
                              Expanded(
                                flex: 2,
                                child: const SalesTabBar(),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: TabBarView(
                            physics: const NeverScrollableScrollPhysics(),
                            children: tabsState.quotes.map((quote) {
                              return ReorderableDesktopCartTable(
                                key: ValueKey(quote.id),
                                items: quote.items,
                                onReorder: (oldIndex, newIndex) {
                                  ref
                                      .read(quoteTabsProvider.notifier)
                                      .reorderItem(oldIndex, newIndex);
                                },
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SalesHeader(),
                          const SizedBox(height: 24),
                          Expanded(
                            child: PaymentSummary(
                                onPrint: () => _handlePrintQuote(context, ref)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}

class MobileCartView extends ConsumerWidget {
  final VoidCallback onPrint;

  const MobileCartView({super.key, required this.onPrint});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabsAsyncState = ref.watch(quoteTabsProvider);

    return tabsAsyncState.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, stack) => Center(child: Text('Lỗi: $err')),
      data: (tabsState) {
        final quote = tabsState.activeQuote;
        if (quote == null || quote.items.isEmpty) {
          return const Center(
            child: Text('Báo giá của bạn đang trống.'),
          );
        }
        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: quote.items.length,
                itemBuilder: (context, index) {
                  return MobileCartItem(item: quote.items[index]);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PaymentSummary(onPrint: onPrint),
            ),
          ],
        );
      },
    );
  }
}
