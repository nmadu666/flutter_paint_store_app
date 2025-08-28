

import 'package:flutter_paint_store_app/features/color_palette/application/color_palette_state.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/paint_color_price.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:collection/collection.dart';

class PriceService {
  PriceService(this.ref);

  final Ref ref;

  double? getFinalPrice(PaintColor color, Product product) {
    final parent = ref
        .watch(allParentProductsProvider)
        .value
        ?.firstWhereOrNull(
          (p) => p.children.any((child) => child.id == product.id),
        );

    if (parent?.tintingFormulaType == null || product.base == null) {
      return product.basePrice;
    }

    final allColorPrices = ref.watch(allColorPricesProvider);

    final colorPrice = allColorPrices.firstWhereOrNull(
      (price) =>
          price.code == color.code &&
          price.base == product.base &&
          price.tintingFormulaType == parent?.tintingFormulaType,
    );

    if (colorPrice == null) {
      return null;
    }

    final tintingCost = calculateTintingCost(product, colorPrice);
    return product.basePrice + tintingCost;
  }

  double calculateTintingCost(Product product, PaintColorPrice colorPrice) {
    double tintingCost = 0;
    final pricePerMl = colorPrice.pricePerMl;
    final unitValue = product.unitValue;

    // Logic tính giá mới dựa trên yêu cầu của bạn
    if (unitValue < 2 && pricePerMl < 10) {
      tintingCost = 10000;
    } else if (unitValue < 7 && pricePerMl < 20) {
      tintingCost = 20000;
    } else if (unitValue < 20 && pricePerMl < 30) {
      tintingCost = 30000;
    } else {
      tintingCost = pricePerMl * 1200 * unitValue;
    }

    // Áp dụng chiết khấu nếu chi phí ban đầu (tính theo hệ số 1200) lớn hơn 50,000
    if (pricePerMl * 1200 * unitValue > 50000) {
      tintingCost = pricePerMl * 1150 * unitValue;
    }

    return tintingCost;
  }
}

final priceServiceProvider = Provider((ref) => PriceService(ref));
