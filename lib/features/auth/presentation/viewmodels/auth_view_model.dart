import 'package:signals/signals_flutter.dart';

class AuthViewModel {
  final isSignedIn = signal<bool>(false);

  void signIn() {
    isSignedIn.value = true;
  }

  void signOut() {
    isSignedIn.value = false;
  }
}
