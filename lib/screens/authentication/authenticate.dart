import 'package:flutter/material.dart';
import 'package:senzu_app/screens/authentication/login_page.dart';
import 'package:senzu_app/screens/authentication/register.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({super.key});

  @override
  State<Authenticate> createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;
  void toggleView() {
    setState(() => showSignIn = !showSignIn);
  }

  @override
  Widget build(BuildContext context) {
    if (showSignIn) {
      // return SignIn(toggleView: toggleView);
      return const LoginPage();
    } else {
      return Register(toggleView: toggleView);
    }
  }
}
