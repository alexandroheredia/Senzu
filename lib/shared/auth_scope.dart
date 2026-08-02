import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/services/auth_controller.dart';
import 'package:senzu_app/services/user_repositories.dart';

/// Scoped access to the app's auth state and the signed-in user's data.
///
/// [repos] and [uid] are only available while a user is signed in (below the
/// auth gate, i.e. while `Home` is mounted); they read the derived
/// [userRepositoriesProvider] from the nearest [ProviderScope].
///
/// [authController] works everywhere under the root scope, including the
/// login screens.
extension UserScope on BuildContext {
  /// Everything the app needs to read and write the signed-in user's data.
  UserRepositories get repos {
    final value = ProviderScope.containerOf(
      this,
      listen: false,
    ).read(userRepositoriesProvider);
    assert(
      value != null,
      'UserRepositories is only available while signed in',
    );
    return value!;
  }

  /// The non-empty uid of the signed-in user.
  String get uid => repos.uid;

  /// The app-wide auth controller, usable on the login screens too.
  AuthController get authController =>
      ProviderScope.containerOf(this, listen: false).read(
        authControllerProvider.notifier,
      );
}
