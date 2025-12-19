import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:serverpod_auth_idp_flutter/serverpod_auth_idp_flutter.dart'
//     show AuthIdpTheme, PinTheme;

import 'brand_theme.dart' show BrandTheme;

/// Central theme configuration for the app.
abstract final class AppTheme {
  // Private constructor to prevent instantiation.
  const AppTheme._();

  // Default fallback scheme.
  static const FlexScheme _defaultScheme = FlexScheme.material;

  /// Helper to get the primary brand color based on brightness and optional custom scheme.
  static Color _getPrimaryColor({
    required Brightness brightness,
    FlexSchemeColor? flexSchemeColor,
    FlexScheme? flexSchemeEnum,
  }) {
    if (flexSchemeEnum == FlexScheme.custom) {
      return flexSchemeColor?.primary ??
          _defaultScheme.colors(brightness).primary;
    }
    return (flexSchemeEnum ?? _defaultScheme).colors(brightness).primary;
  }

  /// ⚙️ Core theme builder logic for both light and dark modes.
  static ThemeData _buildTheme({
    required Brightness brightness,
    FlexSchemeColor? flexSchemeColor,
    FlexScheme? flexSchemeEnum,
    TextTheme Function(TextTheme)? fontTextThemeBuilder,
  }) {
    // 1. Determine if this is a dark theme for text theme calculation
    final bool isDark = brightness == Brightness.dark;

    // 2. Define the base ThemeData creator (FlexThemeData.light or FlexThemeData.dark)
    final themeDataFactory = isDark ? FlexThemeData.dark : FlexThemeData.light;

    // 3. Get the theme from the default Material ThemeData for context-aware text themes
    final baseTheme = isDark ? ThemeData.dark() : ThemeData.light();

    // 4. Determine the effective font text theme builder
    final effectiveFontTextThemeBuilder =
        fontTextThemeBuilder ?? GoogleFonts.interTextTheme;

    return themeDataFactory(
      colors: (flexSchemeEnum == FlexScheme.custom) ? flexSchemeColor : null,
      scheme: (flexSchemeEnum != FlexScheme.custom) ? flexSchemeEnum : null,
      subThemesData: FlexSubThemesData(
        interactionEffects: true,
        tintedDisabledControls: true,
        // Only blend colors in dark mode for better contrast/visuals
        blendOnColors: isDark,
        useM2StyleDividerInM3: true,
        inputDecoratorIsFilled: true,
        inputDecoratorBorderType: FlexInputBorderType.outline,
        alignedDropdown: true,
        navigationRailUseIndicator: true,
      ),
      visualDensity: FlexColorScheme.comfortablePlatformDensity,
      cupertinoOverrideTheme: const CupertinoThemeData(applyThemeToAll: true),

      // 5. Apply premium font using Google Fonts
      // Pass the base theme's text theme to GoogleFonts to merge and ensure
      // colors/styles match the current brightness (dark or light).
      textTheme: effectiveFontTextThemeBuilder(baseTheme.textTheme),
      primaryTextTheme: effectiveFontTextThemeBuilder(
        baseTheme.primaryTextTheme,
      ),

      // 6. Add custom extension
      extensions: [
        BrandTheme(
          isDarkThemeMode: isDark,
          brandColor: _getPrimaryColor(
            brightness: brightness,
            flexSchemeColor: flexSchemeColor,
            flexSchemeEnum: flexSchemeEnum,
          ),
        ),
        // AuthIdpTheme(
        //   defaultPinTheme: PinTheme(
        //     width: 50,
        //     height: 50,
        //     textStyle: TextStyle(
        //       fontSize: 20,
        //       color: isDark ? Colors.white : Colors.black,
        //       fontWeight: FontWeight.w600,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(
        //         color: isDark ? Colors.grey.shade700 : Colors.grey.shade400,
        //         width: 2,
        //       ),
        //     ),
        //   ),
        //   focusedPinTheme: PinTheme(
        //     width: 50,
        //     height: 50,
        //     textStyle: TextStyle(
        //       fontSize: 20,
        //       color: isDark ? Colors.white : Colors.black,
        //       fontWeight: FontWeight.w600,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(
        //         color: _getPrimaryColor(
        //           brightness: brightness,
        //           flexSchemeColor: flexSchemeColor,
        //           flexSchemeEnum: flexSchemeEnum,
        //         ),
        //         width: 2,
        //       ),
        //     ),
        //   ),
        //   errorPinTheme: PinTheme(
        //     width: 50,
        //     height: 50,
        //     textStyle: TextStyle(
        //       fontSize: 20,
        //       color: isDark ? Colors.white : Colors.black,
        //       fontWeight: FontWeight.w600,
        //     ),
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(8),
        //       border: Border.all(color: Colors.red.shade700, width: 2),
        //     ),
        //   ),
        //   separator: const SizedBox(width: 4),
        // ),
      ],
    );
  }

  /// 💡 Light theme data (Delegates to the builder).
  static ThemeData light({
    FlexSchemeColor? flexSchemeColor,
    FlexScheme? flexSchemeEnum,
    TextTheme Function(TextTheme)? fontTextThemeBuilder,
  }) {
    return _buildTheme(
      brightness: Brightness.light,
      flexSchemeColor: flexSchemeColor,
      flexSchemeEnum: flexSchemeEnum,
      fontTextThemeBuilder: fontTextThemeBuilder,
    );
  }

  /// 🌙 Dark theme data (Delegates to the builder).
  static ThemeData dark({
    FlexSchemeColor? flexSchemeColor,
    FlexScheme? flexSchemeEnum,
    TextTheme Function(TextTheme)? fontTextThemeBuilder,
  }) {
    return _buildTheme(
      brightness: Brightness.dark,
      flexSchemeColor: flexSchemeColor,
      flexSchemeEnum: flexSchemeEnum,
      fontTextThemeBuilder: fontTextThemeBuilder,
    );
  }
}
