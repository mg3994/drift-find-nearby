import 'package:drift/drift.dart';
import 'package:signals/signals.dart';

import '../database/app_database.dart';

abstract class UserPresenceRepository {
  const UserPresenceRepository();
  Signal<UserPresenceData?> get userPresenceSignal;
  ReadonlySignal<bool> get isLoading;
  Future<void> toggleOnlineStatus(bool value);
}

class UserPresenceRepositoryImpl implements UserPresenceRepository {
  final AppDatabase _db;
  late final Signal<UserPresenceData?> _userPresenceSignal;
  late final Signal<bool> _isLoading;

  UserPresenceRepositoryImpl(this._db) {
    _userPresenceSignal = signal<UserPresenceData?>(null);
    _isLoading = signal<bool>(false);
    _db.watchUserPresence().listen((data) {
      _userPresenceSignal.value = data;
    });
  }

  @override
  Signal<UserPresenceData?> get userPresenceSignal => _userPresenceSignal;

  @override
  ReadonlySignal<bool> get isLoading => _isLoading;

  @override
  Future<void> toggleOnlineStatus(bool value) async {
    _isLoading.value = true;
    try {
      await (_db.update(_db.userPresence)..where((t) => t.id.equals(1))).write(
        UserPresenceCompanion(isOnline: Value(value)),
      );
    } finally {
      _isLoading.value = false;
    }
  }
}
