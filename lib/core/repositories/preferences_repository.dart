import 'package:drift/drift.dart';
import 'package:signals/signals.dart';

import '../database/app_database.dart'
    show Preference, AppDatabase, PreferencesCompanion;

abstract class PreferencesRepository {
  const PreferencesRepository();
  Future<Preference> get preferences;
  ReadonlySignal<bool> get isLoading;
  Future<void> completeOnboarding();
}

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppDatabase _db;
  late final Signal<bool> _isLoading;

  PreferencesRepositoryImpl(this._db) {
    _isLoading = signal<bool>(false);
  }

  @override
  Future<Preference> get preferences => _db.getPreferences();

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
