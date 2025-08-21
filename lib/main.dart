// main.dart
// Cần thêm các gói thư viện vào file pubspec.yaml:
// dependencies:
//   flutter:
//     sdk: flutter
//   firebase_core: ^2.27.0
//   firebase_auth: ^4.17.8
//   cloud_firestore: ^4.15.8
//   flutter_riverpod: ^2.5.1 # Hoặc provider, getx... tùy sở thích
//   go_router: ^13.2.0 # Để quản lý điều hướng
//   google_fonts: ^6.2.1
//   flutter_staggered_grid_view: ^0.7.0 # Hiển thị bảng màu đẹp hơn
//   fl_chart: ^0.67.0 # Thư viện vẽ biểu đồ

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'firebase_options.dart'; // File này được tạo tự động bởi FlutterFire CLI

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Khởi tạo Firebase
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

//============================================================
// 1. App Core (main.dart)
//============================================================
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Paint Store App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.beVietnamProTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.cyan,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
        textTheme: GoogleFonts.beVietnamProTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: Colors.white,
            displayColor: Colors.white,
          ),
        ),
      ),
      themeMode: ThemeMode.system,
      home: const AuthWrapper(), // Bắt đầu với việc kiểm tra đăng nhập
    );
  }
}

//============================================================
// 2. Authentication (features/auth/)
//============================================================
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  Future<String> _getUserRole(String uid) async {
    try {
      final userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .get();
      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.containsKey('role')) {
        return userDoc.data()!['role'] as String;
      }
      return 'sale';
    } catch (e) {
      debugPrint('Lỗi khi lấy role người dùng: $e');
      return 'sale';
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (authSnapshot.hasData) {
          final user = authSnapshot.data!;
          return FutureBuilder<String>(
            future: _getUserRole(user.uid),
            builder: (context, roleSnapshot) {
              if (roleSnapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (roleSnapshot.hasError) {
                return const Scaffold(
                  body: Center(
                    child: Text('Đã xảy ra lỗi khi tải dữ liệu người dùng.'),
                  ),
                );
              }
              if (roleSnapshot.hasData) {
                return ResponsiveShell(userRole: roleSnapshot.data!);
              }
              return const LoginScreen();
            },
          );
        }
        return const LoginScreen();
      },
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'invalid-credential') {
        _errorMessage = 'Email hoặc mật khẩu không chính xác.';
      } else {
        _errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại sau.';
      }
    } catch (e) {
      _errorMessage = 'Đã xảy ra lỗi không xác định.';
    }
    if (mounted)
      setState(() {
        _isLoading = false;
      });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.color_lens,
                    size: 64,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Chào mừng đến với Paint Store',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Vui lòng đăng nhập để tiếp tục',
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 32),
                  TextFormField(
                    controller: _emailController,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (v) =>
                        (v == null || v.isEmpty || !v.contains('@'))
                        ? 'Vui lòng nhập email hợp lệ'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Mật khẩu',
                      prefixIcon: Icon(Icons.lock_outline),
                      border: OutlineInputBorder(),
                    ),
                    obscureText: true,
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Vui lòng nhập mật khẩu'
                        : null,
                  ),
                  const SizedBox(height: 24),
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  _isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _login,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Đăng nhập'),
                        ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

//============================================================
// 3. App Shell (features/shell/)
//============================================================
class ResponsiveShell extends StatefulWidget {
  final String userRole;
  const ResponsiveShell({super.key, required this.userRole});

  @override
  State<ResponsiveShell> createState() => _ResponsiveShellState();
}

class _ResponsiveShellState extends State<ResponsiveShell> {
  int _selectedIndex = 0;

