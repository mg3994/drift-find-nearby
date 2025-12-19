import 'package:flutter/material.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:findnearby/core/theme/app_theme.dart';
import 'package:findnearby/core/database/app_database.dart';
import 'package:findnearby/core/repositories/app_settings_repository.dart';
import 'package:findnearby/core/repositories/feature_flags_repository.dart';
import 'package:findnearby/l10n/app_localizations.dart';

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

    final themeMode = settings?.themeMode ?? ThemeMode.system;
    final flexScheme = settings?.flexSchemeEnum ;//?? FlexScheme.material;
    final flexSchemeColor = settings?.flexSchemeColor;
    final fontBuilder = settingsRepo.getFontBuilder(settings?.fontFamily);
    final locale = settings?.locale != null
        ? Locale(settings!.locale)
        : const Locale('en');

    return MaterialApp(
      title: 'Settings Demo',
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
                  title: const Text('Theme Scheme'),
                  subtitle: Text(settings?.flexSchemeEnum.name ?? 'Default'),
                  trailing: DropdownButton<FlexScheme>(
                    value: settings?.flexSchemeEnum ?? FlexScheme.material,
                    onChanged: (value) {
                      if (value != null) {
                        settingsRepo.updateFlexScheme(value);
                      }
                    },
                    items: FlexScheme.values.map((scheme) {
                      return DropdownMenuItem(
                        value: scheme,
                        child: Text(scheme.name),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Font Family'),
                  subtitle: Text(settings?.fontFamily ?? 'Roboto'),
                  trailing: DropdownButton<String>(
                    value: settings?.fontFamily ?? 'Roboto',
                    onChanged: (value) {
                      if (value != null) {
                        settingsRepo.updateFontFamily(value);
                      }
                    },
                    items: ['Roboto', 'Inter', 'Lato', 'Open Sans', 'Poppins']
                        .map((font) {
                          return DropdownMenuItem(
                            value: font,
                            child: Text(font),
                          );
                        })
                        .toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Locale (Language)'),
                  subtitle: Text(settings?.locale ?? 'en'),
                  trailing: DropdownButton<String>(
                    value: settings?.locale ?? 'en',
                    onChanged: (value) {
                      if (value != null) {
                        settingsRepo.updateLocale(value);
                      }
                    },
                    items: AppLocalizations.supportedLocales.map((locale) {
                      return DropdownMenuItem(
                        value: locale.languageCode,
                        child: Text(locale.languageCode.toUpperCase()),
                      );
                    }).toList(),
                  ),
                ),
                ListTile(
                  title: const Text('Text Scale Factor'),
                  subtitle: Text(
                    (settings?.textScaleFactor ?? 1.0).toStringAsFixed(2),
                  ),
                  trailing: Container(
                    width: 200,
                    child: Slider(
                      value: settings?.textScaleFactor ?? 1.0,
                      min: 0.5,
                      max: 2.0,
                      divisions: 15,
                      label: settings?.textScaleFactor.toStringAsFixed(2),
                      onChanged: (value) {
                        settingsRepo.updateTextScaleFactor(value);
                      },
                    ),
                  ),
                ),
                if (settings?.flexSchemeEnum == FlexScheme.custom) ...[
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Text(
                      'Custom Theme Colors',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  _CustomColorPicker(
                    label: 'Primary Color',
                    color: settings?.flexSchemeColor?.primary ?? Colors.blue,
                    onColorChanged: (color) {
                      final current =
                          settings?.flexSchemeColor ??
                          const FlexSchemeColor(
                            primary: Colors.blue,
                            primaryContainer: Colors.blueAccent,
                            secondary: Colors.orange,
                            secondaryContainer: Colors.orangeAccent,
                          );
                      settingsRepo.updateFlexSchemeColor(
                        current.copyWith(primary: color),
                      );
                    },
                  ),
                  _CustomColorPicker(
                    label: 'Secondary Color',
                    color:
                        settings?.flexSchemeColor?.secondary ?? Colors.orange,
                    onColorChanged: (color) {
                      final current =
                          settings?.flexSchemeColor ??
                          const FlexSchemeColor(
                            primary: Colors.blue,
                            primaryContainer: Colors.blueAccent,
                            secondary: Colors.orange,
                            secondaryContainer: Colors.orangeAccent,
                          );
                      settingsRepo.updateFlexSchemeColor(
                        current.copyWith(secondary: color),
                      );
                    },
                  ),
                ],
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

class _CustomColorPicker extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onColorChanged;

  const _CustomColorPicker({
    required this.label,
    required this.color,
    required this.onColorChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colors = [
      Colors.red,
      Colors.pink,
      Colors.purple,
      Colors.deepPurple,
      Colors.indigo,
      Colors.blue,
      Colors.lightBlue,
      Colors.cyan,
      Colors.teal,
      Colors.green,
      Colors.lightGreen,
      Colors.lime,
      Colors.yellow,
      Colors.amber,
      Colors.orange,
      Colors.deepOrange,
      Colors.brown,
      Colors.grey,
      Colors.blueGrey,
    ];

    return ListTile(
      title: Text(label),
      subtitle: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: colors.map((c) {
          return InkWell(
            onTap: () => onColorChanged(c),
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: c,
                shape: BoxShape.circle,
                border: Border.all(
                  color: c == color ? Colors.black : Colors.transparent,
                  width: 2,
                ),
                boxShadow: [
                  if (c == color)
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
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
