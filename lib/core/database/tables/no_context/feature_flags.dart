import 'package:drift/drift.dart';

class FeatureFlags extends Table {
  IntColumn get id => integer().autoIncrement()();

  BoolColumn get showAds => boolean().withDefault(const Constant(true))();
  BoolColumn get showNotification =>
      boolean().withDefault(const Constant(false))();
}
