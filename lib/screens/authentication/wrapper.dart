import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:senzu_app/screens/authentication/authenticate.dart';
import 'package:senzu_app/screens/home/home_page.dart';
import 'package:senzu_app/services/auth_service.dart';
import 'package:senzu_app/shared/theme.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Show a splash while the auth session is restoring, so the login screen
    // does not flash on every cold start for signed-in users.
    return StreamBuilder<User?>(
      stream: context.read<AuthenticationService>().authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: primaryBackgroundColor,
            body: Center(child: loadingWidget),
          );
        }
        final user = snapshot.data;
        // return either the Home or Authenticate widget
        if (user == null) {
          return const Authenticate();
        }
        return const Home();
      },
    );
  }
}