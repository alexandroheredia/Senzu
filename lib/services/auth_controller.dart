import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/models/user.dart';
import 'package:senzu_app/services/user_repository.dart';

/// The [FirebaseAuth] instance used by the app. Override in tests.
final firebaseAuthProvider = Provider<FirebaseAuth>(
  (ref) => FirebaseAuth.instance,
);

/// Owns the Firebase auth session and exposes it as a single observable
/// [AuthState]. This is the only place that subscribes to
/// `authStateChanges`, which eliminates the split-brain race where one
/// listener shows `Home` while another still holds no user.
final authControllerProvider = NotifierProvider<AuthController, AuthState>(
  AuthController.new,
);

/// User-friendly auth failure that can be shown directly in the UI.
class AuthException implements Exception {
  final String message;
  const AuthException(this.message);

  @override
  String toString() => message;
}

/// Phases the app can be in with respect to authentication.
enum AuthStatus {
  /// Session is still being restored (cold start). UI shows a splash.
  unknown,

  /// No signed-in user. UI shows the login screen.
  signedOut,

  /// A user is signed in and their data scope is ready. UI shows the
  /// post-auth shell (`Home`).
  signedIn,
}

/// Immutable snapshot of the authentication state.
@immutable
class AuthState {
  final AuthStatus status;
  final AppUser? user;

  const AuthState._(this.status, this.user);

  const AuthState.unknown() : this._(AuthStatus.unknown, null);

  const AuthState.signedOut() : this._(AuthStatus.signedOut, null);

  const AuthState.signedIn(AppUser user) : this._(AuthStatus.signedIn, user);

  String? get uid => user?.uid;

  bool get isSignedIn => status == AuthStatus.signedIn;
}

/// Owns the Firebase auth session and exposes it as a single observable
/// [AuthState].
///
/// This is the only place that talks to [FirebaseAuth]. The widget tree
/// consumes [state] instead of subscribing to raw auth streams, which
/// eliminates the split-brain race where one listener shows `Home` while
/// another still holds no user.
class AuthController extends Notifier<AuthState> {
  late final FirebaseAuth _auth;
  StreamSubscription<User?>? _subscription;

  /// Monotonic counter guarding against interleaved auth events: only the
  /// latest `authStateChanges` emission is allowed to publish its state.
  int _generation = 0;

  @override
  AuthState build() {
    _auth = ref.watch(firebaseAuthProvider);
    _subscription = _auth.authStateChanges().listen(
      _onAuthChanged,
      onError: (_) => state = const AuthState.signedOut(),
    );
    ref.onDispose(() => _subscription?.cancel());
    return const AuthState.unknown();
  }

  /// The signed-in user's uid, or null while unknown/signed out.
  String? get uid => state.uid;

  Future<void> _onAuthChanged(User? firebaseUser) async {
    final generation = ++_generation;
    if (firebaseUser == null) {
      state = const AuthState.signedOut();
      return;
    }

    final user = AppUser(uid: firebaseUser.uid);

    // Best-effort bootstrap: guarantee a `users/{uid}` document exists.
    // Covers anonymous sign-in and legacy accounts created before the doc
    // was mandatory. Never blocks the signed-in transition on Firestore
    // failures.
    try {
      await UserRepository(uid: user.uid).ensureExists();
    } on Object catch (error, stack) {
      debugPrint(
        'AuthController: could not bootstrap user doc: $error\n$stack',
      );
    }

    // A newer auth event (e.g. sign-out) superseded this one while we were
    // awaiting Firestore; do not publish stale state.
    if (generation != _generation) return;
    state = AuthState.signedIn(user);
  }

  // --- Public actions -------------------------------------------------------

  Future<AppUser?> signInAnon() async {
    final result = await _auth.signInAnonymously();
    final user = result.user;
    return user == null ? null : AppUser(uid: user.uid);
  }

  Future<AppUser?> signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      return user == null ? null : AppUser(uid: user.uid);
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    } on Object {
      throw const AuthException('Could not sign in. Please try again.');
    }
  }

  Future<AppUser?> registerWithEmailAndPassword(
    String email,
    String password,
  ) async {
    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = result.user;
      if (user == null) return null;
      final appUser = AppUser(uid: user.uid);
      // Default profile so the dashboard has a goal to render immediately.
      await UserRepository(uid: appUser.uid).updateUserData(
        'male',
        'sedentary',
        2400,
      );
      return appUser;
    } on FirebaseAuthException catch (e) {
      throw AuthException(_friendlyMessage(e.code));
    } on Object {
      throw const AuthException(
        'Could not create your account. Please try again.',
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
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
