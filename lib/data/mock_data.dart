import 'package:flutter/material.dart';
import '../models/order.dart';
import '../models/paint_color.dart';
import '../models/customer.dart';
import '../models/paint_color_price.dart';
import '../models/parent_product.dart';
import '../models/product.dart';

// --- MOCK DATA ---

// ===========================================================================
// 1. Raw Data - The basic building blocks for our mock store
// ===========================================================================

/// All available paint colors in the system.
final List<PaintColor> mockAllColors = [
  PaintColor(
    id: '1',
    name: 'Trắng Sứ',
    code: 'AP01-1',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFF8F8F8),
  ),
  PaintColor(
    id: '2',
    name: 'Vàng Chanh',
    code: 'AP02-3',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFFF59D),
  ),
  PaintColor(
    id: '3',
    name: 'Xanh Bạc Hà',
    code: 'AP03-2',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFFB2DFDB),
  ),
  PaintColor(
    id: '4',
    name: 'Hồng Phấn',
    code: 'AP04-1',
    brand: 'Dulux',
    collection: 'Ambiance 5-in-1',
    color: const Color(0xFFFFCDD2),
  ),
  PaintColor(
    id: '5',
    name: 'Xám Ghi',
    code: 'AP05-4',
    brand: 'Jotun',
    collection: 'Gardex',
    color: const Color(0xFFBDBDBD),
    ncs: 'S2000-N',
  ),
  PaintColor(
    id: '6',
    name: 'Xanh Dương Đậm',
    code: 'AP06-5',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFF1A237E),
    ncs: 'S7020-R90B',
  ),
  PaintColor(
    id: '7',
    name: 'Kem Bơ',
    code: 'AP07-1',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFFF9C4),
  ),
  PaintColor(
    id: '8',
    name: 'Xanh Lá Cây',
    code: 'AP08-3',
    brand: 'Dulux',
    collection: 'EasyClean',
    color: const Color(0xFF4CAF50),
  ),
  PaintColor(
    id: '9',
    name: 'Đỏ Đô',
    code: 'AP09-5',
    brand: 'Jotun',
    collection: 'Gardex',
    color: const Color(0xFFB71C1C),
  ),
  PaintColor(
    id: '10',
    name: 'Tím Lavender',
    code: 'AP10-2',
    brand: 'Dulux',
    collection: 'Ambiance 5-in-1',
    color: const Color(0xFFD1C4E9),
  ),
  PaintColor(
    id: '11',
    name: 'Cam San Hô',
    code: 'AP11-3',
    brand: 'Jotun',
    collection: 'Majestic',
    color: const Color(0xFFFF8A65),
  ),
  PaintColor(
    id: '12',
    name: 'Đen Mịn',
    code: 'AP12-6',
    brand: 'Dulux',
    collection: 'Weathershield',
    color: const Color(0xFF212121),
  ),
  PaintColor(
    id: '13',
    name: 'Grey Event',
    code: '9912',
    brand: 'Jotun',
    collection: 'New Collection',
    color: const Color(0xFF9E9F9D),
    ncs: 'S4000-N',
  ),
];

