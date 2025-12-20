import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:path_provider/path_provider.dart';

import 'package:findnearby/core/database/tables/tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [ThemeSettings, FeatureFlags, Preferences, UserPresence])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

  // -- Theme Settings Singleton Access --
  Future<ThemeSetting> getThemeSettings() async {
    final query = select(themeSettings)..where((t) => t.id.equals(1));
    final result = await query.getSingleOrNull();
    if (result == null) {
      await into(
        themeSettings,
      ).insert(const ThemeSettingsCompanion(id: Value(1)));
      return await query.getSingle();
    }
    return result;
  }

  Stream<ThemeSetting?> watchThemeSettings() {
    return (select(
      themeSettings,
    )..where((t) => t.id.equals(1))).watchSingleOrNull();
  }

  // -- Feature Flags Singleton Access --
  Future<FeatureFlag> getFeatureFlags() async {
    final query = select(featureFlags)..where((t) => t.id.equals(1));
    final result = await query.getSingleOrNull();
    if (result == null) {
      await into(
        featureFlags,
      ).insert(const FeatureFlagsCompanion(id: Value(1)));
      return await query.getSingle();
    }
    return result;
  }

  Stream<FeatureFlag?> watchFeatureFlags() {
    return (select(
      featureFlags,
    )..where((t) => t.id.equals(1))).watchSingleOrNull();
  }

  // -- Preferences Singleton Access --
  Future<Preference> getPreferences() async {
    final query = select(preferences)..where((t) => t.id.equals(1));
    final result = await query.getSingleOrNull();
    if (result == null) {
      await into(preferences).insert(const PreferencesCompanion(id: Value(1)));
      return await query.getSingle();
    }
    return result;
  }

  Stream<Preference?> watchPreferences() {
    return (select(
      preferences,
    )..where((t) => t.id.equals(1))).watchSingleOrNull();
  }

  Future<void> updatePreferences(Preference entry) =>
      update(preferences).replace(entry);

  // -- User Presence Singleton Access --
  //  watch
  Future<UserPresenceData> getUserPresence() async {
    final query = select(userPresence)..where((t) => t.id.equals(1));
    final result = await query.getSingleOrNull();
    if (result == null) {
      await into(
        userPresence,
      ).insert(const UserPresenceCompanion(id: Value(1)));
      return await query.getSingle();
    }
    return result;
  }

  Stream<UserPresenceData?> watchUserPresence() {
    return (select(
      userPresence,
    )..where((t) => t.id.equals(1))).watchSingleOrNull();
  }
}

QueryExecutor _openConnection() {
  return driftDatabase(
    name: 'database',
    native: const DriftNativeOptions(
      databaseDirectory: getApplicationSupportDirectory,
    ),
    web: DriftWebOptions(
      sqlite3Wasm: Uri.parse('sqlite3.wasm'),
      driftWorker: Uri.parse('drift_worker.js'),
      onResult: (result) {
        if (result.missingFeatures.isNotEmpty) {
          debugPrint(
            'Using ${result.chosenImplementation} due to unsupported '
            'browser features: ${result.missingFeatures}',
          );
        }
      },
    ),
  );
}
