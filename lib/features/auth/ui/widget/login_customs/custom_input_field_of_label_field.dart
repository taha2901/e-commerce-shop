import 'package:ecommerce_app/features/auth/ui/widget/login_customs/label_with_text_field.dart';
import 'package:flutter/material.dart';

class CustomInputField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final IconData prefixIcon;
  final String hintText;
  final bool obscureText;
  final Widget? suffix;

  const CustomInputField({
    super.key,
    required this.label,
    required this.controller,
    required this.prefixIcon,
    required this.hintText,
    this.obscureText = false,
    this.suffix,
  });

  @override
  Widget build(BuildContext context) {
    return LabelWithTextField(
      label: label,
      controller: controller,
      prefixIcon: prefixIcon,
      hintText: hintText,
      obsecureText: obscureText,
      suffixIcon: suffix,
    );
  }
}
