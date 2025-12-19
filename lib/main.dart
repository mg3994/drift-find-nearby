import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:findnearby/core/database/app_database.dart';
import 'package:findnearby/core/repositories/app_settings_repository.dart';
import 'package:findnearby/core/repositories/feature_flags_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final AppDatabase db = AppDatabase();

  // Ensure singleton rows exist before starting watchers in repositories
  await db.getThemeSettings();
  await db.getFeatureFlags();

  final AppSettingsRepository settingsRepo = AppSettingsRepositoryImpl(db);
  final FeatureFlagsRepository flagsRepo = FeatureFlagsRepositoryImpl(db);

  runApp(MyApp(settingsRepo: settingsRepo, flagsRepo: flagsRepo));
}

class MyApp extends StatelessWidget {
  final AppSettingsRepository settingsRepo;
  final FeatureFlagsRepository flagsRepo;

  const MyApp({super.key, required this.settingsRepo, required this.flagsRepo});

  @override
  Widget build(BuildContext context) {
    // Watch the settings signal to update the theme reactively
    final settings = settingsRepo.settingsSignal.watch(context);

    // Now uses ThemeMode directly from settings
    final themeMode = settings?.themeMode ?? ThemeMode.system;

    return MaterialApp(
      title: 'Settings Demo',
      themeMode: themeMode,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.deepPurple,
        brightness: Brightness.dark,
      ),
      home: SettingsScreen(settingsRepo: settingsRepo, flagsRepo: flagsRepo),
    );
  }
}

class SettingsScreen extends StatelessWidget {
  final AppSettingsRepository settingsRepo;
  final FeatureFlagsRepository flagsRepo;

  const SettingsScreen({
    super.key,
    required this.settingsRepo,
    required this.flagsRepo,
  });

  @override
  Widget build(BuildContext context) {
    final settings = settingsRepo.settingsSignal.watch(context);
    final flags = flagsRepo.flagsSignal.watch(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Separate Tables & Signals'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _SectionHeader(title: 'Theme Settings (Context)'),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Theme Mode'),
                  subtitle: Text(_themeModeName(settings?.themeMode)),
                  trailing: SegmentedButton<ThemeMode>(
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Sys'),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Light'),
                      ),
                      ButtonSegment(value: ThemeMode.dark, label: Text('Dark')),
                    ],
                    selected: {settings?.themeMode ?? ThemeMode.system},
                    onSelectionChanged: (value) {
                      settingsRepo.updateThemeMode(value.first);
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Font Family'),
                  subtitle: Text(settings?.fontFamily ?? 'Roboto'),
                ),
                ListTile(
                  title: const Text('Locale'),
                  subtitle: Text(settings?.locale ?? 'en'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SectionHeader(title: 'Feature Flags (No Context)'),
          Card(
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Show Ads'),
                  subtitle: const Text(
                    'Managed separately in FeatureFlags table',
                  ),
                  value: flags?.showAds ?? true,
                  onChanged: (value) {
                    flagsRepo.toggleAds(value);
                  },
                ),
                SwitchListTile(
                  title: const Text('Show Notifications'),
                  subtitle: const Text('Independent of theme changes'),
                  value: flags?.showNotification ?? false,
                  onChanged: (value) {
                    flagsRepo.toggleNotifications(value);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              'Notice: Toggling Feature Flags does not rebuild the Theme section, and vice-versa, thanks to separate Signals and Tables.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _themeModeName(ThemeMode? mode) {
    return switch (mode) {
      ThemeMode.light => 'Light Mode',
      ThemeMode.dark => 'Dark Mode',
      _ => 'System Default',
    };
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, bottom: 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
