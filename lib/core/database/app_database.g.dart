// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ThemeSettingsTable extends ThemeSettings
    with TableInfo<$ThemeSettingsTable, ThemeSetting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ThemeSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  late final GeneratedColumnWithTypeConverter<ThemeMode, int> themeMode =
      GeneratedColumn<int>(
        'theme_mode',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<ThemeMode>($ThemeSettingsTable.$converterthemeMode);
  @override
  late final GeneratedColumnWithTypeConverter<FlexScheme, int> flexSchemeEnum =
      GeneratedColumn<int>(
        'flex_scheme_enum',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: false,
        defaultValue: const Constant(0),
      ).withConverter<FlexScheme>($ThemeSettingsTable.$converterflexSchemeEnum);
  @override
  late final GeneratedColumnWithTypeConverter<FlexSchemeColor?, String>
  flexSchemeColor =
      GeneratedColumn<String>(
        'flex_scheme_color',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      ).withConverter<FlexSchemeColor?>(
        $ThemeSettingsTable.$converterflexSchemeColorn,
      );
  static const VerificationMeta _fontFamilyMeta = const VerificationMeta(
    'fontFamily',
  );
  @override
  late final GeneratedColumn<String> fontFamily = GeneratedColumn<String>(
    'font_family',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Roboto'),
  );
  static const VerificationMeta _textScaleFactorMeta = const VerificationMeta(
    'textScaleFactor',
  );
  @override
  late final GeneratedColumn<double> textScaleFactor = GeneratedColumn<double>(
    'text_scale_factor',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _localeMeta = const VerificationMeta('locale');
  @override
  late final GeneratedColumn<String> locale = GeneratedColumn<String>(
    'locale',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    themeMode,
    flexSchemeEnum,
    flexSchemeColor,
    fontFamily,
    textScaleFactor,
    locale,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'theme_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<ThemeSetting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('font_family')) {
      context.handle(
        _fontFamilyMeta,
        fontFamily.isAcceptableOrUnknown(data['font_family']!, _fontFamilyMeta),
      );
    }
    if (data.containsKey('text_scale_factor')) {
      context.handle(
        _textScaleFactorMeta,
        textScaleFactor.isAcceptableOrUnknown(
          data['text_scale_factor']!,
          _textScaleFactorMeta,
        ),
      );
    }
    if (data.containsKey('locale')) {
      context.handle(
        _localeMeta,
        locale.isAcceptableOrUnknown(data['locale']!, _localeMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ThemeSetting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ThemeSetting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      themeMode: $ThemeSettingsTable.$converterthemeMode.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}theme_mode'],
        )!,
      ),
      flexSchemeEnum: $ThemeSettingsTable.$converterflexSchemeEnum.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.int,
          data['${effectivePrefix}flex_scheme_enum'],
        )!,
      ),
      flexSchemeColor: $ThemeSettingsTable.$converterflexSchemeColorn.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}flex_scheme_color'],
        ),
      ),
      fontFamily: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}font_family'],
      )!,
      textScaleFactor: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}text_scale_factor'],
      )!,
      locale: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}locale'],
      )!,
    );
  }

  @override
  $ThemeSettingsTable createAlias(String alias) {
    return $ThemeSettingsTable(attachedDatabase, alias);
  }

  static TypeConverter<ThemeMode, int> $converterthemeMode =
      const ThemeModeConverter();
  static TypeConverter<FlexScheme, int> $converterflexSchemeEnum =
      const FlexSchemeConverter();
  static TypeConverter<FlexSchemeColor, String> $converterflexSchemeColor =
      const FlexSchemeColorConverter();
  static TypeConverter<FlexSchemeColor?, String?> $converterflexSchemeColorn =
      NullAwareTypeConverter.wrap($converterflexSchemeColor);
}

