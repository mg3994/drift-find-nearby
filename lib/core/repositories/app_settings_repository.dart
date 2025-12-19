import 'package:drift/drift.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart' show ThemeMode, TextTheme;
import 'package:google_fonts/google_fonts.dart';
import 'package:signals/signals.dart';
import 'package:findnearby/core/database/app_database.dart';

abstract class AppSettingsRepository {
  Signal<ThemeSetting?> get settingsSignal;
  ReadonlySignal<bool> get isLoading;
  Future<void> updateThemeMode(ThemeMode mode);
  Future<void> updateFlexScheme(FlexScheme scheme);
  Future<void> updateFlexSchemeColor(FlexSchemeColor color);
  Future<void> updateFontFamily(String fontFamily);
  Future<void> updateTextScaleFactor(double factor);
  Future<void> updateLocale(String localeCode);

  /// Helper to get the font builder from the stored font name.
  TextTheme Function(TextTheme) getFontBuilder(String? name);
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppDatabase _db;
  late final Signal<ThemeSetting?> _settingsSignal;
  late final Signal<bool> _isLoading;

  AppSettingsRepositoryImpl(this._db) {
    _settingsSignal = signal<ThemeSetting?>(null);
    _isLoading = signal<bool>(false);
    _db.watchThemeSettings().listen((data) {
      _settingsSignal.value = data;
    });
  }

  @override
  Signal<ThemeSetting?> get settingsSignal => _settingsSignal;

  @override
  ReadonlySignal<bool> get isLoading => _isLoading;

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(themeMode: Value(mode)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateFlexScheme(FlexScheme scheme) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(flexSchemeEnum: Value(scheme)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateFlexSchemeColor(FlexSchemeColor color) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(flexSchemeColor: Value(color)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateFontFamily(String fontFamily) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(fontFamily: Value(fontFamily)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateLocale(String localeCode) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(locale: Value(localeCode)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> updateTextScaleFactor(double factor) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
        ThemeSettingsCompanion(textScaleFactor: Value(factor)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  TextTheme Function(TextTheme) getFontBuilder(String? name) {
    if (name == null || name.isEmpty) return GoogleFonts.interTextTheme;
    try {
      return (TextTheme base) => GoogleFonts.getTextTheme(name, base);
    } catch (_) {
      return GoogleFonts.interTextTheme;
    }
  }
}
