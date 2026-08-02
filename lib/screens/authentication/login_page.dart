import 'package:flutter/material.dart';
import 'package:senzu_app/screens/authentication/register.dart';
import 'package:senzu_app/screens/authentication/sign_in.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';

/// Auth shell: brand mark, tagline, and a glass card with a Login / Sign up
/// segmented control switching between the two forms.
class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _signUp = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/login_screen/login_cover_image.png',
                  height: 140,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 24),
                Text(
                  'Senzu',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Calories are energy.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 40),
                GlassCard(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassSegmentedControl<bool>(
                        segments: const [
                          GlassSegment<bool>(false, 'Login'),
                          GlassSegment<bool>(true, 'Sign up'),
                        ],
                        value: _signUp,
                        onChanged: (value) => setState(() => _signUp = value),
                      ),
                      const SizedBox(height: 24),
                      AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        switchInCurve: Curves.easeOut,
                        switchOutCurve: Curves.easeIn,
                        child: _signUp
                            ? const Register(key: ValueKey<String>('register'))
                            : const LoginForm(key: ValueKey<String>('login')),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
