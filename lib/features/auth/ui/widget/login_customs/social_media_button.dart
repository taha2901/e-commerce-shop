import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class SocialMediaButton extends StatelessWidget {
  final String? text;
  final String? imgUrl;
  final VoidCallback? onTap;
  final bool isLoading;

  const SocialMediaButton({
    super.key,
    this.text,
    this.imgUrl,
    this.onTap,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.onBackground.withOpacity(0.2);

    return InkWell(
      onTap: isLoading ? null : onTap,
      borderRadius: BorderRadius.circular(16),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(color: borderColor),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          child: isLoading
              ? SizedBox(
                  height: 25,
                  width: 25,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: theme.colorScheme.primary,
                  ),
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (imgUrl != null)
                      CachedNetworkImage(
                        imageUrl: imgUrl!,
                        width: 25,
                        height: 25,
                        fit: BoxFit.fill,
                      ),
                    if (imgUrl != null) const SizedBox(width: 16),
                    if (text != null)
                      Text(
                        text!,
                        style: theme.textTheme.bodyMedium,
                      ),
                  ],
                ),
        ),
      ),
    );
  }
}
