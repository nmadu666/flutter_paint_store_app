import 'package:flutter/material.dart';
import 'package:flutter_paint_store_app/models/paint_color.dart';

/// Represents the pricing information for a specific [PaintColor]
/// based on the tinting formula and base.
@immutable
class PaintColorPrice extends PaintColor {
  /// The type of tinting formula, e.g., 'int_1', 'ext_1'.
  final String tintingFormulaType;

  /// The base of the paint, e.g., 'A', 'B', 'C', 'D'.
  final String base;

  /// The price per milliliter for tinting this color.
  final double pricePerMl;

  PaintColorPrice({
    required super.id,
    required super.name,
    required super.code,
    required super.brand,
    required super.collection,
    required super.color,
    super.ncs,
    required this.tintingFormulaType,
    required this.base,
    required this.pricePerMl,
  });

  /// Creates a [PaintColorPrice] from a [PaintColor] and pricing details.
  factory PaintColorPrice.fromPaintColor(
    PaintColor parentColor, {
    required String tintingFormulaType,
    required String base,
    required double pricePerMl,
  }) {
    return PaintColorPrice(
      id: parentColor.id,
      name: parentColor.name,
      code: parentColor.code,
      brand: parentColor.brand,
      collection: parentColor.collection,
      color: parentColor.color,
      ncs: parentColor.ncs,
      tintingFormulaType: tintingFormulaType,
      base: base,
      pricePerMl: pricePerMl,
    );
  }

  /// Deserializes the given `Map<String, dynamic>` into a [PaintColorPrice].
  factory PaintColorPrice.fromJson(Map<String, dynamic> json) {
    return PaintColorPrice(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      brand: json['brand'] as String,
      collection: json['collection'] as String,
      color: Color(json['color'] as int),
      ncs: json['ncs'] as String?,
      tintingFormulaType: json['tintingFormulaType'] as String,
      base: json['base'] as String,
      pricePerMl: (json['pricePerMl'] as num).toDouble(),
    );
  }

  /// Converts this [PaintColorPrice] into a `Map<String, dynamic>`.
  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'tintingFormulaType': tintingFormulaType,
      'base': base,
      'pricePerMl': pricePerMl,
    });
    return json;
  }

  @override
  String toString() {
    return 'PaintColorPrice(parent: ${super.toString()}, tintingFormulaType: $tintingFormulaType, base: $base, pricePerMl: $pricePerMl)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaintColorPrice &&
        super == other &&
        other.tintingFormulaType == tintingFormulaType &&
        other.base == base &&
        other.pricePerMl == pricePerMl;
  }

  @override
  int get hashCode {
    return super.hashCode ^
        tintingFormulaType.hashCode ^
        base.hashCode ^
        pricePerMl.hashCode;
  }
}