  // Cập nhật danh sách màn hình để trỏ đến SalesScreen mới
  final List<Widget> _screens = [
    const DashboardScreen(),
    const ColorPaletteScreen(),
    const SalesScreen(), // <-- Màn hình mới
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

//============================================================
// 4. Screens (features/**/)
//============================================================

// --- Màn hình Bán hàng (SalesScreen) ---
class SalesScreen extends StatefulWidget {
  const SalesScreen({super.key});

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  final List<QuoteItem> _cartItems = [];
  final List<Product> _allProducts = List.generate(
    20,
    (i) =>
        Product(id: '$i', name: 'Sản phẩm sơn $i', code: 'SP$i', pricing: []),
  );

  // State cho chức năng tìm kiếm
  late List<Product> _filteredProducts;
  final _searchController = TextEditingController();

  // Trạng thái cho giao diện mobile
  bool _isShowingCartMobile = false;

  @override
  void initState() {
    super.initState();
    _filteredProducts = _allProducts;
    _searchController.addListener(() {
      _filterProducts(_searchController.text);
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Hàm lọc danh sách sản phẩm
  void _filterProducts(String query) {
    List<Product> searchResult = _allProducts;
    if (query.isNotEmpty) {
      searchResult = _allProducts
          .where(
            (product) =>
                product.name.toLowerCase().contains(query.toLowerCase()) ||
                product.code.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    }
    setState(() {
      _filteredProducts = searchResult;
    });
  }

  // Hàm thêm sản phẩm vào giỏ hàng
  void _addToCart(Product product) {
    setState(() {
      // Giả lập logic thêm sản phẩm
      _cartItems.add(
        QuoteItem(
          productName: product.name,
          colorName: "Màu mặc định",
          hexCode: "FFFFFF",
          base: "P",
          quantity: 1,
          unitPrice: 150000,
          totalPrice: 150000,
          sku: "${product.code}_P_FFFFFF",
        ),
      );
    });

    // Hiển thị thông báo
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${product.name} đã được thêm vào giỏ hàng.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 800) {
          return _buildMobileLayout();
        } else {
          return _buildDesktopLayout();
        }
      },
    );
  }

  // Giao diện cho Mobile
  Widget _buildMobileLayout() {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isShowingCartMobile ? 'Giỏ hàng' : 'Bán hàng'),
        leading: _isShowingCartMobile
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => setState(() => _isShowingCartMobile = false),
              )
            : null,
        bottom: _isShowingCartMobile
            ? null
            : PreferredSize(
                preferredSize: const Size.fromHeight(kToolbarHeight),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 8.0,
                  ),
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ),
      ),
      body: _isShowingCartMobile
          ? _buildMobileCartView()
          : _buildMobileProductList(),
      floatingActionButton: !_isShowingCartMobile && _cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => setState(() => _isShowingCartMobile = true),
              label: Text('Xem giỏ hàng (${_cartItems.length})'),
              icon: const Icon(Icons.shopping_cart_outlined),
            )
          : null,
    );
  }

  // Widget danh sách sản phẩm cho mobile
  Widget _buildMobileProductList() {
    return ListView.builder(
      itemCount: _filteredProducts.length,
      itemBuilder: (context, index) {
        final product = _filteredProducts[index];
        return ListTile(
          title: Text(product.name),
          subtitle: Text('Code: ${product.code}'),
          trailing: IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            onPressed: () {
              _addToCart(product);
              // Tự động chuyển qua giỏ hàng sau khi thêm
              setState(() => _isShowingCartMobile = true);
            },
          ),
        );
      },
    );
  }

  // Widget giỏ hàng cho mobile
  Widget _buildMobileCartView() {
    if (_cartItems.isEmpty) {
      return const Center(child: Text('Giỏ hàng của bạn đang trống.'));
    }
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _cartItems.length,
            itemBuilder: (context, index) {
              final item = _cartItems[index];
              return ListTile(
                title: Text(item.productName),
                subtitle: Text('Số lượng: ${item.quantity}'),
                trailing: Text('${item.totalPrice.toStringAsFixed(0)}đ'),
              );
            },
          ),
        ),
        // Phần thanh toán
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildSummaryRow('Tổng cộng', '4.100.000đ', isTotal: true),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () {},
                child: const Text('Tiến hành thanh toán'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // Giao diện cho Desktop/Tablet
  Widget _buildDesktopLayout() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tạo Báo Giá / Đơn Hàng'),
        actions: [
          SizedBox(
            width: 300,
            child: Autocomplete<Product>(
              optionsBuilder: (TextEditingValue textEditingValue) {
                if (textEditingValue.text.isEmpty) {
                  return const Iterable<Product>.empty();
                }
                return _allProducts.where((product) {
                  return product.name.toLowerCase().contains(
                    textEditingValue.text.toLowerCase(),
                  );
                });
              },
              displayStringForOption: (Product option) => option.name,
              onSelected: (Product selection) {
                _addToCart(selection);
              },
              fieldViewBuilder:
                  (context, controller, focusNode, onFieldSubmitted) {
                    return TextField(
                      controller: controller,
                      focusNode: focusNode,
                      decoration: InputDecoration(
                        hintText: 'Tìm và thêm sản phẩm...',
                        prefixIcon: const Icon(Icons.search),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                        ),
                      ),
                      onSubmitted: (_) {
                        // Xóa text sau khi submit để có thể tìm kiếm tiếp
                        controller.clear();
                      },
                    );
                  },
            ),
          ),
          const SizedBox(width: 16),
          FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.person_add_alt_1),
            label: const Text('Chọn khách hàng'),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: _cartItems.isEmpty
                ? const Center(
                    child: Text('Chưa có sản phẩm nào trong giỏ hàng.'),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _cartItems.length,
                    itemBuilder: (context, index) {
                      final item = _cartItems[index];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          title: Text(item.productName),
                          subtitle: Text(
                            'Màu: ${item.colorName} - Base: ${item.base}',
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${item.quantity} x ${item.unitPrice.toStringAsFixed(0)}đ',
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () {
                                  setState(() => _cartItems.removeAt(index));
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              color: Theme.of(
                context,
              ).colorScheme.surfaceVariant.withOpacity(0.3),
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Tổng Quan Thanh Toán',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 24),
                  _buildSummaryRow('Tiền hàng', '4.250.000đ'),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Giảm giá', '- 150.000đ'),
                  const SizedBox(height: 16),
                  _buildSummaryRow('Thu khác', '0đ'),
                  const Divider(height: 32),
                  _buildSummaryRow(
                    'Cần thanh toán',
                    '4.100.000đ',
                    isTotal: true,
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.print_outlined),
                    label: const Text('In & Lưu Báo Giá'),
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {},
                    child: const Text('Tạo Đơn Hàng'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String title, String value, {bool isTotal = false}) {
    final style = isTotal
        ? Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyLarge;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: style),
        Text(value, style: style),
      ],
    );
  }
}

