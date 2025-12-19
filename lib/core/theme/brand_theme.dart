import 'package:flutter/material.dart';

class BrandTheme extends ThemeExtension<BrandTheme> {
  const BrandTheme({required this.isDarkThemeMode, required this.brandColor});

  final bool isDarkThemeMode;
  final Color brandColor;

  @override
  ThemeExtension<BrandTheme> copyWith({
    bool? isDarkThemeMode,
    Color? brandColor,
  }) {
    return BrandTheme(
      isDarkThemeMode: isDarkThemeMode ?? this.isDarkThemeMode,
      brandColor: brandColor ?? this.brandColor,
    );
  }

  @override
  ThemeExtension<BrandTheme> lerp(
    covariant ThemeExtension<BrandTheme>? other,
    double t,
  ) {
    if (other is! BrandTheme) {
      return this;
    }
    return BrandTheme(
      isDarkThemeMode: other.isDarkThemeMode,
      brandColor: Color.lerp(brandColor, other.brandColor, t)!,
    );
  }
}
