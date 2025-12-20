import 'package:drift/drift.dart';
import 'package:signals/signals.dart';

import '../database/app_database.dart'
    show Preference, AppDatabase, PreferencesCompanion;

abstract class PreferencesRepository {
  const PreferencesRepository();
  Signal<Preference?> get preferencesSignal;
  ReadonlySignal<bool> get isLoading;
  Future<void> completeOnboarding();
}

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppDatabase _db;
  late final Signal<Preference?> _preferencesSignal;
  late final Signal<bool> _isLoading;

  PreferencesRepositoryImpl(this._db) {
    _preferencesSignal = signal<Preference?>(null);
    _isLoading = signal<bool>(false);
    _db.watchPreferences().listen((data) {
      _preferencesSignal.value = data;
    });
  }

  @override
  Signal<Preference?> get preferencesSignal => _preferencesSignal;

  @override
  ReadonlySignal<bool> get isLoading => _isLoading;

  @override
  Future<void> completeOnboarding() async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.preferences)..where((t) => t.id.equals(1))).write(
        const PreferencesCompanion(isOnboardingCompleted: Value(true)),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
