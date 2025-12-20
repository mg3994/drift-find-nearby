import 'package:drift/drift.dart';

class Preferences extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isOnboardingCompleted =>
      boolean().withDefault(const Constant(false))();
}
