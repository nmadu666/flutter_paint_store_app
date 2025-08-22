import 'package:flutter/material.dart';

import '../../../models/paint_color.dart';

/// Enum representing different color tones for filtering.
enum ColorTone {
  whiteGrayBlack,
  beigeBrown,
  redPink,
  orangePeach,
  yellow,
  green,
  blue,
  purple,
}

/// Gets the display name for a given [ColorTone].
String getToneName(ColorTone tone) {
  switch (tone) {
    case ColorTone.whiteGrayBlack:
      return 'Trắng, Xám & Đen';
    case ColorTone.beigeBrown:
      return 'Be & Nâu';
    case ColorTone.redPink:
      return 'Đỏ & Hồng';
    case ColorTone.orangePeach:
      return 'Cam & Đào';
    case ColorTone.yellow:
      return 'Vàng';
    case ColorTone.green:
      return 'Xanh lá';
    case ColorTone.blue:
      return 'Xanh lam';
    case ColorTone.purple:
      return 'Tím';
  }
}

/// Determines the [ColorTone] for a given [Color].
ColorTone? getColorTone(Color color) {
  final hsl = HSLColor.fromColor(color);
  final hue = hsl.hue;
  final saturation = hsl.saturation;
  final lightness = hsl.lightness;

  // Grayscale colors (White, Gray, Black)
  if (saturation < 0.1 || lightness < 0.15 || lightness > 0.9) {
    return ColorTone.whiteGrayBlack;
  }

  // Beige and Brown
  if (hue >= 20 && hue < 45 && saturation < 0.6) {
    return ColorTone.beigeBrown;
  }

  // Red and Pink
  if (hue >= 340 || hue < 20) return ColorTone.redPink;
  // Orange and Peach
  if (hue >= 20 && hue < 45) return ColorTone.orangePeach;
  // Yellow
  if (hue >= 45 && hue < 70) return ColorTone.yellow;
  // Green
  if (hue >= 70 && hue < 160) return ColorTone.green;
  // Blue
  if (hue >= 160 && hue < 260) return ColorTone.blue;
  // Purple
  if (hue >= 260 && hue < 340) return ColorTone.purple;

  return null;
}

/// Determines if a base is suitable for a given color based on lightness.
/// This is a simplified logic. A real-world scenario might involve more complex rules.
/// - Base P, A (Light): For light colors (lightness > 0.85)
/// - Base B, C (Medium): For mid-range colors (0.5 < lightness <= 0.85)
/// - Base D (Deep): For dark colors (lightness <= 0.5)
bool isBaseSuitableForColor(String base, PaintColor color) {
  final lightness = color.lightness;
  final upperCaseBase = base.toUpperCase();

  if ((upperCaseBase == 'P' || upperCaseBase == 'A') && lightness > 0.85) {
    return true;
  }
  if ((upperCaseBase == 'B' || upperCaseBase == 'C') &&
      lightness > 0.5 &&
      lightness <= 0.85) {
    return true;
  }
  if ((upperCaseBase == 'D') && lightness <= 0.5) {
    return true;
  }
  return false;
}