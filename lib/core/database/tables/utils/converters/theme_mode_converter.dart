import 'package:drift/drift.dart' show TypeConverter;
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
