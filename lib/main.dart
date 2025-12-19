import 'dart:async';
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
    final flexScheme = settings?.flexSchemeEnum; //?? FlexScheme.material;
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

class SettingsScreen extends StatefulWidget {
  final AppSettingsRepository settingsRepo;
  final FeatureFlagsRepository flagsRepo;

  const SettingsScreen({
    super.key,
    required this.settingsRepo,
    required this.flagsRepo,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  double? _localTextScale;
  Timer? _debounceTimer;

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = widget.settingsRepo.settingsSignal.watch(context);
    final flags = widget.flagsRepo.flagsSignal.watch(context);
    final isSettingsLoading = widget.settingsRepo.isLoading.watch(context);
    final isFlagsLoading = widget.flagsRepo.isLoading.watch(context);

    final isLoading = isSettingsLoading || isFlagsLoading;

    // Initialize local scale if it's null
    if (_localTextScale == null && settings != null) {
      _localTextScale = settings.textScaleFactor;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Separate Tables & Signals'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          ListView(
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
                          ButtonSegment(
                            value: ThemeMode.dark,
                            label: Text('Dark'),
                          ),
                        ],
                        selected: {settings?.themeMode ?? ThemeMode.system},
                        onSelectionChanged: (value) {
                          widget.settingsRepo.updateThemeMode(value.first);
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Theme Scheme'),
                      subtitle: Text(
                        settings?.flexSchemeEnum.name ?? 'Default',
                      ),
                      trailing: DropdownButton<FlexScheme>(
                        value: settings?.flexSchemeEnum ?? FlexScheme.material,
                        onChanged: (value) {
                          if (value != null) {
                            widget.settingsRepo.updateFlexScheme(value);
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
                            widget.settingsRepo.updateFontFamily(value);
                          }
                        },
                        items:
                            [
                              'Roboto',
                              'Inter',
                              'Lato',
                              'Open Sans',
                              'Poppins',
                            ].map((font) {
                              return DropdownMenuItem(
                                value: font,
                                child: Text(font),
                              );
                            }).toList(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Locale (Language)'),
                      subtitle: Text(() {
                        final localeCode = settings?.locale ?? 'en';
                        final l10n = lookupAppLocalizations(Locale(localeCode));
                        return '${l10n.langauge_flag} ${l10n.language}';
                      }()),
                      trailing: DropdownButton<String>(
                        value: settings?.locale ?? 'en',
                        onChanged: (value) {
                          if (value != null) {
                            widget.settingsRepo.updateLocale(value);
                          }
                        },
                        items: AppLocalizations.supportedLocales.map((locale) {
                          final l10n = lookupAppLocalizations(locale);
                          return DropdownMenuItem(
                            value: locale.languageCode,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(l10n.langauge_flag),
                                const SizedBox(width: 8),
                                Text(l10n.language),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                    ListTile(
                      title: const Text('Text Scale Factor'),
                      subtitle: Text(
                        (_localTextScale ?? 1.0).toStringAsFixed(2),
                      ),
                      trailing: SizedBox(
                        width: 200,
                        child: Slider(
                          value: _localTextScale ?? 1.0,
                          min: 0.5,
                          max: 2.0,
                          divisions: 15,
                          label: (_localTextScale ?? 1.0).toStringAsFixed(2),
                          onChanged: (value) {
                            setState(() {
                              _localTextScale = value;
                            });
                            _debounceTimer?.cancel();
                            _debounceTimer = Timer(
                              const Duration(milliseconds: 500),
                              () {
                                widget.settingsRepo.updateTextScaleFactor(
                                  value,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    if (settings?.flexSchemeEnum == FlexScheme.custom) ...[
                      const Divider(),
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Custom Theme Colors',
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Fine-tune your custom theme colors below.',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ),
                      _CustomColorGrid(
                        color:
                            settings?.flexSchemeColor ??
                            AppTheme.defaultScheme.colors(
                              Theme.of(context).brightness,
                            ),
                        onChanged: (updatedColor) {
                          widget.settingsRepo.updateFlexSchemeColor(
                            updatedColor,
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
                        widget.flagsRepo.toggleAds(value);
                      },
                    ),
                    SwitchListTile(
                      title: const Text('Show Notifications'),
                      subtitle: const Text('Independent of theme changes'),
                      value: flags?.showNotification ?? false,
                      onChanged: (value) {
                        widget.flagsRepo.toggleNotifications(value);
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
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withValues(alpha: 0.1),
                child: Center(
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 16),
                          Text('Updating settings...'),
                        ],
                      ),
                    ),
                  ),
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

class _CustomColorGrid extends StatelessWidget {
  final FlexSchemeColor color;
  final ValueChanged<FlexSchemeColor> onChanged;

  const _CustomColorGrid({required this.color, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          _ColorRow(
            label: 'Primary',
            color: color.primary,
            onChanged: (c) => onChanged(color.copyWith(primary: c)),
            containerColor: color.primaryContainer,
            onContainerChanged: (c) =>
                onChanged(color.copyWith(primaryContainer: c)),
          ),
          const SizedBox(height: 12),
          _ColorRow(
            label: 'Secondary',
            color: color.secondary,
            onChanged: (c) => onChanged(color.copyWith(secondary: c)),
            containerColor: color.secondaryContainer,
            onContainerChanged: (c) =>
                onChanged(color.copyWith(secondaryContainer: c)),
          ),
          const SizedBox(height: 12),
          _ColorRow(
            label: 'Tertiary',
            color: color.tertiary,
            onChanged: (c) => onChanged(color.copyWith(tertiary: c)),
            containerColor: color.tertiaryContainer,
            onContainerChanged: (c) =>
                onChanged(color.copyWith(tertiaryContainer: c)),
          ),
          const SizedBox(height: 12),
          _ColorRow(
            label: 'Error',
            color: color.error ?? scheme.error,
            onChanged: (c) => onChanged(color.copyWith(error: c)),
            containerColor: color.errorContainer ?? scheme.errorContainer,
            onContainerChanged: (c) =>
                onChanged(color.copyWith(errorContainer: c)),
          ),
          const SizedBox(height: 12),
          _SingleColorRow(
            label: 'AppBar',
            color: color.appBarColor ?? scheme.primary,
            onChanged: (c) => onChanged(color.copyWith(appBarColor: c)),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _ColorRow extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;
  final Color containerColor;
  final ValueChanged<Color> onContainerChanged;

  const _ColorRow({
    required this.label,
    required this.color,
    required this.onChanged,
    required this.containerColor,
    required this.onContainerChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _ColorPickerButton(
                color: color,
                label: 'Main',
                onChanged: onChanged,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ColorPickerButton(
                color: containerColor,
                label: 'Container',
                onChanged: onContainerChanged,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _SingleColorRow extends StatelessWidget {
  final String label;
  final Color color;
  final ValueChanged<Color> onChanged;

  const _SingleColorRow({
    required this.label,
    required this.color,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: Theme.of(context).textTheme.labelMedium),
        const SizedBox(height: 8),
        _ColorPickerButton(
          color: color,
          label: 'Default',
          onChanged: onChanged,
        ),
      ],
    );
  }
}

class _ColorPickerButton extends StatelessWidget {
  final Color color;
  final String label;
  final ValueChanged<Color> onChanged;

  const _ColorPickerButton({
    required this.color,
    required this.label,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => _ColorPickerDialog(
            initialColor: color,
            onColorChanged: onChanged,
          ),
        );
      },
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).colorScheme.outlineVariant,
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color.computeLuminance() > 0.5
                  ? Colors.black
                  : Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorChanged;

  const _ColorPickerDialog({
    required this.initialColor,
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
      Colors.black,
    ];

    return AlertDialog(
      title: const Text('Pick a Color'),
      content: SingleChildScrollView(
        child: Wrap(
          spacing: 8,
          runSpacing: 8,
          children: colors.map((c) {
            final isSelected = c.toARGB32() == initialColor.toARGB32();
            return InkWell(
              onTap: () {
                onColorChanged(c);
                Navigator.of(context).pop();
              },
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: c,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? Colors.black : Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: c.computeLuminance() > 0.5
                            ? Colors.black
                            : Colors.white,
                      )
                    : null,
              ),
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
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
