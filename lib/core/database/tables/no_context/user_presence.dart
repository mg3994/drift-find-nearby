import 'package:drift/drift.dart';

class UserPresence extends Table {
  IntColumn get id => integer().autoIncrement()();
  BoolColumn get isOnline =>
      boolean().withDefault(const Constant(true))();
}
