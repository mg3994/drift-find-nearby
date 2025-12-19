import 'package:drift/drift.dart';
import 'package:signals/signals.dart';
import 'package:findnearby/core/database/app_database.dart';

abstract class FeatureFlagsRepository {
  Signal<FeatureFlag?> get flagsSignal;
  Future<void> toggleAds(bool show);
  Future<void> toggleNotifications(bool show);
}

class FeatureFlagsRepositoryImpl implements FeatureFlagsRepository {
  final AppDatabase _db;
  late final Signal<FeatureFlag?> _flagsSignal;

  FeatureFlagsRepositoryImpl(this._db) {
    _flagsSignal = signal<FeatureFlag?>(null);
    _db.watchFeatureFlags().listen((data) {
      _flagsSignal.value = data;
    });
  }

  @override
  Signal<FeatureFlag?> get flagsSignal => _flagsSignal;

  @override
  Future<void> toggleAds(bool show) async {
    await (_db.update(_db.featureFlags)..where((t) => t.id.equals(1)))
        .write(FeatureFlagsCompanion(showAds: Value(show)));
  }

  @override
  Future<void> toggleNotifications(bool show) async {
    await (_db.update(_db.featureFlags)..where((t) => t.id.equals(1)))
        .write(FeatureFlagsCompanion(showNotification: Value(show)));
  }
}
