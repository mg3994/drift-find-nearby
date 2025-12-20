import 'dart:async';
import 'package:flutter/material.dart' hide Colors;
import 'package:flutter/material.dart' as material show Colors;
import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:findnearby/core/repositories/app_settings_repository.dart';
import 'package:findnearby/core/repositories/feature_flags_repository.dart';

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
    // Watch relevant signals to rebuild when data changes
    final settings = widget.settingsRepo.settingsSignal.watch(context);
    final flags = widget.flagsRepo.flagsSignal.watch(context);

    final isSettingsLoading = widget.settingsRepo.isLoading.watch(context);
    final isFlagsLoading = widget.flagsRepo.isLoading.watch(context);
    final isLoading = isSettingsLoading || isFlagsLoading;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          if (isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
        ],
      ),
      body: Stack(
        children: [
          ListView(
            children: [
              _SectionHeader(title: 'Theme & Appearance'),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Theme Mode'),
                      subtitle: Text(_themeModeName(settings?.themeMode)),
                      trailing: const Icon(Icons.brightness_medium),
                      onTap: () {
                        final next = switch (settings?.themeMode) {
                          ThemeMode.system => ThemeMode.light,
                          ThemeMode.light => ThemeMode.dark,
                          _ => ThemeMode.system,
                        };
                        widget.settingsRepo.updateThemeMode(next);
                      },
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text('Color Scheme'),
                      subtitle: Text(
                        settings?.flexSchemeEnum?.name ?? 'Custom',
                      ),
                      trailing: const Icon(Icons.palette),
                      onTap: () {
                        // Cycles through a few schemes for demo
                        final current = settings?.flexSchemeEnum;
                        final next = switch (current) {
                          FlexScheme.material => FlexScheme.mandyRed,
                          FlexScheme.mandyRed => FlexScheme.brandBlue,
                          _ => FlexScheme.material,
                        };
                        widget.settingsRepo.updateFlexScheme(next);
                      },
                    ),
                    if (settings?.flexSchemeEnum == null) ...[
                      const Divider(),
                      _CustomColorGrid(
                        color:
                            settings?.flexSchemeColor ??
                            const FlexSchemeColor(
                              primary: material.Colors.teal,
                              primaryContainer: material.Colors.tealAccent,
                              secondary: material.Colors.red,
                              secondaryContainer: material.Colors.redAccent,
                            ),
                        onChanged: (newColor) {
                          widget.settingsRepo.updateCustomColors(newColor);
                        },
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Typography'),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    ListTile(
                      title: const Text('Font Family'),
                      subtitle: Text(settings?.fontFamily ?? 'System Default'),
                      trailing: const Icon(Icons.font_download),
                      onTap: () {
                        final current = settings?.fontFamily;
                        final next = switch (current) {
                          'Inter' => 'Roboto',
                          'Roboto' => 'Outfit',
                          _ => 'Inter',
                        };
                        widget.settingsRepo.updateFontFamily(next);
                      },
                    ),
                    const Divider(),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Text Scale Factor'),
                              Text(
                                '${((_localTextScale ?? settings?.textScaleFactor ?? 1.0) * 100).toInt()}%',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Slider(
                            value:
                                _localTextScale ??
                                settings?.textScaleFactor ??
                                1.0,
                            min: 0.5,
                            max: 2.0,
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
                                  _debounceTimer = null;
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Localization'),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: const Text('Language'),
                  subtitle: Text(settings?.locale ?? 'English'),
                  trailing: const Icon(Icons.language),
                  onTap: () {
                    final current = settings?.locale;
                    final next = current == 'en' ? 'es' : 'en';
                    widget.settingsRepo.updateLocale(next);
                  },
                ),
              ),
              const SizedBox(height: 16),
              _SectionHeader(title: 'Feature Flags'),
              Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
              const SizedBox(height: 20),
            ],
          ),
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: material.Colors.black.withValues(alpha: 0.1),
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
              color: material.Colors.black.withValues(alpha: 0.05),
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
                  ? material.Colors.black
                  : material.Colors.white,
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
      material.Colors.red,
      material.Colors.pink,
      material.Colors.purple,
      material.Colors.deepPurple,
      material.Colors.indigo,
      material.Colors.blue,
      material.Colors.lightBlue,
      material.Colors.cyan,
      material.Colors.teal,
      material.Colors.green,
      material.Colors.lightGreen,
      material.Colors.lime,
      material.Colors.yellow,
      material.Colors.amber,
      material.Colors.orange,
      material.Colors.deepOrange,
      material.Colors.brown,
      material.Colors.grey,
      material.Colors.blueGrey,
      material.Colors.black,
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
                    color: isSelected
                        ? material.Colors.black
                        : material.Colors.transparent,
                    width: 3,
                  ),
                  boxShadow: [
                    if (isSelected)
                      BoxShadow(
                        color: material.Colors.black.withValues(alpha: 0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                  ],
                ),
                child: isSelected
                    ? Icon(
                        Icons.check,
                        color: c.computeLuminance() > 0.5
                            ? material.Colors.black
                            : material.Colors.white,
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
