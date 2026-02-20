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
  // ✅ FocusNode عشان نحافظ على الـ focus لما يحصل rebuild
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

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
          // ✅ مهم: بنربط الـ FocusNode بالـ TextFormField
          // عشان لما يحصل rebuild، الـ focus يفضل محافظ عليه
          focusNode: _focusNode,
          controller: widget.controller,
          validator: (value) => value == null || value.isEmpty
              ? '${widget.label} cannot be empty!'
              : null,
          // ✅ مهم: obscureText بييجي من widget مش من state محلية
          // عشان لما الـ parent يعمل setState، مش بيعمل rebuild للـ field
          obscureText: widget.obsecureText,
          // ✅ منع الـ keyboard من الإغلاق عند الضغط خارج الـ field
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            prefixIcon: Icon(widget.prefixIcon, color: theme.iconTheme.color),
            suffixIcon: widget.suffixIcon,
            hintText: widget.hintText,
            filled: true,
            fillColor: theme.inputDecorationTheme.fillColor ??
                theme.colorScheme.surfaceVariant.withOpacity(0.3),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: theme.colorScheme.primary,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: theme.colorScheme.error, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}