/// Parent products that require color tinting.
/// These are not sold directly, but their children (bases) are.
final List<ParentProduct> mockParentProducts = [
  ParentProduct(
    id: 'jotun-majestic',
    name: 'Jotun Majestic',
    brand: 'Jotun',
    category: 'Sơn nội thất',
    imageUrl: 'https://picsum.photos/seed/jotun-majestic/400/300',
    tintingFormulaType: 'int_1', // Matches prices in mockColorPrices
    children: [
      Product(
        id: 'JM-A-1',
        name: 'Jotun Majestic - Base A',
        code: 'JMA1',
        unit: 'Lon',
        base: 'A',
        unitValue: 1,
        basePrice: 100000,
      ),
      Product(
        id: 'JM-A-5',
        name: 'Jotun Majestic - Base A',
        code: 'JMA5',
        unit: 'Lon',
        base: 'A',
        unitValue: 5,
        basePrice: 450000,
      ),
      Product(
        id: 'JM-D-1',
        name: 'Jotun Majestic - Base D',
        code: 'JMD1',
        unit: 'Lon',
        base: 'D',
        unitValue: 1,
        basePrice: 95000,
      ),
    ],
  ),
  ParentProduct(
    id: 'dulux-weathershield',
    name: 'Dulux Weathershield',
    brand: 'Dulux',
    category: 'Sơn ngoại thất',
    imageUrl: 'https://picsum.photos/seed/dulux-weathershield/400/300',
    tintingFormulaType: 'ext_1', // Matches prices in mockColorPrices
    children: [
      Product(
        id: 'DW-A-5',
        name: 'Dulux Weathershield - Base A',
        code: 'DWA5',
        unit: 'Thùng',
        base: 'A',
        unitValue: 5,
        basePrice: 600000,
      ),
      Product(
        id: 'DW-B-5',
        name: 'Dulux Weathershield - Base B',
        code: 'DWB5',
        unit: 'Thùng',
        base: 'B',
        unitValue: 5,
        basePrice: 580000,
      ),
    ],
  ),
  ParentProduct(
    id: 'dulux-ambiance',
    name: 'Dulux Ambiance 5-in-1',
    brand: 'Dulux',
    category: 'Sơn nội thất cao cấp',
    imageUrl: 'https://picsum.photos/seed/dulux-ambiance/400/300',
    tintingFormulaType: 'int_2', // Matches prices in mockColorPrices
    children: [
      Product(
        id: 'DA-C-5',
        name: 'Dulux Ambiance 5-in-1 - Base C',
        code: 'DA5C',
        unit: 'Lon',
        base: 'C',
        unitValue: 5,
        basePrice: 750000,
      ),
    ],
  ),
  ParentProduct(
    id: 'essence-easy-clean',
    name: 'Essence dễ lau chùi',
    brand: 'Jotun',
    category: 'Sơn nội thất',
    imageUrl: 'https://picsum.photos/seed/essence-easy-clean/400/300',
    tintingFormulaType: 'int_2',
    children: [
      Product(
        id: 'EEC-A-1',
        name: 'Essence - Base A',
        code: 'EECA1',
        unit: 'Lon',
        base: 'A',
        unitValue: 1,
        basePrice: 120000,
      ),
      Product(
        id: 'EEC-C-1',
        name: 'Essence - Base C',
        code: 'EECC1',
        unit: 'Lon',
        base: 'C',
        unitValue: 1,
        basePrice: 115000,
      ),
      Product(
        id: 'EEC-A-5',
        name: 'Essence - Base A',
        code: 'EECA5',
        unit: 'Lon',
        base: 'A',
        unitValue: 5,
        basePrice: 550000,
      ),
      Product(
        id: 'EEC-C-5',
        name: 'Essence - Base C',
        code: 'EECC5',
        unit: 'Lon',
        base: 'C',
        unitValue: 5,
        basePrice: 540000,
      ),
      Product(
        id: 'EEC-A-18',
        name: 'Essence - Base A',
        code: 'EECA18',
        unit: 'Thùng',
        base: 'A',
        unitValue: 18,
        basePrice: 1800000,
      ),
    ],
  ),
  ParentProduct(
    id: 'jotun-color-fade-resistant',
    name: 'Chống phai màu',
    brand: 'Jotun',
    category: 'Sơn ngoại thất',
    imageUrl: 'https://picsum.photos/seed/jotun-fade-resistant/400/300',
    tintingFormulaType: 'ext_1',
    children: [
      Product(
        id: 'JFR-A-1',
        name: 'Chống phai màu - Base A',
        code: 'JFRA1',
        unit: 'Lon',
        base: 'A',
        unitValue: 1,
        basePrice: 150000,
      ),
      Product(
        id: 'JFR-B-1',
        name: 'Chống phai màu - Base B',
        code: 'JFRB1',
        unit: 'Lon',
        base: 'B',
        unitValue: 1,
        basePrice: 145000,
      ),
      Product(
        id: 'JFR-C-1',
        name: 'Chống phai màu - Base C',
        code: 'JFRC1',
        unit: 'Lon',
        base: 'C',
        unitValue: 1,
        basePrice: 140000,
      ),
      Product(
        id: 'JFR-A-5',
        name: 'Chống phai màu - Base A',
        code: 'JFRA5',
        unit: 'Lon',
        base: 'A',
        unitValue: 5,
        basePrice: 700000,
      ),
      Product(
        id: 'JFR-B-5',
        name: 'Chống phai màu - Base B',
        code: 'JFRB5',
        unit: 'Lon',
        base: 'B',
        unitValue: 5,
        basePrice: 680000,
      ),
      Product(
        id: 'JFR-C-5',
        name: 'Chống phai màu - Base C',
        code: 'JFRC5',
        unit: 'Lon',
        base: 'C',
        unitValue: 5,
        basePrice: 670000,
      ),
      Product(
        id: 'JFR-A-15',
        name: 'Chống phai màu - Base A',
        code: 'JFRA15',
        unit: 'Thùng',
        base: 'A',
        unitValue: 15,
        basePrice: 2000000,
      ),
    ],
  ),
];