class ThemeSetting extends DataClass implements Insertable<ThemeSetting> {
  final int id;
  final ThemeMode themeMode;
  final FlexScheme flexSchemeEnum;
  final FlexSchemeColor? flexSchemeColor;
  final String fontFamily;
  final double textScaleFactor;
  final String locale;
  const ThemeSetting({
    required this.id,
    required this.themeMode,
    required this.flexSchemeEnum,
    this.flexSchemeColor,
    required this.fontFamily,
    required this.textScaleFactor,
    required this.locale,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['theme_mode'] = Variable<int>(
        $ThemeSettingsTable.$converterthemeMode.toSql(themeMode),
      );
    }
    {
      map['flex_scheme_enum'] = Variable<int>(
        $ThemeSettingsTable.$converterflexSchemeEnum.toSql(flexSchemeEnum),
      );
    }
    if (!nullToAbsent || flexSchemeColor != null) {
      map['flex_scheme_color'] = Variable<String>(
        $ThemeSettingsTable.$converterflexSchemeColorn.toSql(flexSchemeColor),
      );
    }
    map['font_family'] = Variable<String>(fontFamily);
    map['text_scale_factor'] = Variable<double>(textScaleFactor);
    map['locale'] = Variable<String>(locale);
    return map;
  }

  ThemeSettingsCompanion toCompanion(bool nullToAbsent) {
    return ThemeSettingsCompanion(
      id: Value(id),
      themeMode: Value(themeMode),
      flexSchemeEnum: Value(flexSchemeEnum),
      flexSchemeColor: flexSchemeColor == null && nullToAbsent
          ? const Value.absent()
          : Value(flexSchemeColor),
      fontFamily: Value(fontFamily),
      textScaleFactor: Value(textScaleFactor),
      locale: Value(locale),
    );
  }

  factory ThemeSetting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ThemeSetting(
      id: serializer.fromJson<int>(json['id']),
      themeMode: serializer.fromJson<ThemeMode>(json['themeMode']),
      flexSchemeEnum: serializer.fromJson<FlexScheme>(json['flexSchemeEnum']),
      flexSchemeColor: serializer.fromJson<FlexSchemeColor?>(
        json['flexSchemeColor'],
      ),
      fontFamily: serializer.fromJson<String>(json['fontFamily']),
      textScaleFactor: serializer.fromJson<double>(json['textScaleFactor']),
      locale: serializer.fromJson<String>(json['locale']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'themeMode': serializer.toJson<ThemeMode>(themeMode),
      'flexSchemeEnum': serializer.toJson<FlexScheme>(flexSchemeEnum),
      'flexSchemeColor': serializer.toJson<FlexSchemeColor?>(flexSchemeColor),
      'fontFamily': serializer.toJson<String>(fontFamily),
      'textScaleFactor': serializer.toJson<double>(textScaleFactor),
      'locale': serializer.toJson<String>(locale),
    };
  }

