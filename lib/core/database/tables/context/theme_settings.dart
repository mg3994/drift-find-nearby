import 'package:drift/drift.dart';
import '../utils/utils.dart'
    show
        AutoIncrementingPrimaryKey,
        ThemeModeConverter,
        FlexSchemeConverter,
        FlexSchemeColorConverter;

class ThemeSettings extends Table with AutoIncrementingPrimaryKey {
  // Theme settings
  IntColumn get themeMode => integer()
      .withDefault(const Constant(0))
      .map(const ThemeModeConverter())();

  IntColumn get flexSchemeEnum => integer()
      .withDefault(const Constant(0))
      .map(const FlexSchemeConverter())();

  TextColumn get flexSchemeColor =>
      text().nullable().map(const FlexSchemeColorConverter())();

  // Font settings
  TextColumn get fontFamily => text().withDefault(const Constant('Roboto'))();
  RealColumn get textScaleFactor => real().withDefault(const Constant(1.0))();

  TextColumn get locale => text().withDefault(const Constant('en'))();
}
