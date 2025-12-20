import 'package:drift/drift.dart' show TypeConverter;
import 'package:flex_color_scheme/flex_color_scheme.dart' show FlexScheme;

class FlexSchemeConverter extends TypeConverter<FlexScheme, int> {
  const FlexSchemeConverter();
  @override
  FlexScheme fromSql(int fromDb) {
    return FlexScheme.values[fromDb];
  }

  @override
  int toSql(FlexScheme value) {
    return value.index;
  }
}
