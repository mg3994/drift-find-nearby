import 'package:drift/drift.dart';
import '../utils/utils.dart' show AutoIncrementingPrimaryKey;

class FeatureFlags extends Table with AutoIncrementingPrimaryKey {
  BoolColumn get showAds => boolean().withDefault(const Constant(true))();
  BoolColumn get showNotification =>
      boolean().withDefault(const Constant(false))();
}
