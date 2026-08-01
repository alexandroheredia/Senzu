import 'package:firebase_auth/firebase_auth.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';

/// User-friendly auth failure that can be shown directly in the UI.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

class AuthenticationService {
  final FirebaseAuth _firebaseAuth;

  AuthenticationService(this._firebaseAuth);

  // create user obj based on firebase user
  AppUser _userFromFirebaseUser(User user) {
    return AppUser(uid: user.uid);
  }
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  // sign in anon
  Future<AppUser?> signInAnon() async {
    final result = await _firebaseAuth.signInAnonymously();
    final user = result.user;
    if (user == null) return null;
    return _userFromFirebaseUser(user);
  }

  // sign in with email and password
  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      if (user == null) return null;
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    } catch (e) {
      throw const AuthException('Could not sign in. Please try again.');
    }
  }

  // register with email and password
  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      final user = result.user;
      if (user == null) return null;
      // create a new document for the user with the uid
      await UserRepository(uid: user.uid)
          .updateUserData('male', 'sedentary', 2400);
      return _userFromFirebaseUser(user);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    } catch (e) {
      throw const AuthException('Could not create your account. Please try again.');
    }
  }

  // sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  String _friendlyMessage(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with that email.';
      case 'wrong-password':
        return 'Incorrect password. Please try again.';
      case 'invalid-email':
        return 'That email address looks invalid.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'weak-password':
        return 'Your password must be at least 6 characters.';
      case 'network-request-failed':
        return 'Network error. Check your connection and try again.';
      default:
        return 'Something went wrong. Please try again.';
    }
  }
}