import 'package:flutter/material.dart';

class LabelWithTextField extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final String hintText;
  final bool obsecureText;

  const LabelWithTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.suffixIcon,
    this.obsecureText = false,
  });

  @override
  State<LabelWithTextField> createState() => _LabelWithTextFieldState();
}

class _LabelWithTextFieldState extends State<LabelWithTextField> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleMedium!.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        TextFormField(
          controller: widget.controller,
          validator: (value) =>
              value == null || value.isEmpty ? '${widget.label} cannot be empty!' : null,
          obscureText: widget.obsecureText,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.prefixIcon, color: theme.iconTheme.color),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
          ),
        ),
      ],
    );
  }
}
