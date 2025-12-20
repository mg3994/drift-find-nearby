import 'package:drift/drift.dart';
import 'package:signals/signals.dart';
import 'package:findnearby/core/database/app_database.dart';

abstract class PreferencesRepository {
  Signal<Preference?> get preferencesSignal;
  ReadonlySignal<bool> get isOnboardingCompleted;
  ReadonlySignal<bool> get isLoading;
  Future<void> completeOnboarding();
}

class PreferencesRepositoryImpl implements PreferencesRepository {
  final AppDatabase _db;
  late final Signal<Preference?> _preferencesSignal;
  late final ReadonlySignal<bool> _isOnboardingCompleted;
  final _isLoading = signal<bool>(false);

  PreferencesRepositoryImpl(this._db) {
    _preferencesSignal = signal<Preference?>(null);
    _isOnboardingCompleted = computed(() => _preferencesSignal.value?.isOnboardingCompleted ?? false);
    _init();
  }

  Future<void> _init() async {
    _isLoading.value = true;
    try {
      final prefs = await _db.getPreferences();
      _preferencesSignal.value = prefs;

      // Watch for changes
      _db.watchPreferences().listen((prefs) {
        _preferencesSignal.value = prefs;
      });
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Signal<Preference?> get preferencesSignal => _preferencesSignal;

  @override
  ReadonlySignal<bool> get isOnboardingCompleted => _isOnboardingCompleted;

  @override
  ReadonlySignal<bool> get isLoading => _isLoading;

  @override
  Future<void> completeOnboarding() async {
    _isLoading.value = true;
    try {
      final current = _preferencesSignal.value;
      if (current != null) {
        await _db.updatePreferences(
          current.copyWith(isOnboardingCompleted: true),
        );
      }
    } finally {
      _isLoading.value = false;
    }
  }
}
