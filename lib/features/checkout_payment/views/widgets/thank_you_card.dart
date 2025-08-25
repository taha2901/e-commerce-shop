import 'package:ecommerce_app/core/widget/spacing.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/card_info_widget.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/payment_info_item.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/total_price_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
class ThankYouCard extends StatelessWidget {
  final String total;
  const ThankYouCard({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: isDark 
                ? Colors.black.withOpacity(0.4)
                : Colors.grey.withOpacity(0.15),
            spreadRadius: 3,
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 66.h, left: 24.w, right: 24.w, bottom: 12.h),
        child: Column(
          children: [
            // Success message
            Text(
              '🎉 Thank you!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Your transaction was successful',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 16.h),

            // Transaction details in a card
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceVariant,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: theme.colorScheme.outline),
              ),
              child: Column(
                children: [
                  PaymentItemInfo(
                    title: 'Date',
                    value: '01/24/2023',
                    icon: Icons.calendar_today_rounded,
                  ),
                  SizedBox(height: 8.h),
                  PaymentItemInfo(
                    title: 'Time',
                    value: '10:15 AM',
                    icon: Icons.access_time_rounded,
                  ),
                ],
              ),
            ),

            SizedBox(height: 12.h),
            // Total amount highlight
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.primaryColor.withOpacity(0.1),
                    theme.primaryColor.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: theme.primaryColor.withOpacity(0.3),
                ),
              ),
              child: TotalPrice(title: 'Total Amount', value: '\$$total'),
            ),

            SizedBox(height: 16.h),
            CardInfoWidget(),
            SizedBox(height: 24.h),

            // Bottom section with barcode and PAID badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    FontAwesomeIcons.barcode,
                    size: 48,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        const Color(0xFF34A853),
                        const Color(0xFF34A853).withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF34A853).withOpacity(0.3),
                        spreadRadius: 1,
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'PAID',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
