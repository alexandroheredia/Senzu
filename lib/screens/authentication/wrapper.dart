import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/screens/authentication/authenticate.dart';
import 'package:senzu_app/screens/home/home_page.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/shared/design/app_colors.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Show a branded splash while the auth session is restoring, so the login
    // screen does not flash on every cold start for signed-in users.
    return StreamBuilder<User?>(
      stream: context.read<AuthenticationService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const _Splash();
        }
        final user = snapshot.data;
        return user == null ? const Authenticate() : const Home();
      },
    );
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
