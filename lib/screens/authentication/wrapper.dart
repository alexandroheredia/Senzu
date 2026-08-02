import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/screens/authentication/authenticate.dart';
import 'package:senzu_app/screens/home/home_page.dart';
import 'package:senzu_app/services/auth_controller.dart';
import 'package:senzu_app/shared/design/app_colors.dart';

/// Top-level auth gate: splash → login screen or the signed-in shell.
///
/// There is exactly ONE auth subscription in the app (owned by
/// [AuthController]); this widget only reflects its state, so `Home` can
/// never mount before a user is actually available.
class Wrapper extends ConsumerWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authControllerProvider);
    return switch (state.status) {
      AuthStatus.unknown => const _Splash(),
      AuthStatus.signedOut => const Authenticate(),
      AuthStatus.signedIn => const Home(),
    };
  }
}

/// Minimal branded splash shown while auth state restores.
class _Splash extends StatelessWidget {
  const _Splash();

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      backgroundColor: colors.bgBase,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/login_screen/login_cover_image.png',
              height: 140,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 28),
            Text('Senzu', style: Theme.of(context).textTheme.headlineLarge),
            const SizedBox(height: 20),
            const SizedBox.square(
              dimension: 18,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ],
        ),
      ),
    );
  }
}
