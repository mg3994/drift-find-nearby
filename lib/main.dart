import 'dart:async';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/material.dart' as material show Colors;
import 'package:signals_flutter/signals_flutter.dart';
import 'package:findnearby/core/theme/app_theme.dart';
import 'package:findnearby/core/database/app_database.dart';
import 'package:findnearby/core/repositories/app_settings_repository.dart';
import 'package:findnearby/core/repositories/feature_flags_repository.dart';
import 'package:findnearby/core/repositories/preferences_repository.dart';
import 'package:findnearby/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:findnearby/features/onboarding/presentation/viewmodels/onboarding_view_model.dart';
import 'package:findnearby/features/home/presentation/viewmodels/home_view_model.dart';
import 'package:findnearby/core/router/app_router.dart';
import 'package:findnearby/l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase db = AppDatabase();

  // Ensure singleton rows exist before starting watchers in repositories
  await db.getThemeSettings();
  await db.getFeatureFlags();
  await db.getPreferences();

  final AppSettingsRepository settingsRepo = AppSettingsRepositoryImpl(db);
  final FeatureFlagsRepository flagsRepo = FeatureFlagsRepositoryImpl(db);
  final PreferencesRepository preferencesRepo = PreferencesRepositoryImpl(db);

  final authViewModel = AuthViewModel();
  final onboardingViewModel = OnboardingViewModel(preferencesRepo);
  final homeViewModel = HomeViewModel();

  runApp(MyApp(
    settingsRepo: settingsRepo,
    flagsRepo: flagsRepo,
    preferencesRepo: preferencesRepo,
    authViewModel: authViewModel,
    onboardingViewModel: onboardingViewModel,
    homeViewModel: homeViewModel,
    client: null, // client is stubbed for now
  ));
}

class MyApp extends StatelessWidget {
  final AppSettingsRepository settingsRepo;
  final FeatureFlagsRepository flagsRepo;
  final PreferencesRepository preferencesRepo;
  final AuthViewModel authViewModel;
  final OnboardingViewModel onboardingViewModel;
  final HomeViewModel homeViewModel;
  final dynamic client;

  const MyApp({
    super.key,
    required this.settingsRepo,
    required this.flagsRepo,
    required this.preferencesRepo,
    required this.authViewModel,
    required this.onboardingViewModel,
    required this.homeViewModel,
    this.client,
  });

  @override
  Widget build(BuildContext context) {
    // Watch the settings signal to update the theme reactively
    final settings = settingsRepo.settingsSignal.watch(context);

    final themeMode = settings?.themeMode ?? ThemeMode.system;
    final flexScheme = settings?.flexSchemeEnum;
    final flexSchemeColor = settings?.flexSchemeColor;
    final fontBuilder = settingsRepo.getFontBuilder(settings?.fontFamily);
    final locale = settings?.locale != null
        ? Locale(settings!.locale)
        : const Locale('en');

    return MaterialApp.router(
      title: 'FindNearby',
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
      routerConfig: createRouter(
        authViewModel: authViewModel,
        onboardingViewModel: onboardingViewModel,
        settingsRepo: settingsRepo,
        flagsRepo: flagsRepo,
        client: client,
      ),
    );
  }
}
