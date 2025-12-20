import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:findnearby/features/auth/presentation/viewmodels/auth_view_model.dart';
import 'package:findnearby/features/onboarding/presentation/viewmodels/onboarding_view_model.dart';

/// Guard specifically for onboarding.
/// Redirects to /onboarding if not completed, and handles back-redirection via 'from'.
String? onboardingGuard(
  BuildContext context,
  GoRouterState state,
  OnboardingViewModel viewModel,
) {
  final isOnboardingCompleted = viewModel.isOnboardingCompleted.value;
  final location = state.matchedLocation;
  final isGoingToOnboarding = location == '/onboarding';

  if (!isOnboardingCompleted) {
    if (!isGoingToOnboarding) {
      final originalLocation = state.uri.toString();
      final encodedFrom = Uri.encodeComponent(originalLocation);
      return '/onboarding?from=$encodedFrom';
    }
    return null;
  }

  // If completed and trying to go to onboarding, redirect back to home or 'from'
  if (isGoingToOnboarding) {
    final from = state.uri.queryParameters['from'];
    if (from != null && from.isNotEmpty) {
      return Uri.decodeComponent(from);
    }
    return '/';
  }

  return null;
}

/// A reusable guard that protects routes based on authentication status.
///
/// [protectedRoutes]: A list of route paths (prefixes) that require authentication.
/// If matched, and user is not signed in, they are redirected to '/auth'.
///
/// Also handles the redirect *back* from '/auth' if the user is already signed in.
String? authGuard(
  BuildContext context,
  GoRouterState state,
  AuthViewModel authViewModel, {
  List<String> protectedRoutes = const ['/profile'],
}) {
  final isSignedIn = authViewModel.isSignedIn.value;
  final location = state.matchedLocation;
  final isGoingToAuth = location == '/auth';

  final isProtectedRoute = protectedRoutes.any(
    (route) => location.startsWith(route),
  );

  // 1. If NOT signed in...
  if (!isSignedIn) {
    // ...and trying to access a protected route
    if (isProtectedRoute) {
      // Redirect to /auth, saving the FULL intended location as 'from'
      final originalLocation = state.uri.toString();
      final encodedFrom = Uri.encodeComponent(originalLocation);
      return '/auth?from=$encodedFrom';
    }
    return null;
  }

  // 2. If SIGNED IN...
  if (isSignedIn) {
    // ...and trying to access /auth (e.g. login page)
    if (isGoingToAuth) {
      // Check if we have a place to go back to (from the 'from' query param)
      final from = state.uri.queryParameters['from'];
      if (from != null && from.isNotEmpty) {
        return Uri.decodeComponent(from);
      }
      // If no 'from', default to home
      return '/';
    }
    // Allowed to go anywhere else
    return null;
  }

  return null;
}
