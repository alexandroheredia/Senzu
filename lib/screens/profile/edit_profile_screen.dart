import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:senzu_app/services/data_providers.dart';
import 'package:senzu_app/shared/auth_scope.dart';
import 'package:senzu_app/shared/widgets/glass_card.dart';
import 'package:senzu_app/shared/widgets/glass_input.dart';
import 'package:senzu_app/shared/widgets/glass_segmented.dart';
import 'package:senzu_app/shared/widgets/gradient_button.dart';

/// Edit the profile fields collected during onboarding.
class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _height;
  late final TextEditingController _weight;
  late final TextEditingController _age;
  late String _sex;
  late String _activity;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(userDataProvider).value;
    _name = TextEditingController(text: user?.username ?? '');
    _height = TextEditingController(
      text: _fmt(user?.heightCm),
    );
    _weight = TextEditingController(
      text: _fmt(user?.weightKg),
    );
    _age = TextEditingController(
      text: user?.ageYears == 0 ? '' : '${user?.ageYears}',
    );
    _sex = (user?.sex.isEmpty ?? true) ? 'male' : user!.sex;
    _activity = (user?.activityLevel.isEmpty ?? true)
        ? 'sedentary'
        : user!.activityLevel;
  }

  @override
  void dispose() {
    _name.dispose();
    _height.dispose();
    _weight.dispose();
    _age.dispose();
    super.dispose();
  }

  static String _fmt(double? value) =>
      (value == null || value == 0) ? '' : value.toString();

  double _parse(TextEditingController c) => double.tryParse(c.text.trim()) ?? 0;

  String? _requiredNumber(String? value) {
    if (value == null || value.trim().isEmpty) return 'Required';
    if (double.tryParse(value.trim()) == null) return 'Enter a number';
    return null;
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);
    final messenger = ScaffoldMessenger.of(context);
    try {
      await context.repos.user.updateProfile(
        username: _name.text.trim(),
        sex: _sex,
        activityLevel: _activity,
        heightCm: _parse(_height),
        weightKg: _parse(_weight),
        ageYears: _parse(_age).toInt(),
      );
      if (!mounted) return;
      Navigator.of(context).pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Profile updated')),
      );
    } on Object {
      if (mounted) {
        setState(() => _saving = false);
        messenger.showSnackBar(
          const SnackBar(
            content: Text(
              'Could not save your profile. '
              'Check your connection and try again.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit profile')),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GlassCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      GlassInput(
                        controller: _name,
                        hint: 'Your name',
                        leadingIcon: Icons.person_outline,
                        validator: (value) =>
                            (value == null || value.trim().isEmpty)
                            ? 'Enter your name'
                            : null,
                      ),
                      const SizedBox(height: 16),
                      _SegmentedPicker<String>(
                        label: 'Sex',
                        segments: const [
                          GlassSegment<String>('male', 'Male'),
                          GlassSegment<String>('female', 'Female'),
                        ],
                        value: _sex,
                        onChanged: (value) => setState(() => _sex = value),
                      ),
                      const SizedBox(height: 16),
                      _SegmentedPicker<String>(
                        label: 'Activity level',
                        segments: const [
                          GlassSegment<String>('sedentary', 'Sedentary'),
                          GlassSegment<String>(
                            'slightly_active',
                            'Light',
                          ),
                          GlassSegment<String>('active', 'Active'),
                          GlassSegment<String>('very_active', 'Very active'),
                        ],
                        value: _activity,
                        onChanged: (value) =>
                            setState(() => _activity = value),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: GlassInput(
                              controller: _height,
                              hint: 'cm',
                              label: 'Height',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                              validator: _requiredNumber,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: GlassInput(
                              controller: _weight,
                              hint: 'kg',
                              label: 'Weight',
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  RegExp('[0-9.]'),
                                ),
                              ],
                              validator: _requiredNumber,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      GlassInput(
                        controller: _age,
                        hint: 'Years',
                        label: 'Age',
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: _requiredNumber,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Update your calorie goal in Nutrition goals — '
                        'it uses these stats.',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                GradientButton(
                  label: 'Save profile',
                  icon: Icons.check,
                  loading: _saving,
                  onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Label + [GlassSegmentedControl] pair for sex / activity selection.
class _SegmentedPicker<T> extends StatelessWidget {
  final String label;
  final List<GlassSegment<T>> segments;
  final T value;
  final ValueChanged<T> onChanged;

  const _SegmentedPicker({
    required this.label,
    required this.segments,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label, style: Theme.of(context).textTheme.labelSmall),
        ),
        GlassSegmentedControl<T>(
          segments: segments,
          value: value,
          onChanged: onChanged,
        ),
      ],
    );
  }
}