  ThemeSetting copyWith({
    int? id,
    ThemeMode? themeMode,
    FlexScheme? flexSchemeEnum,
    Value<FlexSchemeColor?> flexSchemeColor = const Value.absent(),
    String? fontFamily,
    double? textScaleFactor,
    String? locale,
  }) => ThemeSetting(
    id: id ?? this.id,
    themeMode: themeMode ?? this.themeMode,
    flexSchemeEnum: flexSchemeEnum ?? this.flexSchemeEnum,
    flexSchemeColor: flexSchemeColor.present
        ? flexSchemeColor.value
        : this.flexSchemeColor,
    fontFamily: fontFamily ?? this.fontFamily,
    textScaleFactor: textScaleFactor ?? this.textScaleFactor,
    locale: locale ?? this.locale,
  );
  ThemeSetting copyWithCompanion(ThemeSettingsCompanion data) {
    return ThemeSetting(
      id: data.id.present ? data.id.value : this.id,
      themeMode: data.themeMode.present ? data.themeMode.value : this.themeMode,
      flexSchemeEnum: data.flexSchemeEnum.present
          ? data.flexSchemeEnum.value
          : this.flexSchemeEnum,
      flexSchemeColor: data.flexSchemeColor.present
          ? data.flexSchemeColor.value
          : this.flexSchemeColor,
      fontFamily: data.fontFamily.present
          ? data.fontFamily.value
          : this.fontFamily,
      textScaleFactor: data.textScaleFactor.present
          ? data.textScaleFactor.value
          : this.textScaleFactor,
      locale: data.locale.present ? data.locale.value : this.locale,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSetting(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('flexSchemeEnum: $flexSchemeEnum, ')
          ..write('flexSchemeColor: $flexSchemeColor, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('textScaleFactor: $textScaleFactor, ')
          ..write('locale: $locale')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    themeMode,
    flexSchemeEnum,
    flexSchemeColor,
    fontFamily,
    textScaleFactor,
    locale,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ThemeSetting &&
          other.id == this.id &&
          other.themeMode == this.themeMode &&
          other.flexSchemeEnum == this.flexSchemeEnum &&
          other.flexSchemeColor == this.flexSchemeColor &&
          other.fontFamily == this.fontFamily &&
          other.textScaleFactor == this.textScaleFactor &&
          other.locale == this.locale);
}

class ThemeSettingsCompanion extends UpdateCompanion<ThemeSetting> {
  final Value<int> id;
  final Value<ThemeMode> themeMode;
  final Value<FlexScheme> flexSchemeEnum;
  final Value<FlexSchemeColor?> flexSchemeColor;
  final Value<String> fontFamily;
  final Value<double> textScaleFactor;
  final Value<String> locale;
  const ThemeSettingsCompanion({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.flexSchemeEnum = const Value.absent(),
    this.flexSchemeColor = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.textScaleFactor = const Value.absent(),
    this.locale = const Value.absent(),
  });
  ThemeSettingsCompanion.insert({
    this.id = const Value.absent(),
    this.themeMode = const Value.absent(),
    this.flexSchemeEnum = const Value.absent(),
    this.flexSchemeColor = const Value.absent(),
    this.fontFamily = const Value.absent(),
    this.textScaleFactor = const Value.absent(),
    this.locale = const Value.absent(),
  });
  static Insertable<ThemeSetting> custom({
    Expression<int>? id,
    Expression<int>? themeMode,
    Expression<int>? flexSchemeEnum,
    Expression<String>? flexSchemeColor,
    Expression<String>? fontFamily,
    Expression<double>? textScaleFactor,
    Expression<String>? locale,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (themeMode != null) 'theme_mode': themeMode,
      if (flexSchemeEnum != null) 'flex_scheme_enum': flexSchemeEnum,
      if (flexSchemeColor != null) 'flex_scheme_color': flexSchemeColor,
      if (fontFamily != null) 'font_family': fontFamily,
      if (textScaleFactor != null) 'text_scale_factor': textScaleFactor,
      if (locale != null) 'locale': locale,
    });
  }

  ThemeSettingsCompanion copyWith({
    Value<int>? id,
    Value<ThemeMode>? themeMode,
    Value<FlexScheme>? flexSchemeEnum,
    Value<FlexSchemeColor?>? flexSchemeColor,
    Value<String>? fontFamily,
    Value<double>? textScaleFactor,
    Value<String>? locale,
  }) {
    return ThemeSettingsCompanion(
      id: id ?? this.id,
      themeMode: themeMode ?? this.themeMode,
      flexSchemeEnum: flexSchemeEnum ?? this.flexSchemeEnum,
      flexSchemeColor: flexSchemeColor ?? this.flexSchemeColor,
      fontFamily: fontFamily ?? this.fontFamily,
      textScaleFactor: textScaleFactor ?? this.textScaleFactor,
      locale: locale ?? this.locale,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (themeMode.present) {
      map['theme_mode'] = Variable<int>(
        $ThemeSettingsTable.$converterthemeMode.toSql(themeMode.value),
      );
    }
    if (flexSchemeEnum.present) {
      map['flex_scheme_enum'] = Variable<int>(
        $ThemeSettingsTable.$converterflexSchemeEnum.toSql(
          flexSchemeEnum.value,
        ),
      );
    }
    if (flexSchemeColor.present) {
      map['flex_scheme_color'] = Variable<String>(
        $ThemeSettingsTable.$converterflexSchemeColorn.toSql(
          flexSchemeColor.value,
        ),
      );
    }
    if (fontFamily.present) {
      map['font_family'] = Variable<String>(fontFamily.value);
    }
    if (textScaleFactor.present) {
      map['text_scale_factor'] = Variable<double>(textScaleFactor.value);
    }
    if (locale.present) {
      map['locale'] = Variable<String>(locale.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ThemeSettingsCompanion(')
          ..write('id: $id, ')
          ..write('themeMode: $themeMode, ')
          ..write('flexSchemeEnum: $flexSchemeEnum, ')
          ..write('flexSchemeColor: $flexSchemeColor, ')
          ..write('fontFamily: $fontFamily, ')
          ..write('textScaleFactor: $textScaleFactor, ')
          ..write('locale: $locale')
          ..write(')'))
        .toString();
  }
}

class $FeatureFlagsTable extends FeatureFlags
    with TableInfo<$FeatureFlagsTable, FeatureFlag> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureFlagsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _showAdsMeta = const VerificationMeta(
    'showAds',
  );
  @override
  late final GeneratedColumn<bool> showAds = GeneratedColumn<bool>(
    'show_ads',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_ads" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _showNotificationMeta = const VerificationMeta(
    'showNotification',
  );
  @override
  late final GeneratedColumn<bool> showNotification = GeneratedColumn<bool>(
    'show_notification',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("show_notification" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [id, showAds, showNotification];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_flags';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureFlag> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('show_ads')) {
      context.handle(
        _showAdsMeta,
        showAds.isAcceptableOrUnknown(data['show_ads']!, _showAdsMeta),
      );
    }
    if (data.containsKey('show_notification')) {
      context.handle(
        _showNotificationMeta,
        showNotification.isAcceptableOrUnknown(
          data['show_notification']!,
          _showNotificationMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureFlag map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureFlag(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      showAds: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_ads'],
      )!,
      showNotification: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}show_notification'],
      )!,
    );
  }

  @override
  $FeatureFlagsTable createAlias(String alias) {
    return $FeatureFlagsTable(attachedDatabase, alias);
  }
}

class FeatureFlag extends DataClass implements Insertable<FeatureFlag> {
  final int id;
  final bool showAds;
  final bool showNotification;
  const FeatureFlag({
    required this.id,
    required this.showAds,
    required this.showNotification,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['show_ads'] = Variable<bool>(showAds);
    map['show_notification'] = Variable<bool>(showNotification);
    return map;
  }

  FeatureFlagsCompanion toCompanion(bool nullToAbsent) {
    return FeatureFlagsCompanion(
      id: Value(id),
      showAds: Value(showAds),
      showNotification: Value(showNotification),
    );
  }

  factory FeatureFlag.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureFlag(
      id: serializer.fromJson<int>(json['id']),
      showAds: serializer.fromJson<bool>(json['showAds']),
      showNotification: serializer.fromJson<bool>(json['showNotification']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'showAds': serializer.toJson<bool>(showAds),
      'showNotification': serializer.toJson<bool>(showNotification),
    };
  }

  FeatureFlag copyWith({int? id, bool? showAds, bool? showNotification}) =>
      FeatureFlag(
        id: id ?? this.id,
        showAds: showAds ?? this.showAds,
        showNotification: showNotification ?? this.showNotification,
      );
  FeatureFlag copyWithCompanion(FeatureFlagsCompanion data) {
    return FeatureFlag(
      id: data.id.present ? data.id.value : this.id,
      showAds: data.showAds.present ? data.showAds.value : this.showAds,
      showNotification: data.showNotification.present
          ? data.showNotification.value
          : this.showNotification,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlag(')
          ..write('id: $id, ')
          ..write('showAds: $showAds, ')
          ..write('showNotification: $showNotification')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, showAds, showNotification);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureFlag &&
          other.id == this.id &&
          other.showAds == this.showAds &&
          other.showNotification == this.showNotification);
}

class FeatureFlagsCompanion extends UpdateCompanion<FeatureFlag> {
  final Value<int> id;
  final Value<bool> showAds;
  final Value<bool> showNotification;
  const FeatureFlagsCompanion({
    this.id = const Value.absent(),
    this.showAds = const Value.absent(),
    this.showNotification = const Value.absent(),
  });
  FeatureFlagsCompanion.insert({
    this.id = const Value.absent(),
    this.showAds = const Value.absent(),
    this.showNotification = const Value.absent(),
  });
  static Insertable<FeatureFlag> custom({
    Expression<int>? id,
    Expression<bool>? showAds,
    Expression<bool>? showNotification,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (showAds != null) 'show_ads': showAds,
      if (showNotification != null) 'show_notification': showNotification,
    });
  }

  FeatureFlagsCompanion copyWith({
    Value<int>? id,
    Value<bool>? showAds,
    Value<bool>? showNotification,
  }) {
    return FeatureFlagsCompanion(
      id: id ?? this.id,
      showAds: showAds ?? this.showAds,
      showNotification: showNotification ?? this.showNotification,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (showAds.present) {
      map['show_ads'] = Variable<bool>(showAds.value);
    }
    if (showNotification.present) {
      map['show_notification'] = Variable<bool>(showNotification.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureFlagsCompanion(')
          ..write('id: $id, ')
          ..write('showAds: $showAds, ')
          ..write('showNotification: $showNotification')
          ..write(')'))
        .toString();
  }
}

class $PreferencesTable extends Preferences
    with TableInfo<$PreferencesTable, Preference> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PreferencesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _isOnboardingCompletedMeta =
      const VerificationMeta('isOnboardingCompleted');
  @override
  late final GeneratedColumn<bool> isOnboardingCompleted =
      GeneratedColumn<bool>(
        'is_onboarding_completed',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_onboarding_completed" IN (0, 1))',
        ),
        defaultValue: const Constant(false),
      );
  @override
  List<GeneratedColumn> get $columns => [id, isOnboardingCompleted];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'preferences';
  @override
  VerificationContext validateIntegrity(
    Insertable<Preference> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('is_onboarding_completed')) {
      context.handle(
        _isOnboardingCompletedMeta,
        isOnboardingCompleted.isAcceptableOrUnknown(
          data['is_onboarding_completed']!,
          _isOnboardingCompletedMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Preference map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Preference(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      isOnboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_onboarding_completed'],
      )!,
    );
  }

  @override
  $PreferencesTable createAlias(String alias) {
    return $PreferencesTable(attachedDatabase, alias);
  }
}

class Preference extends DataClass implements Insertable<Preference> {
  final int id;
  final bool isOnboardingCompleted;
  const Preference({required this.id, required this.isOnboardingCompleted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['is_onboarding_completed'] = Variable<bool>(isOnboardingCompleted);
    return map;
  }

  PreferencesCompanion toCompanion(bool nullToAbsent) {
    return PreferencesCompanion(
      id: Value(id),
      isOnboardingCompleted: Value(isOnboardingCompleted),
    );
  }

  factory Preference.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Preference(
      id: serializer.fromJson<int>(json['id']),
      isOnboardingCompleted: serializer.fromJson<bool>(
        json['isOnboardingCompleted'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'isOnboardingCompleted': serializer.toJson<bool>(isOnboardingCompleted),
    };
  }

  Preference copyWith({int? id, bool? isOnboardingCompleted}) => Preference(
    id: id ?? this.id,
    isOnboardingCompleted: isOnboardingCompleted ?? this.isOnboardingCompleted,
  );
  Preference copyWithCompanion(PreferencesCompanion data) {
    return Preference(
      id: data.id.present ? data.id.value : this.id,
      isOnboardingCompleted: data.isOnboardingCompleted.present
          ? data.isOnboardingCompleted.value
          : this.isOnboardingCompleted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Preference(')
          ..write('id: $id, ')
          ..write('isOnboardingCompleted: $isOnboardingCompleted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, isOnboardingCompleted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Preference &&
          other.id == this.id &&
          other.isOnboardingCompleted == this.isOnboardingCompleted);
}

class PreferencesCompanion extends UpdateCompanion<Preference> {
  final Value<int> id;
  final Value<bool> isOnboardingCompleted;
  const PreferencesCompanion({
    this.id = const Value.absent(),
    this.isOnboardingCompleted = const Value.absent(),
  });
  PreferencesCompanion.insert({
    this.id = const Value.absent(),
    this.isOnboardingCompleted = const Value.absent(),
  });
  static Insertable<Preference> custom({
    Expression<int>? id,
    Expression<bool>? isOnboardingCompleted,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (isOnboardingCompleted != null)
        'is_onboarding_completed': isOnboardingCompleted,
    });
  }

  PreferencesCompanion copyWith({
    Value<int>? id,
    Value<bool>? isOnboardingCompleted,
  }) {
    return PreferencesCompanion(
      id: id ?? this.id,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (isOnboardingCompleted.present) {
      map['is_onboarding_completed'] = Variable<bool>(
        isOnboardingCompleted.value,
      );
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PreferencesCompanion(')
          ..write('id: $id, ')
          ..write('isOnboardingCompleted: $isOnboardingCompleted')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ThemeSettingsTable themeSettings = $ThemeSettingsTable(this);
  late final $FeatureFlagsTable featureFlags = $FeatureFlagsTable(this);
  late final $PreferencesTable preferences = $PreferencesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    themeSettings,
    featureFlags,
    preferences,
  ];
}

typedef $$ThemeSettingsTableCreateCompanionBuilder =
    ThemeSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<FlexScheme> flexSchemeEnum,
      Value<FlexSchemeColor?> flexSchemeColor,
      Value<String> fontFamily,
      Value<double> textScaleFactor,
      Value<String> locale,
    });
typedef $$ThemeSettingsTableUpdateCompanionBuilder =
    ThemeSettingsCompanion Function({
      Value<int> id,
      Value<ThemeMode> themeMode,
      Value<FlexScheme> flexSchemeEnum,
      Value<FlexSchemeColor?> flexSchemeColor,
      Value<String> fontFamily,
      Value<double> textScaleFactor,
      Value<String> locale,
    });

class $$ThemeSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<ThemeMode, ThemeMode, int> get themeMode =>
      $composableBuilder(
        column: $table.themeMode,
        builder: (column) => ColumnWithTypeConverterFilters(column),
      );

  ColumnWithTypeConverterFilters<FlexScheme, FlexScheme, int>
  get flexSchemeEnum => $composableBuilder(
    column: $table.flexSchemeEnum,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnWithTypeConverterFilters<FlexSchemeColor?, FlexSchemeColor, String>
  get flexSchemeColor => $composableBuilder(
    column: $table.flexSchemeColor,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get textScaleFactor => $composableBuilder(
    column: $table.textScaleFactor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ThemeSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get themeMode => $composableBuilder(
    column: $table.themeMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get flexSchemeEnum => $composableBuilder(
    column: $table.flexSchemeEnum,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get flexSchemeColor => $composableBuilder(
    column: $table.flexSchemeColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get textScaleFactor => $composableBuilder(
    column: $table.textScaleFactor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get locale => $composableBuilder(
    column: $table.locale,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ThemeSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ThemeSettingsTable> {
  $$ThemeSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<ThemeMode, int> get themeMode =>
      $composableBuilder(column: $table.themeMode, builder: (column) => column);

  GeneratedColumnWithTypeConverter<FlexScheme, int> get flexSchemeEnum =>
      $composableBuilder(
        column: $table.flexSchemeEnum,
        builder: (column) => column,
      );

  GeneratedColumnWithTypeConverter<FlexSchemeColor?, String>
  get flexSchemeColor => $composableBuilder(
    column: $table.flexSchemeColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fontFamily => $composableBuilder(
    column: $table.fontFamily,
    builder: (column) => column,
  );

  GeneratedColumn<double> get textScaleFactor => $composableBuilder(
    column: $table.textScaleFactor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get locale =>
      $composableBuilder(column: $table.locale, builder: (column) => column);
}

class $$ThemeSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ThemeSettingsTable,
          ThemeSetting,
          $$ThemeSettingsTableFilterComposer,
          $$ThemeSettingsTableOrderingComposer,
          $$ThemeSettingsTableAnnotationComposer,
          $$ThemeSettingsTableCreateCompanionBuilder,
          $$ThemeSettingsTableUpdateCompanionBuilder,
          (
            ThemeSetting,
            BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
          ),
          ThemeSetting,
          PrefetchHooks Function()
        > {
  $$ThemeSettingsTableTableManager(_$AppDatabase db, $ThemeSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ThemeSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ThemeSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ThemeSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<FlexScheme> flexSchemeEnum = const Value.absent(),
                Value<FlexSchemeColor?> flexSchemeColor = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<double> textScaleFactor = const Value.absent(),
                Value<String> locale = const Value.absent(),
              }) => ThemeSettingsCompanion(
                id: id,
                themeMode: themeMode,
                flexSchemeEnum: flexSchemeEnum,
                flexSchemeColor: flexSchemeColor,
                fontFamily: fontFamily,
                textScaleFactor: textScaleFactor,
                locale: locale,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<ThemeMode> themeMode = const Value.absent(),
                Value<FlexScheme> flexSchemeEnum = const Value.absent(),
                Value<FlexSchemeColor?> flexSchemeColor = const Value.absent(),
                Value<String> fontFamily = const Value.absent(),
                Value<double> textScaleFactor = const Value.absent(),
                Value<String> locale = const Value.absent(),
              }) => ThemeSettingsCompanion.insert(
                id: id,
                themeMode: themeMode,
                flexSchemeEnum: flexSchemeEnum,
                flexSchemeColor: flexSchemeColor,
                fontFamily: fontFamily,
                textScaleFactor: textScaleFactor,
                locale: locale,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ThemeSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ThemeSettingsTable,
      ThemeSetting,
      $$ThemeSettingsTableFilterComposer,
      $$ThemeSettingsTableOrderingComposer,
      $$ThemeSettingsTableAnnotationComposer,
      $$ThemeSettingsTableCreateCompanionBuilder,
      $$ThemeSettingsTableUpdateCompanionBuilder,
      (
        ThemeSetting,
        BaseReferences<_$AppDatabase, $ThemeSettingsTable, ThemeSetting>,
      ),
      ThemeSetting,
      PrefetchHooks Function()
    >;
typedef $$FeatureFlagsTableCreateCompanionBuilder =
    FeatureFlagsCompanion Function({
      Value<int> id,
      Value<bool> showAds,
      Value<bool> showNotification,
    });
typedef $$FeatureFlagsTableUpdateCompanionBuilder =
    FeatureFlagsCompanion Function({
      Value<int> id,
      Value<bool> showAds,
      Value<bool> showNotification,
    });

class $$FeatureFlagsTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showAds => $composableBuilder(
    column: $table.showAds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureFlagsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showAds => $composableBuilder(
    column: $table.showAds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureFlagsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureFlagsTable> {
  $$FeatureFlagsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get showAds =>
      $composableBuilder(column: $table.showAds, builder: (column) => column);

  GeneratedColumn<bool> get showNotification => $composableBuilder(
    column: $table.showNotification,
    builder: (column) => column,
  );
}

class $$FeatureFlagsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeatureFlagsTable,
          FeatureFlag,
          $$FeatureFlagsTableFilterComposer,
          $$FeatureFlagsTableOrderingComposer,
          $$FeatureFlagsTableAnnotationComposer,
          $$FeatureFlagsTableCreateCompanionBuilder,
          $$FeatureFlagsTableUpdateCompanionBuilder,
          (
            FeatureFlag,
            BaseReferences<_$AppDatabase, $FeatureFlagsTable, FeatureFlag>,
          ),
          FeatureFlag,
          PrefetchHooks Function()
        > {
  $$FeatureFlagsTableTableManager(_$AppDatabase db, $FeatureFlagsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureFlagsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureFlagsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FeatureFlagsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> showAds = const Value.absent(),
                Value<bool> showNotification = const Value.absent(),
              }) => FeatureFlagsCompanion(
                id: id,
                showAds: showAds,
                showNotification: showNotification,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> showAds = const Value.absent(),
                Value<bool> showNotification = const Value.absent(),
              }) => FeatureFlagsCompanion.insert(
                id: id,
                showAds: showAds,
                showNotification: showNotification,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeatureFlagsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeatureFlagsTable,
      FeatureFlag,
      $$FeatureFlagsTableFilterComposer,
      $$FeatureFlagsTableOrderingComposer,
      $$FeatureFlagsTableAnnotationComposer,
      $$FeatureFlagsTableCreateCompanionBuilder,
      $$FeatureFlagsTableUpdateCompanionBuilder,
      (
        FeatureFlag,
        BaseReferences<_$AppDatabase, $FeatureFlagsTable, FeatureFlag>,
      ),
      FeatureFlag,
      PrefetchHooks Function()
    >;
typedef $$PreferencesTableCreateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<bool> isOnboardingCompleted,
    });
typedef $$PreferencesTableUpdateCompanionBuilder =
    PreferencesCompanion Function({
      Value<int> id,
      Value<bool> isOnboardingCompleted,
    });

class $$PreferencesTableFilterComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PreferencesTableOrderingComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PreferencesTableAnnotationComposer
    extends Composer<_$AppDatabase, $PreferencesTable> {
  $$PreferencesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<bool> get isOnboardingCompleted => $composableBuilder(
    column: $table.isOnboardingCompleted,
    builder: (column) => column,
  );
}

class $$PreferencesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PreferencesTable,
          Preference,
          $$PreferencesTableFilterComposer,
          $$PreferencesTableOrderingComposer,
          $$PreferencesTableAnnotationComposer,
          $$PreferencesTableCreateCompanionBuilder,
          $$PreferencesTableUpdateCompanionBuilder,
          (
            Preference,
            BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
          ),
          Preference,
          PrefetchHooks Function()
        > {
  $$PreferencesTableTableManager(_$AppDatabase db, $PreferencesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PreferencesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PreferencesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PreferencesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isOnboardingCompleted = const Value.absent(),
              }) => PreferencesCompanion(
                id: id,
                isOnboardingCompleted: isOnboardingCompleted,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<bool> isOnboardingCompleted = const Value.absent(),
              }) => PreferencesCompanion.insert(
                id: id,
                isOnboardingCompleted: isOnboardingCompleted,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PreferencesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PreferencesTable,
      Preference,
      $$PreferencesTableFilterComposer,
      $$PreferencesTableOrderingComposer,
      $$PreferencesTableAnnotationComposer,
      $$PreferencesTableCreateCompanionBuilder,
      $$PreferencesTableUpdateCompanionBuilder,
      (
        Preference,
        BaseReferences<_$AppDatabase, $PreferencesTable, Preference>,
      ),
      Preference,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ThemeSettingsTableTableManager get themeSettings =>
      $$ThemeSettingsTableTableManager(_db, _db.themeSettings);
  $$FeatureFlagsTableTableManager get featureFlags =>
      $$FeatureFlagsTableTableManager(_db, _db.featureFlags);
  $$PreferencesTableTableManager get preferences =>
      $$PreferencesTableTableManager(_db, _db.preferences);
}
