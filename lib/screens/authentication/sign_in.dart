import 'package:flutter/material.dart';
import 'package:senzu_app/services/auth_controller.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _password = TextEditingController();
  bool _obscure = true;
  bool _loading = false;
  String _error = '';

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() {
      _loading = true;
      _error = '';
    });
    final auth = context.authController;
    try {
      await auth.signInWithEmailAndPassword(
        _email.text.trim(),
        _password.text,
      );
      // On success the auth stream switches to Home.
    } on AuthException catch (e) {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = e.message;
        });
      }
    } on Object {
      if (mounted) {
        setState(() {
          _loading = false;
          _error = 'Could not sign in. Please try again.';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          GlassInput(
            controller: _email,
            hint: 'Email',
            leadingIcon: Icons.mail_outline,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => (value == null || value.trim().isEmpty)
                ? 'Enter your email'
                : null,
          ),
          const SizedBox(height: 16),
          GlassInput(
            controller: _password,
            hint: 'Password',
            leadingIcon: Icons.lock_outline,
            obscureText: _obscure,
            suffix: IconButton(
              onPressed: () => setState(() => _obscure = !_obscure),
              icon: Icon(
                _obscure
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: colors.textSecondary,
                size: 20,
              ),
            ),
            validator: (value) => (value == null || value.length < 6)
                ? 'Password must be at least 6 characters'
                : null,
          ),
          const SizedBox(height: 24),
          GradientButton(
            label: 'Login',
            icon: Icons.bolt,
            loading: _loading,
            onPressed: _submit,
          ),
          if (_error.isNotEmpty) ...[
            const SizedBox(height: 14),
            Text(
              _error,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.danger, fontSize: 14),
            ),
          ],
        ],
      ),
    );
  }
}
