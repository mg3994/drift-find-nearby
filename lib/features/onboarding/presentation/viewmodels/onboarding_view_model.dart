import 'package:signals_flutter/signals_flutter.dart';
import 'package:findnearby/core/repositories/preferences_repository.dart';

class OnboardingViewModel {
  final PreferencesRepository _repository;

  OnboardingViewModel(this._repository);

  ReadonlySignal<bool> get isOnboardingCompleted => _repository.isOnboardingCompleted;

  Future<void> completeOnboarding() async {
    await _repository.completeOnboarding();
  }
}
