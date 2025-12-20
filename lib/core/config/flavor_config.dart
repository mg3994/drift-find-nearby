import 'package:flutter/foundation.dart';
import 'package:serverpod_flutter/serverpod_flutter.dart';

/// Extension on String to convert to Flavor enum.
extension FlavorX on String {
  Flavor toFlavor() => Flavor.values.firstWhere(
    (e) => e.name == toLowerCase(),
    orElse: () => Flavor.production,
  );
}

enum Flavor {
  // set them in alphabetical order with full name
  development,
  production,
  staging;

  /// Returns the name of the flavor in lowercase.
  static Flavor fromString(String? value) {
    return Flavor.values.firstWhere(
      (e) => e.name == value?.toLowerCase(),
      orElse: () => Flavor.production,
    );
  }
}

abstract interface class FlavorConfig {
  const FlavorConfig._(this.flavor);

  final Flavor flavor;
  // ⭐️ Abstract getter: Each concrete class must define its remote URL
  String get remoteBaseUrl;

  factory FlavorConfig({String? flavorName}) {
    final flavor = Flavor.fromString(flavorName);
    switch (flavor) {
      case Flavor.development:
        return const _DevCfg();
      case Flavor.production:
        return const _ProdCfg();
      case Flavor.staging:
        return const _StgCfg();
    }
  }

  static BuildMode get buildMode => BuildMode.current;

  // ⭐️ Concrete Getter: This is the magic. It computes the final URL.
  String get baseUrl {
    // 1. If in RELEASE mode, always use the configured remoteBaseUrl.
    if (buildMode == BuildMode.release) {
      return remoteBaseUrl;
    }

    const String port = String.fromEnvironment('PORT', defaultValue: '8080');

    return 'http://$localhost:$port/';
  }
}

class _DevCfg extends FlavorConfig {
  const _DevCfg() : super._(Flavor.development);
  @override
  String get remoteBaseUrl => String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://api.dev.yourdomain.com/',
  );
}

class _ProdCfg extends FlavorConfig {
  const _ProdCfg() : super._(Flavor.production);
  @override
  String get remoteBaseUrl => String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://api.prod.yourdomain.com/',
  );
}

class _StgCfg extends FlavorConfig {
  const _StgCfg() : super._(Flavor.staging);
  @override
  String get remoteBaseUrl => String.fromEnvironment(
    'SERVER_URL',
    defaultValue: 'https://api.stg.yourdomain.com/',
  );
}

enum BuildMode {
  debug,
  profile,
  release;

  static BuildMode get current {
    if (kDebugMode) return BuildMode.debug;
    if (kProfileMode) return BuildMode.profile;
    if (kReleaseMode) return BuildMode.release;
    throw UnimplementedError(
      'Unknown build mode'
      ' - kDebugMode: $kDebugMode, '
      'kProfileMode: $kProfileMode, '
      'kReleaseMode: $kReleaseMode',
    );
  }
}