/// Standalone products that are sold as-is (no color tinting).
final List<Product> mockStandaloneProducts = [
  Product(
    id: 'JS-Primer-18',
    code: 'VT002',
    name: 'Sơn Lót Chống Kiềm Nội Thất Jotun',
    basePrice: 220000,
    unit: 'Thùng',
    unitValue: 18,
    prices: {
      'Giá bán lẻ': 220000,
      'Giá đại lý cấp 1': 200000,
      'Giá dự án': 190000,
    },
  ),
  Product(
    id: 'DP-Putty-40',
    code: 'VT005',
    name: 'Bột Trét Tường Ngoại Thất Dulux',
    basePrice: 100000,
    unit: 'Bao',
    unitValue: 40,
    prices: {
      'Giá bán lẻ': 100000,
      'Giá đại lý cấp 1': 90000,
      'Giá dự án': 85000,
    },
  ),
];

// ===========================================================================
// 2. Derived Data - Data created by combining or processing the raw data
// ===========================================================================

/// Pricing information for each color, based on the tinting formula and base.
final List<PaintColorPrice> mockColorPrices = [
  // Prices for 'Trắng Sứ' (AP01-1)
  PaintColorPrice.fromPaintColor(
    mockAllColors[0],
    tintingFormulaType: 'int_1',
    base: 'A',
    pricePerMl: 0.05,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[0],
    tintingFormulaType: 'ext_1',
    base: 'A',
    pricePerMl: 0.06,
  ),
  // Prices for 'Vàng Chanh' (AP02-3)
  PaintColorPrice.fromPaintColor(
    mockAllColors[1],
    tintingFormulaType: 'int_1',
    base: 'A',
    pricePerMl: 0.1,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[1],
    tintingFormulaType: 'ext_1',
    base: 'A',
    pricePerMl: 0.12,
  ),
  // Prices for 'Xanh Bạc Hà' (AP03-2)
  PaintColorPrice.fromPaintColor(
    mockAllColors[2],
    tintingFormulaType: 'ext_1',
    base: 'B',
    pricePerMl: 0.15,
  ),
  // Prices for 'Hồng Phấn' (AP04-1)
  PaintColorPrice.fromPaintColor(
    mockAllColors[3],
    tintingFormulaType: 'int_2',
    base: 'C',
    pricePerMl: 0.18,
  ),
  // Prices for 'Xanh Dương Đậm' (AP06-5)
  PaintColorPrice.fromPaintColor(
    mockAllColors[5],
    tintingFormulaType: 'ext_1',
    base: 'D',
    pricePerMl: 0.25,
  ), // Note: No 'D' base in mockParentProducts for ext_1, for testing purposes
  // Prices for 'Đỏ Đô' (AP09-5)
  PaintColorPrice.fromPaintColor(
    mockAllColors[8],
    tintingFormulaType: 'int_1',
    base: 'D',
    pricePerMl: 0.3,
  ),

  // Prices for 'Grey Event' (9912) - Index 12
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'int_1',
    base: 'B',
    pricePerMl: 6,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'int_2',
    base: 'A',
    pricePerMl: 7,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'ext_1',
    base: 'B',
    pricePerMl: 36,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'ext_2',
    base: 'B',
    pricePerMl: 36,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'ext_3',
    base: 'A',
    pricePerMl: 7,
  ),
  PaintColorPrice.fromPaintColor(
    mockAllColors[12],
    tintingFormulaType: 'sd',
    base: 'B',
    pricePerMl: 36,
  ),
];

/// A flat list of all individual products (SKUs) available for sale.
/// This is generated by combining the children of `mockParentProducts`
/// with `mockStandaloneProducts` and adding price lists.
final List<Product> mockSalesProducts = [
  // Products derived from ParentProducts (bases for tinting)
  ...mockParentProducts.expand((parent) {
    return parent.children.map((child) {
      // Create a copy of the child product to avoid modifying the original
      return Product(
        id: child.id,
        code: child.code,
        name: child.name,
        basePrice: child.basePrice,
        unit: child.unit,
        unitValue: child.unitValue,
        base: child.base,
        tintingFormulaType: parent.tintingFormulaType,
        // Add mock price tiers
        prices: {
          'Giá bán lẻ': child.basePrice,
          'Giá đại lý cấp 1': child.basePrice * 0.9,
          'Giá dự án': child.basePrice * 0.8,
        },
      );
    });
  }),

  // Standalone products (no tinting)
  ...mockStandaloneProducts,
];

