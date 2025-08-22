import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Represents a single paint color with its properties.
@immutable
class PaintColor {
  final String id;
  final String name;
  final String code;
  final String brand;
  final String collection;
  final Color color;
  final String? ncs;

  /// A value from 0.0 (darkest) to 1.0 (lightest) used for sorting.
  /// Automatically calculated from the `color` property.
  final double lightness;

  // The lightness is calculated in the initializer list, so it's always
  // derived from the `color` property.
  PaintColor({
    required this.id,
    required this.name,
    required this.code,
    required this.brand,
    required this.collection,
    required this.color,
    this.ncs,
  }) : lightness = HSLColor.fromColor(color).lightness;

  /// Returns the hex string representation of the color (e.g., #FFFFFF).
  String get hexString =>
      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

  /// Deserializes the given `Map<String, dynamic>` into a [PaintColor].
  /// The `lightness` field is automatically derived from the `color`
  /// in the constructor.
  factory PaintColor.fromJson(Map<String, dynamic> json) {
    return PaintColor(
      id: json['id'] as String,
      name: json['name'] as String,
      code: json['code'] as String,
      brand: json['brand'] as String,
      collection: json['collection'] as String,
      color: Color(json['color'] as int),
      ncs: json['ncs'] as String?,
    );
  }

  /// Converts this [PaintColor] into a `Map<String, dynamic>`.
  /// The `lightness` field is included for server-side sorting capabilities.
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'brand': brand,
      'collection': collection,
      'color': color.value,
      'ncs': ncs,
      'lightness': lightness, // This field is now included
    };
  }

  PaintColor copyWith({
    String? id,
    String? name,
    String? code,
    String? brand,
    String? collection,
    Color? color,
    String? ncs,
    // lightness is not needed here as it's derived from color
  }) {
    return PaintColor(
      id: id ?? this.id,
      name: name ?? this.name,
      code: code ?? this.code,
      brand: brand ?? this.brand,
      collection: collection ?? this.collection,
      color: color ?? this.color,
      ncs: ncs ?? this.ncs,
    );
  }

  @override
  String toString() {
    return 'PaintColor(id: $id, name: $name, code: $code, brand: $brand, collection: $collection, color: $color, ncs: $ncs, lightness: $lightness)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaintColor &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.brand == brand &&
        other.collection == collection &&
        other.color == color &&
        other.ncs == ncs &&
        other.lightness == lightness;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        code.hashCode ^
        brand.hashCode ^
        collection.hashCode ^
        color.hashCode ^
        ncs.hashCode ^
        lightness.hashCode;
  }
}
