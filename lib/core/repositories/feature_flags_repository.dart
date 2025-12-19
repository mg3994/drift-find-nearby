import 'package:drift/drift.dart';
import 'package:signals/signals.dart';
import 'package:findnearby/core/database/app_database.dart';

abstract class FeatureFlagsRepository {
  Signal<FeatureFlag?> get flagsSignal;
  ReadonlySignal<bool> get isLoading;
  Future<void> toggleAds(bool show);
  Future<void> toggleNotifications(bool show);
}

class FeatureFlagsRepositoryImpl implements FeatureFlagsRepository {
  final AppDatabase _db;
  late final Signal<FeatureFlag?> _flagsSignal;
  late final Signal<bool> _isLoading;

  FeatureFlagsRepositoryImpl(this._db) {
    _flagsSignal = signal<FeatureFlag?>(null);
    _isLoading = signal<bool>(false);
    _db.watchFeatureFlags().listen((data) {
      _flagsSignal.value = data;
    });
  }

  @override
  Signal<FeatureFlag?> get flagsSignal => _flagsSignal;

  @override
  ReadonlySignal<bool> get isLoading => _isLoading;

  @override
  Future<void> toggleAds(bool show) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.featureFlags)..where((t) => t.id.equals(1))).write(
        FeatureFlagsCompanion(showAds: Value(show)),
      );
    } finally {
      _isLoading.value = false;
    }
  }

  @override
  Future<void> toggleNotifications(bool show) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.featureFlags)..where((t) => t.id.equals(1))).write(
        FeatureFlagsCompanion(showNotification: Value(show)),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
