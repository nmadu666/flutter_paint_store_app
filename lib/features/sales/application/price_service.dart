import 'package:collection/collection.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';
import 'package:flutter_paint_store_app/models/paint_color_price.dart';
import 'package:flutter_paint_store_app/models/parent_product.dart';
import 'package:flutter_paint_store_app/models/product.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PriceService {
  // The service is now pure and doesn't depend on Riverpod's Ref.
  // This makes it highly testable and reusable.

  double? getFinalPrice(
    PaintColor color,
    Product product,
    List<ParentProduct> allParentProducts,
    List<PaintColorPrice> allColorPrices,
  ) {
    final parent = allParentProducts.firstWhereOrNull(
      (p) => p.children.any((child) => child.id == product.id),
    );

    if (parent?.tintingFormulaType == null || product.base == null) {
      return product.basePrice;
    }

    final colorPrice = allColorPrices.firstWhereOrNull(
      (price) =>
          price.code == color.code &&
          price.base == product.base &&
          price.tintingFormulaType == parent?.tintingFormulaType,
    );

    if (colorPrice == null) {
      // Could not find a matching price for this specific color/base/formula combination.
      // Returning null might be better to indicate that a price is not available.
      return null;
    }

    final tintingCost = calculateTintingCost(product, colorPrice);
    return product.basePrice + tintingCost;
  }

  double calculateTintingCost(Product product, PaintColorPrice colorPrice) {
    double tintingCost = 0;
    final pricePerMl = colorPrice.pricePerMl;
    final unitValue = product.unitValue;

    // This logic seems specific and could be extracted to a configuration object
    // if it needs to be more dynamic in the future.
    if (unitValue < 2 && pricePerMl < 10) {
      tintingCost = 10000;
    } else if (unitValue < 7 && pricePerMl < 20) {
      tintingCost = 20000;
    } else if (unitValue < 20 && pricePerMl < 30) {
      tintingCost = 30000;
    } else {
      tintingCost = pricePerMl * 1200 * unitValue;
    }

    // Apply discount if the initial cost (based on 1200 multiplier) is > 50,000
    if (pricePerMl * 1200 * unitValue > 50000) {
      tintingCost = pricePerMl * 1150 * unitValue;
    }

    return tintingCost;
  }
}

// The provider now simply creates an instance of the service.
final priceServiceProvider = Provider((ref) => PriceService());