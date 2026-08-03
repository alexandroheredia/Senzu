import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/services/auth_controller.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/design/app_colors.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Account management: email + verification status, password change,
/// verification email, and account deletion.
class AccountScreen extends ConsumerStatefulWidget {
  const AccountScreen({super.key});

  @override
  ConsumerState<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends ConsumerState<AccountScreen> {
  bool _busy = false;
  String _message = '';

  Future<void> _changePassword() async {
    final auth = context.authController;
    final messenger = ScaffoldMessenger.of(context);
    final newPassword = TextEditingController();
    final confirm = TextEditingController();

    final saved = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            20,
            20,
            MediaQuery.of(sheetContext).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Change password',
                style: Theme.of(sheetContext).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: newPassword,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'New password',
                  hintText: 'At least 6 characters',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirm,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Confirm'),
              ),
              const SizedBox(height: 16),
              GradientButton(
                label: 'Update password',
                icon: Icons.check,
                onPressed: () {
                  if (newPassword.text.length < 6) return;
                  if (newPassword.text != confirm.text) return;
                  Navigator.pop(sheetContext, true);
                },
              ),
            ],
          ),
        );
      },
    );

    final password = newPassword.text;
    newPassword.dispose();
    confirm.dispose();
    if (saved != true || !mounted) return;

    setState(() {
      _busy = true;
      _message = '';
    });
    try {
      await auth.changePassword(password);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Password updated')),
      );
    } on AuthException catch (e) {
      if (mounted) setState(() => _message = e.message);
    } on Object {
      if (mounted) {
        setState(() => _message = 'Could not change the password.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _sendVerification() async {
    final auth = context.authController;
    final messenger = ScaffoldMessenger.of(context);
    try {
      await auth.sendEmailVerification();
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Verification email sent')),
      );
    } on AuthException catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on Object {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not send the email.')),
        );
      }
    }
  }

  Future<void> _sendResetEmail() async {
    final auth = context.authController;
    final messenger = ScaffoldMessenger.of(context);
    final email = auth.email;
    if (email == null) return;
    try {
      await auth.sendPasswordReset(email);
      if (!mounted) return;
      messenger.showSnackBar(
        const SnackBar(content: Text('Password reset email sent')),
      );
    } on AuthException catch (e) {
      if (mounted) {
        messenger.showSnackBar(SnackBar(content: Text(e.message)));
      }
    } on Object {
      if (mounted) {
        messenger.showSnackBar(
          const SnackBar(content: Text('Could not send the email.')),
        );
      }
    }
  }

  Future<void> _deleteAccount() async {
    final auth = context.authController;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete account?'),
        content: const Text(
          'All your data — logs, shelf, meals, weight — will be '
          'permanently deleted. This cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Keep account'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(
              'Delete',
              style: TextStyle(
                color: context.appColors.danger,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() {
      _busy = true;
      _message = '';
    });
    try {
      await auth.deleteAccount();
      // On success the auth stream flips to signedOut → login screen.
    } on AuthException catch (e) {
      if (mounted) setState(() => _message = e.message);
    } on Object {
      if (mounted) {
        setState(() => _message = 'Could not delete the account.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final auth = context.authController;
    final email = auth.email ?? '';
    final verified = auth.isEmailVerified;

    return Scaffold(
      appBar: AppBar(title: const Text('Account')),
      body: ListView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Icon(Icons.mail_outline, color: colors.textPrimary, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            email,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            verified
                                ? 'Email verified'
                                : 'Email not verified',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: verified
                                      ? colors.statusGood
                                      : colors.statusLow,
                                ),
                          ),
                        ],
                      ),
                    ),
                    if (verified)
                      Icon(Icons.verified, color: colors.statusGood, size: 20),
                  ],
                ),
                const SizedBox(height: 16),
                if (!verified) ...[
                  _AccountAction(
                    icon: Icons.mark_email_read_outlined,
                    label: 'Verify email',
                    onTap: _sendVerification,
                  ),
                  const SizedBox(height: 6),
                ],
                _AccountAction(
                  icon: Icons.password,
                  label: 'Change password',
                  onTap: _changePassword,
                ),
                const SizedBox(height: 6),
                _AccountAction(
                  icon: Icons.restore,
                  label: 'Send password reset email',
                  onTap: _sendResetEmail,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          GlassCard(
            padding: const EdgeInsets.all(8),
            child: _AccountAction(
              icon: Icons.delete_outline,
              label: 'Delete account',
              danger: true,
              onTap: _deleteAccount,
            ),
          ),
          if (_message.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              _message,
              textAlign: TextAlign.center,
              style: TextStyle(color: colors.danger, fontSize: 14),
            ),
          ],
          if (_busy) ...[
            const SizedBox(height: 20),
            const Center(child: CircularProgressIndicator()),
          ],
        ],
      ),
    );
  }
}

class _AccountAction extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  const _AccountAction({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final color = danger ? colors.danger : colors.textPrimary;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: color,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              Icon(Icons.chevron_right, color: colors.textSecondary, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}