/// Mock list of customers.
final List<Customer> mockCustomers = [
  Customer(
    id: 1, // Changed to int
    code: 'KH001',
    name: 'Khách lẻ',
    gender: null,
    birthDate: null,
    contactNumber: null,
    address: null,
    locationName: null,
    wardName: null,
    email: null,
    organization: null,
    comments: 'Khách hàng không có thông tin cụ thể',
    taxCode: null,
    retailerId: 1,
    debt: 0.0,
    totalInvoiced: 0.0,
    totalPoint: 0.0,
    totalRevenue: 0.0,
    modifiedDate: null, // Can be null for initial mock
    createdDate: DateTime(2023, 1, 1), // Required
    groups: [],
    psidFacebook: null,
  ),
  Customer(
    id: 2,
    code: 'KH002',
    name: 'Anh Sơn - Cầu Giấy',
    gender: true, // Nam
    birthDate: DateTime(1985, 5, 10),
    contactNumber: '0912345678',
    address: '123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội',
    locationName: 'Hà Nội',
    wardName: 'Cầu Giấy',
    email: 'son.cg@example.com',
    organization: 'Công ty TNHH Sơn Việt',
    comments: 'Khách hàng thân thiết, mua hàng thường xuyên.',
    taxCode: '0101234567',
    retailerId: 1,
    debt: 500000.0,
    totalInvoiced: 15000000.0,
    totalPoint: 150.5,
    totalRevenue: 15000000.0,
    modifiedDate: DateTime.now(),
    createdDate: DateTime(2022, 1, 15),
    groups: ['Khách VIP', 'Khách dự án'],
    rewardPoint: 1500,
    psidFacebook: '12345678901234567',
  ),
  Customer(
    id: 3,
    code: 'KH003',
    name: 'Công ty Xây dựng ABC',
    gender: null, // Không xác định
    birthDate: null,
    contactNumber: '02439998888',
    address: 'Tầng 10, Tòa nhà ABC, Khuất Duy Tiến, Thanh Xuân, Hà Nội',
    locationName: 'Hà Nội',
    wardName: 'Thanh Xuân',
    email: 'info@abc.com',
    organization: 'Công ty Xây dựng ABC',
    comments: 'Đối tác lớn, cần chiết khấu đặc biệt.',
    taxCode: '0109876543',
    retailerId: 1,
    debt: 0.0,
    totalInvoiced: 50000000.0,
    totalPoint: 500.0,
    totalRevenue: 50000000.0,
    modifiedDate: DateTime.now(),
    createdDate: DateTime(2021, 10, 1),
    groups: ['Khách dự án', 'Đối tác chiến lược'],
    rewardPoint: 5000,
    psidFacebook: '76543210987654321',
  ),
  Customer(
    id: 4,
    code: 'KH004',
    name: 'Chị Lan - Hoàng Mai',
    gender: false, // Nữ
    birthDate: DateTime(1990, 11, 22),
    contactNumber: '0987654321',
    address: 'Ngõ 100, Đường Giải Phóng, Quận Hoàng Mai, Hà Nội',
    locationName: 'Hà Nội',
    wardName: 'Hoàng Mai',
    email: 'lan.hm@example.com',
    organization: null,
    comments: 'Thích màu pastel, cần tư vấn kỹ.',
    taxCode: null,
    retailerId: 1,
    debt: 0.0,
    totalInvoiced: 2500000.0,
    totalPoint: 25.0,
    totalRevenue: 2500000.0,
    modifiedDate: DateTime.now(),
    createdDate: DateTime(2023, 3, 8),
    groups: ['Khách lẻ'],
    rewardPoint: 250,
    psidFacebook: null,
  ),
];

// ===========================================================================
// 3. Mock Orders - Complex data combining customers and products
// ===========================================================================

