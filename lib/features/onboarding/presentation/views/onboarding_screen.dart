import 'package:flutter/material.dart';
import 'package:findnearby/features/onboarding/presentation/viewmodels/onboarding_view_model.dart';

class OnboardingScreen extends StatelessWidget {
  final OnboardingViewModel viewModel;
  const OnboardingScreen({super.key, required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Onboarding Screen Stub'),
            ElevatedButton(
              onPressed: () {
                viewModel.completeOnboarding();
              },
              child: const Text('Complete Onboarding'),
            ),
          ],
        ),
      ),
    );
  }
}
