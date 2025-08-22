import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/features/color_palette/presentation/color_palette_screen.dart';
import 'package:flutter_paint_store_app/features/dashboard/presentation/dashboard_screen.dart';
import 'package:flutter_paint_store_app/features/other/presentation/other_screen.dart';
import 'package:flutter_paint_store_app/features/quotes/presentation/quotes_screen.dart';
import 'package:flutter_paint_store_app/features/sales/presentation/sales_screen.dart';

class ResponsiveShell extends StatefulWidget {
  final String userRole;
  const ResponsiveShell({super.key, required this.userRole});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const DashboardScreen(),
    const ColorPaletteScreen(),
    const SalesScreen(),
    const QuotesScreen(),
    const OtherScreen(),
  ];

  List<NavigationRailDestination> get _adminDestinations => const [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: Text('Tổng quan'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.color_lens_outlined),
      selectedIcon: Icon(Icons.color_lens),
      label: Text('Bảng màu'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      selectedIcon: Icon(Icons.shopping_cart),
      label: Text('Bán hàng'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.request_quote_outlined),
      selectedIcon: Icon(Icons.request_quote),
      label: Text('Báo giá'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.admin_panel_settings_outlined),
      selectedIcon: Icon(Icons.admin_panel_settings),
      label: Text('Quản trị'),
    ),
  ];

  List<NavigationRailDestination> get _saleDestinations => const [
    NavigationRailDestination(
      icon: Icon(Icons.dashboard_outlined),
      selectedIcon: Icon(Icons.dashboard),
      label: Text('Tổng quan'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.color_lens_outlined),
      selectedIcon: Icon(Icons.color_lens),
      label: Text('Bảng màu'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.shopping_cart_outlined),
      selectedIcon: Icon(Icons.shopping_cart),
      label: Text('Bán hàng'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.request_quote_outlined),
      selectedIcon: Icon(Icons.request_quote),
      label: Text('Báo giá'),
    ),
    NavigationRailDestination(
      icon: Icon(Icons.more_horiz_outlined),
      selectedIcon: Icon(Icons.more_horiz),
      label: Text('Khác'),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final destinations = widget.userRole == 'admin'
        ? _adminDestinations
        : _saleDestinations;
    final bottomNavItems = destinations
        .map(
          (dest) => NavigationDestination(
            icon: dest.icon,
            selectedIcon: dest.selectedIcon,
            label: (dest.label as Text).data!,
          ),
        )
        .toList();

    return LayoutBuilder(
      builder: (context, constraints) {
        // Giao diện cho Tablet và Desktop
        if (constraints.maxWidth > 600) {
          return Scaffold(
            body: Row(
              children: [
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) =>
                      setState(() => _selectedIndex = index),
                  labelType: NavigationRailLabelType.all,
                  destinations: destinations,
                  leading: Column(
                    children: [
                      const SizedBox(height: 20),
                      Icon(
                        Icons.color_lens,
                        size: 32,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
                const VerticalDivider(thickness: 1, width: 1),
                Expanded(child: _screens[_selectedIndex]),
              ],
            ),
          );
        }
        // Giao diện cho Mobile
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: NavigationBar(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) =>
                setState(() => _selectedIndex = index),
            destinations: bottomNavItems,
          ),
        );
      },
    );
  }
}