/* final List<Order> mockOrders = [
  // Order 1: Completed order for Anh Sơn
  Order(
    id: 101,
    code: 'HD00101',
    purchaseDate: DateTime(2024, 5, 20, 10, 30),
    branchId: 1,
    branchName: 'Chi nhánh trung tâm',
    customerId: 2,
    customerName: 'Anh Sơn - Cầu Giấy',
    total: 1120000, // (450000 * 2) + 220000
    totalPayment: 1150000, // Paid for order + delivery
    discountRatio: 0,
    discount: 0,
    status: 1,
    statusValue: 'Hoàn thành',
    description: 'Giao hàng nhanh trước 5h chiều. Khách quen.',
    usingCod: true,
    retailerId: 1,
    modifiedDate: DateTime(2024, 5, 20, 15, 0),
    createdDate: DateTime(2024, 5, 20, 10, 30),
    orderDetails: [
      OrderDetail(
        productId: 1002, // Mock product ID
        productCode: 'JMA5',
        productName: 'Jotun Majestic - Base A (5L)',
        quantity: 2,
        price: 450000,
        discount: 0,
        discountRatio: 0,
        note: 'Pha màu AP02-3 Vàng Chanh',
        isMaster: false,
      ),
      OrderDetail(
        productId: 2001, // Mock product ID
        productCode: 'VT002',
        productName: 'Sơn Lót Chống Kiềm Nội Thất Jotun (18L)',
        quantity: 1,
        price: 220000,
        discount: 0,
        discountRatio: 0,
        note: '',
        isMaster: false,
      ),
    ],
    payments: [
      Payment(
        id: 201,
        code: 'TT00201',
        amount: 1150000,
        method: 'Tiền mặt',
        status: 1,
        transDate: DateTime(2024, 5, 20, 15, 5),
        accountId: 101,
      ),
    ],
    orderDelivery: OrderDelivery(
      deliveryCode: 'GHN-XYZ123',
      type: 'Giao hàng nhanh',
      price: 30000,
      receiver: 'Anh Sơn',
      contactNumber: '0912345678',
      address: '123 Đường Cầu Giấy, Quận Cầu Giấy, Hà Nội',
      locationId: 1,
      locationName: 'Hà Nội',
      weight: 25,
      length: 40,
      width: 40,
      height: 50,
      partnerDeliveryId: 1,
      partnerDelivery: {'name': 'Giao Hàng Nhanh'},
    ),
    invoiceOrderSurcharges: [],
  ),

  // Order 2: Processing order for a company, no payment yet
  Order(
    id: 102,
    code: 'HD00102',
    purchaseDate: DateTime(2024, 5, 21, 14, 0),
    branchId: 1,
    branchName: 'Chi nhánh trung tâm',
    customerId: 3,
    customerName: 'Công ty Xây dựng ABC',
    total: 32350000, // (570000 * 50) + (85000 * 100)
    totalPayment: 0,
    discountRatio: 0,
    discount: 0,
    status: 2,
    statusValue: 'Đang xử lý',
    description: 'Xuất hóa đơn VAT. Giao hàng tại công trình.',
    usingCod: false,
    retailerId: 1,
    modifiedDate: DateTime(2024, 5, 21, 14, 5),
    createdDate: DateTime(2024, 5, 21, 14, 0),
    orderDetails: [
      OrderDetail(
        productId: 1004, // Mock product ID
        productCode: 'DWA5',
        productName: 'Dulux Weathershield - Base A (5L)',
        quantity: 50,
        price: 570000, // Discounted price
        discount: 30000,
        discountRatio: 0.05,
        note: 'Pha màu AP03-2 Xanh Bạc Hà',
        isMaster: false,
      ),
      OrderDetail(
        productId: 2002, // Mock product ID
        productCode: 'VT005',
        productName: 'Bột Trét Tường Ngoại Thất Dulux (40kg)',
        quantity: 100,
        price: 85000, // Project price
        discount: 15000,
        discountRatio: 0.15,
        note: '',
        isMaster: false,
      ),
    ],
    payments: [], // No payment yet
    orderDelivery: OrderDelivery(
      deliveryCode: 'VC-ABC-001',
      type: 'Tự vận chuyển',
      price: 0,
      receiver: 'Giám sát công trình - Anh Hùng',
      contactNumber: '0909123456',
      address: 'Công trình Vinhome Smart City, Tây Mỗ, Nam Từ Liêm, Hà Nội',
      locationId: 1,
      locationName: 'Hà Nội',
      weight: 1000,
      partnerDelivery: {'name': 'Tự vận chuyển'},
    ),
    invoiceOrderSurcharges: [
      {'surchargeId': 1, 'surchargeName': 'VAT', 'price': 2985000},
    ],
  ),
];
 */