import 'package:flutter/material.dart';

/// Represents a single paint color with its properties.
class PaintColor {
  final String id;
  final String name;
  final String code;
  final String brand;
  final String collection;
  final Color color;
  final String? ncs;

  const PaintColor({
    required this.id,
    required this.name,
    required this.code,
    required this.brand,
    required this.collection,
    required this.color,
    this.ncs,
  });

  /// Returns the hex string representation of the color (e.g., #FFFFFF).
  String get hexString =>
      '#${color.value.toRadixString(16).substring(2).toUpperCase()}';

  PaintColor copyWith({
    String? id,
    String? name,
    String? code,
    String? brand,
    String? collection,
    Color? color,
    String? ncs,
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
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PaintColor &&
        other.id == id &&
        other.name == name &&
        other.code == code &&
        other.brand == brand &&
        other.collection == collection &&
        other.color == color &&
        other.ncs == ncs;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      name.hashCode ^
      code.hashCode ^
      brand.hashCode ^
      collection.hashCode ^
      color.hashCode ^
      ncs.hashCode;
}
