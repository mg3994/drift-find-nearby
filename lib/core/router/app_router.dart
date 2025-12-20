import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:findnearby/core/router/router_guards.dart';
import 'package:findnearby/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:findnearby/features/auth/presentation/views/sign_in_screen.dart';
import 'package:findnearby/features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:findnearby/features/onboarding/presentation/viewmodels/onboarding_view_model.dart';
import 'package:findnearby/features/home/presentation/views/home_screen.dart';
import 'package:findnearby/features/profile/presentation/views/profile_screen.dart';
import 'package:findnearby/features/quotes/presentation/views/quotes_screen.dart';
import 'package:findnearby/features/search/presentation/views/search_screen.dart';
import 'package:findnearby/features/settings/presentation/views/settings_screen.dart';
import 'package:findnearby/core/repositories/app_settings_repository.dart';
import 'package:findnearby/core/repositories/feature_flags_repository.dart';
import 'package:findnearby/core/widgets/scaffold_with_nav_bar.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createRouter({
  required AuthViewModel authViewModel,
  required OnboardingViewModel onboardingViewModel,
  required AppSettingsRepository settingsRepo,
  required FeatureFlagsRepository flagsRepo,
  required dynamic client,
}) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: onboardingViewModel.isOnboardingCompleted.value
        ? '/'
        : '/onboarding',
    debugLogDiagnostics: true,
    refreshListenable: MultiListenable([
      AuthListenable(authViewModel),
      OnboardingListenable(onboardingViewModel),
    ]),
    redirect: (context, state) {
      // 1. Priority: Onboarding
      final onboardingRedirect = onboardingGuard(
        context,
        state,
        onboardingViewModel,
      );
      if (onboardingRedirect != null) return onboardingRedirect;

      // 2. Auth Guard (only for protected routes)
      final authRedirect = authGuard(
        context,
        state,
        authViewModel,
        protectedRoutes: ['/profile'],
      );
      if (authRedirect != null) return authRedirect;

      return null;
    },
    routes: [
      GoRoute(
        path: '/onboarding',
        builder: (context, state) =>
            OnboardingScreen(viewModel: onboardingViewModel),
      ),
      GoRoute(path: '/auth', builder: (context, state) => const SignInScreen()),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNavBar(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/search',
                builder: (context, state) => const SearchScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/quotes',
                builder: (context, state) => const QuotesScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/settings',
                builder: (context, state) => SettingsScreen(
                  settingsRepo: settingsRepo,
                  flagsRepo: flagsRepo,
                ),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

// Listenable wrappers for signals to trigger router refreshes
class AuthListenable extends ChangeNotifier {
  final AuthViewModel viewModel;
  AuthListenable(this.viewModel) {
    viewModel.isSignedIn.subscribe((_) => notifyListeners());
  }
}

class OnboardingListenable extends ChangeNotifier {
  final OnboardingViewModel viewModel;
  OnboardingListenable(this.viewModel) {
    viewModel.isOnboardingCompleted.subscribe((_) => notifyListeners());
  }
}

class MultiListenable extends ChangeNotifier {
  final List<Listenable> listenables;
  MultiListenable(this.listenables) {
    for (final listenable in listenables) {
      listenable.addListener(notifyListeners);
    }
  }

  @override
  void dispose() {
    for (final listenable in listenables) {
      listenable.removeListener(notifyListeners);
    }
    super.dispose();
  }
}
