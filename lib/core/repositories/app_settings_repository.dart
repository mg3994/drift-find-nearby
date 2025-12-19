import 'package:drift/drift.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:signals/signals.dart';
import 'package:findnearby/core/database/app_database.dart';

abstract class AppSettingsRepository {
  Signal<ThemeSetting?> get settingsSignal;
  Future<void> updateThemeMode(ThemeMode mode);
}

class AppSettingsRepositoryImpl implements AppSettingsRepository {
  final AppDatabase _db;
  late final Signal<ThemeSetting?> _settingsSignal;

  AppSettingsRepositoryImpl(this._db) {
    _settingsSignal = signal<ThemeSetting?>(null);
    _db.watchThemeSettings().listen((data) {
      _settingsSignal.value = data;
    });
  }

  @override
  Signal<ThemeSetting?> get settingsSignal => _settingsSignal;

  @override
  Future<void> updateThemeMode(ThemeMode mode) async {
    await (_db.update(_db.themeSettings)..where((t) => t.id.equals(1))).write(
      ThemeSettingsCompanion(themeMode: Value(mode)),
    );
  }
}
