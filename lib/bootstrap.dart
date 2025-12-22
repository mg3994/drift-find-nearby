import 'dart:async' show FutureOr;

import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart' show FlutterReadonlySignalUtils;

import 'core/config/app_config.dart' show AppConfig;
import 'core/config/config.dart' show FlavorConfig;
import 'core/database/app_database.dart' show AppDatabase;
import 'core/repositories/app_settings_repository.dart'
    show AppSettingsRepository, AppSettingsRepositoryImpl;
import 'core/repositories/feature_flags_repository.dart'
    show FeatureFlagsRepository, FeatureFlagsRepositoryImpl;
import 'core/repositories/preferences_repository.dart'
    show PreferencesRepository, PreferencesRepositoryImpl;
import 'core/repositories/user_presence_repository.dart'
    show UserPresenceRepository, UserPresenceRepositoryImpl;
import 'core/theme/app_theme.dart' show AppTheme;
import 'l10n/app_localizations.dart';

Future<void> runAppAsync(
  FutureOr<Widget> Function(WidgetsBinding, FlavorConfig) builder,
) async {
  final binding = WidgetsFlutterBinding.ensureInitialized();
  binding.deferFirstFrame();
  // 1. Load the JSON config
  final appConfig = await AppConfig.loadConfig();
  final flavorConfig = FlavorConfig(jsonUrl: appConfig.apiUrl);
  runApp(await builder(binding, flavorConfig));
}

class Bootstrap extends StatefulWidget {
  final WidgetsBinding binding;
  final FlavorConfig flavorConfig;
  const Bootstrap({
    super.key,
    required this.binding,
    required this.flavorConfig,
  });

  @override
  State<Bootstrap> createState() => _BootstrapState();
}

class _BootstrapState extends State<Bootstrap> {
  static final AppDatabase db = AppDatabase.instance();
  final AppSettingsRepository settingsRepo = AppSettingsRepositoryImpl(db);
  final FeatureFlagsRepository flagsRepo = FeatureFlagsRepositoryImpl(db);
  final PreferencesRepository preferencesRepo = PreferencesRepositoryImpl(db);
  final UserPresenceRepository userPresenceRepo = UserPresenceRepositoryImpl(
    db,
  );

  @override
  void initState() {
    initCall();
    super.initState();
  }

  void initCall() async {
    try {
      // Ensure singleton rows exist before starting watchers in repositories
      await db.getThemeSettings();
      await db.getFeatureFlags();
      await db.getPreferences();
      await db.getUserPresence();
    } finally {
      widget.binding.allowFirstFrame();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Watch the settings signal to update the theme reactively
    final settings = settingsRepo.settingsSignal.watch(context);

    final themeMode = settings?.themeMode ?? ThemeMode.system;
    final flexScheme = settings
        ?.flexSchemeEnum; //?? FlexScheme.material; // No need AppTheme will handle fallback case
    final flexSchemeColor = settings?.flexSchemeColor;
    final fontBuilder = settingsRepo.getFontBuilder(settings?.fontFamily);
    final locale = settings?.locale != null
        ? Locale(settings!.locale)
        : AppLocalizations.supportedLocales.first;

    return MaterialApp.router(
      onGenerateTitle: (context) => AppLocalizations.of(context)!.appTitle,
      // routerConfig: routerConfig,
      themeMode: themeMode,
      theme: AppTheme.light(
        flexSchemeEnum: flexScheme,
        flexSchemeColor: flexSchemeColor,
        fontTextThemeBuilder: fontBuilder,
      ),
      darkTheme: AppTheme.dark(
        flexSchemeEnum: flexScheme,
        flexSchemeColor: flexSchemeColor,
        fontTextThemeBuilder: fontBuilder,
      ),
      locale: locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        final scale = settings?.textScaleFactor ?? 1.0;
        return MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(textScaler: TextScaler.linear(scale)),
          child: child!,
        );
      },
    );
  }
}
