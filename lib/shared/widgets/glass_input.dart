import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:senzu_app/shared/design/app_colors.dart';

/// Glass search/input field: glass fill, 16dp radius, leading icon,
/// secondary placeholder.
class GlassInput extends StatelessWidget {
  final TextEditingController? controller;
  final String hint;
  final IconData? leadingIcon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onChanged;
  final Widget? suffix;
  final bool readOnly;
  final VoidCallback? onTap;
  final List<TextInputFormatter>? inputFormatters;
  final String? initialValue;

  /// Optional caption shown above the field.
  final String? label;

  final bool autofocus;

  const GlassInput({
    super.key,
    this.controller,
    this.hint = '',
    this.leadingIcon,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.suffix,
    this.readOnly = false,
    this.onTap,
    this.inputFormatters,
    this.initialValue,
    this.label,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    final field = TextFormField(
      controller: controller,
      initialValue: initialValue,
      autofocus: autofocus,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      readOnly: readOnly,
      onTap: onTap,
      inputFormatters: inputFormatters,
      style: Theme.of(context).textTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hint,
        prefixIcon: leadingIcon == null
            ? null
            : Icon(leadingIcon, color: colors.textSecondary, size: 20),
        suffixIcon: suffix,
      ),
    );

    if (label == null) return field;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 6),
          child: Text(label!, style: Theme.of(context).textTheme.labelSmall),
        ),
        field,
      ],
    );
  }
}
