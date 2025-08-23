import 'dart:math';
import 'package:flutter_paint_store_app/models/paint_color_price.dart';
import 'package:flutter_paint_store_app/models/product.dart';

double calculateTintingCost(Product product, PaintColorPrice colorPrice) {
  double tintingCost = 0;
  final pricePerMl = colorPrice.pricePerMl;
  final unitValue = product.unitValue;

  if (unitValue < 2 && pricePerMl > 10) {
    tintingCost = max(pricePerMl * 1200 * unitValue, 10000);
  } else if (unitValue < 7 && pricePerMl > 20) {
    tintingCost = max(pricePerMl * 1200 * unitValue, 20000);
  } else if (unitValue < 20 && pricePerMl > 30) {
    tintingCost = max(pricePerMl * 1200 * unitValue, 20000);
  } else {
    tintingCost = pricePerMl * 1200 * unitValue;
  }

  if (pricePerMl * 1200 * unitValue > 500000) {
    tintingCost = pricePerMl * 1150 * unitValue;
  }

  return tintingCost;
}
