import 'package:drift/drift.dart';
import '../utils/utils.dart' show AutoIncrementingPrimaryKey;

class Preferences extends Table with AutoIncrementingPrimaryKey {
  BoolColumn get isOnboardingCompleted =>
      boolean().withDefault(const Constant(false))();
}
