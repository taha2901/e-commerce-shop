import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
class PaymentMethodsListView extends StatefulWidget {
  const PaymentMethodsListView({super.key});

  @override
  State<PaymentMethodsListView> createState() => _PaymentMethodsListViewState();
}

class _PaymentMethodsListViewState extends State<PaymentMethodsListView> {
  final List<Map<String, String>> paymentMethodsItems = const [
    {
      'image': 'assets/images/card.svg',
      'title': 'Credit Card',
      'subtitle': 'Visa, Mastercard, etc.'
    },
    {
      'image': 'assets/images/paypal.svg',
      'title': 'PayPal',
      'subtitle': 'Pay with PayPal account'
    }
  ];

  int activeIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: paymentMethodsItems.asMap().entries.map((entry) {
        int index = entry.key;
        Map<String, String> method = entry.value;
        bool isActive = activeIndex == index;

        return GestureDetector(
          onTap: () {
            setState(() {
              activeIndex = index;
            });
          },
          child: Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActive
                    ? theme.primaryColor
                    : theme.colorScheme.outline,
                width: isActive ? 2 : 1,
              ),
              boxShadow: isActive
                  ? [
                      BoxShadow(
                        color: theme.primaryColor.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: theme.colorScheme.shadow.withOpacity(0.05),
                        spreadRadius: 1,
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
            ),
            child: Row(
              children: [
                Container(
                  width: 48.w,
                  height: 48.h,
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceVariant,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SvgPicture.asset(
                    method['image']!,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        method['title']!,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        method['subtitle']!,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 20.w,
                  height: 20.h,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isActive
                          ? theme.primaryColor
                          : theme.colorScheme.outline,
                      width: 2,
                    ),
                    color: isActive ? theme.primaryColor : Colors.transparent,
                  ),
                  child: isActive
                      ? Icon(
                          Icons.check,
                          size: 12.sp,
                          color: theme.colorScheme.onPrimary,
                        )
                      : null,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}
