import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get authStateChanges => auth.authStateChanges();

  Future<UserCredential> signInWithEmailAndPassword(String email, String password) {
    return auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) {
    return auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  Future<void> signOut() {
    return auth.signOut();
  }

  static String getErrorMessage(FirebaseAuthException exception) {
    switch (exception.code) {
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'The password is too weak.';
      case 'operation-not-allowed':
        return 'This sign-in method is not enabled.';
      default:
        return exception.message ?? 'Authentication failed. Please try again.';
    }
  }
}

final authServiceProvider = Provider<AuthService>((ref) {
  return AuthService();
});

final authStateChangesProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
