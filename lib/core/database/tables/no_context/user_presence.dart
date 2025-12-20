import 'package:drift/drift.dart';

import '../utils/utils.dart' show AutoIncrementingPrimaryKey;

class UserPresence extends Table with AutoIncrementingPrimaryKey {
  BoolColumn get isOnline => boolean().withDefault(const Constant(true))();
}
