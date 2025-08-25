import 'package:ecommerce_app/features/checkout_payment/views/widgets/thank_you_view_body.dart';
import 'package:flutter/material.dart';

class ThankYouView extends StatelessWidget {
  final String total;
  const ThankYouView({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.close, color: theme.iconTheme.color?.withOpacity(0.8)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          'Payment Successful',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.textTheme.bodyLarge?.color,
          ),
        ),
        centerTitle: true,
      ),
      body: Transform.translate(
        offset: const Offset(0, -16),
        child: ThankYouViewBody(total: total),
      ),
    );
  }
}
