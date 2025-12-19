import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;

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

class ThemeSettings extends Table {
  IntColumn get id => integer().autoIncrement()();

  // Theme settings
  IntColumn get themeMode => integer()
      .withDefault(const Constant(0))
      .map(const ThemeModeConverter())();
  IntColumn get flexSchemeEnum => integer().nullable()(); // null if custom
  TextColumn get flexSchemeColor =>
      text().nullable()(); // JSON string for custom colors

  // Font settings
  TextColumn get fontFamily => text().withDefault(const Constant('Roboto'))();
  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();

  TextColumn get locale => text().withDefault(const Constant('en'))();
}
