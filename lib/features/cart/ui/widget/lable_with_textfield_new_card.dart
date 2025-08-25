import 'package:ecommerce_app/core/utils/app_colors.dart';
import 'package:flutter/material.dart';

class LabelWithTextFieldNewCard extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  final IconData icon;
  final String hintText;

  const LabelWithTextFieldNewCard({
    super.key,
    required this.label,
    required this.controller,
    required this.icon,
    required this.hintText,
  });

  @override
  State<LabelWithTextFieldNewCard> createState() =>
      _LabelWithTextFieldNewCardState();
}

class _LabelWithTextFieldNewCardState
    extends State<LabelWithTextFieldNewCard> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.black,
          ),
        ),
        const SizedBox(height: 12),
        TextFormField(
          controller: widget.controller,
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '${widget.label} cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(widget.icon, color: AppColors.grey),
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey.withOpacity(0.7),
            ),
            filled: true,
            fillColor: AppColors.grey1.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 16,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: AppColors.grey.withOpacity(0.2)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.red, width: 1.5),
            ),
          ),
        ),
      ],
    );
  }
}
