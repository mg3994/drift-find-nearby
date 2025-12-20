import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

class ScaffoldWithNavBar extends StatelessWidget {
  const ScaffoldWithNavBar({required this.navigationShell, super.key});

  final StatefulNavigationShell navigationShell;

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 600) {
          return ScaffoldWithBottomNavBar(
            navigationShell: navigationShell,
            onTap: (index) => _onTap(context, index),
          );
        } else {
          return ScaffoldWithNavRail(
            navigationShell: navigationShell,
            onTap: (index) => _onTap(context, index),
          );
        }
      },
    );
  }
}

class ScaffoldWithBottomNavBar extends StatelessWidget {
  const ScaffoldWithBottomNavBar({
    super.key,
    required this.navigationShell,
    required this.onTap,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('FindNearBy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: onTap,
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.home_outlined),
            selectedIcon: const Icon(Icons.home),
            label: l10n.home,
          ),
          NavigationDestination(
            icon: const Icon(Icons.search_outlined),
            selectedIcon: const Icon(Icons.search),
            label: l10n.search,
          ),
          NavigationDestination(
            icon: const Icon(Icons.format_quote_outlined),
            selectedIcon: const Icon(Icons.format_quote),
            label: l10n.quotes,
          ),
          NavigationDestination(
            icon: const Icon(Icons.person_outline),
            selectedIcon: const Icon(Icons.person),
            label: l10n.profile,
          ),
        ],
      ),
    );
  }
}

class ScaffoldWithNavRail extends StatelessWidget {
  const ScaffoldWithNavRail({
    super.key,
    required this.navigationShell,
    required this.onTap,
  });

  final StatefulNavigationShell navigationShell;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('FindNearBy'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
          ),
        ],
      ),
      body: Row(
        children: [
          NavigationRail(
            backgroundColor: theme.colorScheme.surface,
            selectedIndex: navigationShell.currentIndex,
            onDestinationSelected: onTap,
            labelType: NavigationRailLabelType.all,
            groupAlignment: -0.85,
            leading: Padding(
              padding: const EdgeInsets.only(bottom: 24.0),
              child: FloatingActionButton(
                elevation: 0,
                onPressed: () {},
                child: const Icon(Icons.add),
              ),
            ),
            destinations: [
              NavigationRailDestination(
                icon: const Icon(Icons.home_outlined),
                selectedIcon: const Icon(Icons.home),
                label: Text(l10n.home),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.search_outlined),
                selectedIcon: const Icon(Icons.search),
                label: Text(l10n.search),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.format_quote_outlined),
                selectedIcon: const Icon(Icons.format_quote),
                label: Text(l10n.quotes),
              ),
              NavigationRailDestination(
                icon: const Icon(Icons.person_outline),
                selectedIcon: const Icon(Icons.person),
                label: Text(l10n.profile),
              ),
            ],
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}
