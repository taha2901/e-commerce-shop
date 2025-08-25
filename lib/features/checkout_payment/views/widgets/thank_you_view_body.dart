import 'package:ecommerce_app/features/checkout_payment/views/widgets/thank_you_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
class ThankYouViewBody extends StatelessWidget {
  final String total;
  const ThankYouViewBody({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.only(top: 36.h),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ThankYouCard(total: total),

          // خط منقط
          Positioned(
            bottom: MediaQuery.sizeOf(context).height * .2 + 20,
            left: 28,
            right: 28,
            child: Row(
              children: List.generate(
                60,
                (index) => Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 1),
                    height: 2,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.outline,
                      borderRadius: BorderRadius.circular(1),
                    ),
                  ),
                ),
              ),
            ),
          ),

          // الدوائر الجانبية
          Positioned(
            left: -20,
            bottom: MediaQuery.sizeOf(context).height * .2,
            child: _buildSideCircle(theme),
          ),
          Positioned(
            right: -20,
            bottom: MediaQuery.sizeOf(context).height * .2,
            child: _buildSideCircle(theme),
          ),

          // أيقونة التأكيد
          Positioned(
            top: -50,
            left: 0,
            right: 0,
            child: _buildCheckIcon(theme),
          ),
        ],
      ),
    );
  }

  Widget _buildSideCircle(ThemeData theme) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceVariant,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 4,
          ),
        ],
      ),
    );
  }

  Widget _buildCheckIcon(ThemeData theme) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.brightness == Brightness.dark
                ? Colors.black.withOpacity(0.3)
                : Colors.grey.withOpacity(0.2),
            spreadRadius: 4,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [
              const Color(0xff34A853),
              const Color(0xff34A853).withOpacity(0.8),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: const Icon(
          Icons.check_rounded,
          size: 50,
          color: Colors.white,
        ),
      ),
    );
  }
}
