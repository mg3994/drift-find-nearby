import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:drift/drift.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart'
    show FlexScheme, FlexSchemeColor;
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter/widgets.dart' show Color;
import '../utils/utils.dart' show AutoIncrementingPrimaryKey;

class ThemeSettings extends Table with AutoIncrementingPrimaryKey {
  // Theme settings
  IntColumn get themeMode => integer()
      .withDefault(const Constant(0))
      .map(const ThemeModeConverter())();

  IntColumn get flexSchemeEnum => integer()
      .withDefault(const Constant(0))
      .map(const FlexSchemeConverter())();

  TextColumn get flexSchemeColor =>
      text().nullable().map(const FlexSchemeColorConverter())();

  // Font settings
  TextColumn get fontFamily => text().withDefault(const Constant('Inter'))();
  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();

  TextColumn get locale => text().withDefault(const Constant('en'))();
}

// /////////////////////////////////

class ThemeModeConverter extends TypeConverter<ThemeMode, int> {
  const ThemeModeConverter();
  @override
  ThemeMode fromSql(int fromDb) {
    return ThemeMode.values[fromDb];
  }

  @override
  int toSql(ThemeMode value) {
    return value.index;
  }
}

class FlexSchemeConverter extends TypeConverter<FlexScheme, int> {
  const FlexSchemeConverter();
  @override
  FlexScheme fromSql(int fromDb) {
    return FlexScheme.values[fromDb];
  }

  @override
  int toSql(FlexScheme value) {
    return value.index;
  }
}

class FlexSchemeColorConverter extends TypeConverter<FlexSchemeColor, String> {
  const FlexSchemeColorConverter();

  @override
  FlexSchemeColor fromSql(String fromDb) {
    final Map<String, dynamic> map = jsonDecode(fromDb) as Map<String, dynamic>;
    return FlexSchemeColor(
      primary: Color(map['primary'] as int),
      primaryContainer: map['primaryContainer'] != null
          ? Color(map['primaryContainer'] as int)
          : null,
      secondary: Color(map['secondary'] as int),
      secondaryContainer: map['secondaryContainer'] != null
          ? Color(map['secondaryContainer'] as int)
          : null,
      tertiary: map['tertiary'] != null ? Color(map['tertiary'] as int) : null,
      tertiaryContainer: map['tertiaryContainer'] != null
          ? Color(map['tertiaryContainer'] as int)
          : null,
      appBarColor: map['appBarColor'] != null
          ? Color(map['appBarColor'] as int)
          : null,
      error: map['error'] != null ? Color(map['error'] as int) : null,
      errorContainer: map['errorContainer'] != null
          ? Color(map['errorContainer'] as int)
          : null,
    );
  }

  @override
  String toSql(FlexSchemeColor value) {
    return jsonEncode({
      'primary': value.primary.toARGB32(),
      'primaryContainer': value.primaryContainer.toARGB32(),
      'secondary': value.secondary.toARGB32(),
      'secondaryContainer': value.secondaryContainer.toARGB32(),
      'tertiary': value.tertiary.toARGB32(),
      'tertiaryContainer': value.tertiaryContainer.toARGB32(),
      'appBarColor': value.appBarColor?.toARGB32(),
      'error': value.error?.toARGB32(),
      'errorContainer': value.errorContainer?.toARGB32(),
    });
  }
}
