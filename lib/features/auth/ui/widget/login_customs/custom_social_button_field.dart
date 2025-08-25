import 'package:ecommerce_app/features/auth/ui/widget/social_button_widget.dart';
import 'package:flutter/material.dart';

class CustomSocialButton extends StatelessWidget {
  final String text;
  final String imgUrl;
  final VoidCallback onTap;
  final bool isLoading;

  const CustomSocialButton({
    super.key,
    required this.text,
    required this.imgUrl,
    required this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SocialButtonWidget(
      text: text,
      imgUrl: imgUrl,
      isLoading: isLoading,
      onTap: onTap,
      color: theme.colorScheme.primary.withOpacity(0.1), // لون خلفية يعتمد على الثيم
      borderColor: theme.colorScheme.primary, // لون الحدود يعتمد على الثيم
    );
  }
}