// --- Các màn hình khác (Placeholder) ---
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tổng quan')),
      body: const Center(child: Text('Nội dung trang Tổng quan')),
    );
  }
}

class ColorPaletteScreen extends StatelessWidget {
  const ColorPaletteScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bảng màu')),
      body: const Center(child: Text('Nội dung trang Bảng màu')),
    );
  }
}

class QuotesScreen extends StatelessWidget {
  const QuotesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Danh sách Báo giá')),
      body: const Center(child: Text('Nội dung trang Báo giá')),
    );
  }
}

class OtherScreen extends StatelessWidget {
  const OtherScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Khác / Quản trị')),
      body: Center(
        child: ElevatedButton.icon(
          icon: const Icon(Icons.logout),
          label: const Text('Đăng xuất'),
          onPressed: () async {
            await FirebaseAuth.instance.signOut();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
        ),
      ),
    );
  }
}

//============================================================
// 5. Data Models (models/)
//============================================================
class Product {
  final String id;
  final String name;
  final String code;
  final List<ProductPricing> pricing;
  Product({
    required this.id,
    required this.name,
    required this.code,
    required this.pricing,
  });
}

class ProductPricing {
  final String base;
  final String priceGroup;
  final double cost;
  ProductPricing({
    required this.base,
    required this.priceGroup,
    required this.cost,
  });
}

class PaintColor {
  final String id;
  final String name;
  final String hexCode;
  final String priceGroup;
  PaintColor({
    required this.id,
    required this.name,
    required this.hexCode,
    required this.priceGroup,
  });
}

class Customer {
  final String id;
  final String name;
  final String phone;
  final String address;
  Customer({
    required this.id,
    required this.name,
    required this.phone,
    required this.address,
  });
}

class Quote {
  final String id;
  final String customerId;
  final List<QuoteItem> items;
  final DateTime createdAt;
  final String createdBy;
  final double totalPrice;
  Quote({
    required this.id,
    required this.customerId,
    required this.items,
    required this.createdAt,
    required this.createdBy,
    required this.totalPrice,
  });
}

class QuoteItem {
  final String productName;
  final String colorName;
  final String hexCode;
  final String base;
  final double quantity;
  final double unitPrice;
  final double totalPrice;
  final String sku;
  QuoteItem({
    required this.productName,
    required this.colorName,
    required this.hexCode,
    required this.base,
    required this.quantity,
    required this.unitPrice,
    required this.totalPrice,
    required this.sku,
  });
}
