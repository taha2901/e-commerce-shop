import 'package:ecommerce_app/core/services/admin_order_services.dart';
import 'package:ecommerce_app/features/checkout_payment/presentation/manger/payment_cubit.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/custom_button_bloc_consumer.dart';
import 'package:ecommerce_app/features/checkout_payment/views/widgets/payment_methods_list_view.dart';
import 'package:ecommerce_app/features/location_picker/logic/location_cubit.dart';
import 'package:ecommerce_app/features/location_picker/logic/location_state.dart';
import 'package:ecommerce_app/features/location_picker/ui/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class PaymentMethodsBottomSheet extends StatelessWidget {
  final double total;
  const PaymentMethodsBottomSheet({
    super.key,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: DraggableScrollableSheet(
        initialChildSize: 0.75,
        minChildSize: 0.5,
        maxChildSize: 0.95,
        expand: false,
        builder: (context, scrollController) {
          return SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: EdgeInsets.all(24.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Handle bar
                  Container(
                    width: 50.w,
                    height: 4.h,
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[600] : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Header
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.payment_rounded,
                          color: Theme.of(context).primaryColor,
                          size: 24.sp,
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Your Order',
                              style: TextStyle(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              'Choose payment method and delivery location',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 32.h),

                  // Delivery Location Section
                  _buildSectionHeader(
                    context,
                    'Delivery Location',
                    Icons.location_on_rounded,
                    isRequired: true,
                  ),
                  SizedBox(height: 16.h),

                  // Location Widget
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, locationState) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: locationState is LocationSelected
                              ? isDarkMode 
                                  ? Colors.green[900]?.withOpacity(0.3) 
                                  : Colors.green[50]
                              : isDarkMode 
                                  ? Colors.grey[800] 
                                  : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: locationState is LocationSelected
                                ? isDarkMode 
                                    ? Colors.green[700]! 
                                    : Colors.green[200]!
                                : isDarkMode 
                                    ? Colors.grey[700]! 
                                    : Colors.grey[200]!,
                          ),
                        ),
                        child: locationState is LocationSelected
                            ? _buildSelectedLocationDisplay(
                                context, locationState, isDarkMode)
                            : _buildLocationPrompt(context, isDarkMode),
                      );
                    },
                  ),

                  SizedBox(height: 32.h),

                  // Payment Method Section
                  _buildSectionHeader(
                    context,
                    'Payment Method',
                    Icons.credit_card_rounded,
                    isRequired: true,
                  ),
                  SizedBox(height: 16.h),
                  PaymentMethodsListView(),

                  SizedBox(height: 32.h),

                  // Order Summary
                  Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(20.w),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
                      ),
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_rounded,
                              color: Theme.of(context).primaryColor,
                              size: 20.sp,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              'Order Summary',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).textTheme.bodyLarge?.color,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .primaryColor
                                    .withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                '\$${total.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24.h),

                  // Payment Button with Location Validation
                  BlocBuilder<LocationCubit, LocationState>(
                    builder: (context, locationState) {
                      bool hasLocation = locationState is LocationSelected;

                      return Container(
                        width: double.infinity,
                        height: 56.h,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: hasLocation
                              ? LinearGradient(
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.8),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                                    isDarkMode ? Colors.grey[700]! : Colors.grey[400]!,
                                  ],
                                ),
                          boxShadow: hasLocation
                              ? [
                                  BoxShadow(
                                    color: Theme.of(context)
                                        .primaryColor
                                        .withOpacity(0.3),
                                    spreadRadius: 1,
                                    blurRadius: 8,
                                    offset: const Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        child: ElevatedButton(
                          onPressed: hasLocation
                              ? () async {
                                  final selectedLocation = locationState;

                                  try {
                                    await OrderServices().saveOrderLocation(
                                      latitude:
                                          selectedLocation.location.latitude,
                                      longitude:
                                          selectedLocation.location.longitude,
                                      address: selectedLocation.address,
                                    );

                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content:
                                              Text("تم حفظ موقع الطلب بنجاح")),
                                    );
                                    _showOrderConfirmation(context, locationState, isDarkMode);

                                    // تابع أي خطوات أخرى (زي التنقل للصفحة التالية)
                                    // Navigator.push(...);
                                  } catch (e) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              "حدث خطأ أثناء حفظ الموقع: $e")),
                                    );
                                  }
                                }
                              : () {
                                  _showLocationRequiredDialog(context, isDarkMode);
                                },

                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            foregroundColor: Colors.white,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                hasLocation
                                    ? Icons.lock_rounded
                                    : Icons.location_off,
                                size: 20.sp,
                              ),
                              SizedBox(width: 8.w),
                              Text(
                                hasLocation
                                    ? 'Complete Order'
                                    : 'Select Location First',
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: MediaQuery.of(context).viewInsets.bottom),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon, {
    bool isRequired = false,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(6.w),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: Theme.of(context).primaryColor,
            size: 18.sp,
          ),
        ),
        SizedBox(width: 12.w),
        Text(
          title,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        if (isRequired) ...[
          SizedBox(width: 4.w),
          Text(
            '*',
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.red[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildSelectedLocationDisplay(
      BuildContext context, LocationSelected state, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.check_circle_rounded,
                color: Colors.green[600],
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Delivery Location Confirmed',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Text(
            state.address,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12.h),
          TextButton.icon(
            onPressed: () =>
                _openLocationPicker(context, state.location, state.address),
            icon: Icon(Icons.edit_location_alt, size: 16.sp),
            label: Text(
              'Change Location',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).primaryColor,
              ),
            ),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).primaryColor,
              padding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationPrompt(BuildContext context, bool isDarkMode) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        children: [
          Icon(
            Icons.add_location_alt_outlined,
            size: 40.sp,
            color: isDarkMode ? Colors.grey[500] : Colors.grey[400],
          ),
          SizedBox(height: 12.h),
          Text(
            'Select Delivery Location',
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Choose where you want your order delivered',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton.icon(
            onPressed: () => _openLocationPicker(context),
            icon: Icon(Icons.location_searching, size: 18.sp),
            label: Text('Choose Location'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
            ),
          ),
        ],
      ),
    );
  }

  void _openLocationPicker(
    BuildContext context, [
    LatLng? initialLocation,
    String? initialAddress,
  ]) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => LocationPickerWidget(
          initialLocation: initialLocation,
          initialAddress: initialAddress,
          onLocationSelected: (location, address) {
            context.read<LocationCubit>().selectLocation(location, address);
          },
        ),
      ),
    );
  }

  void _showLocationRequiredDialog(BuildContext context, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.location_off,
              color: Colors.orange[600],
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Location Required',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        content: Text(
          'Please select a delivery location before proceeding with your order.',
          style: TextStyle(
            fontSize: 14.sp,
            color: Theme.of(context).textTheme.bodyMedium?.color,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _openLocationPicker(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('Select Location'),
          ),
        ],
      ),
    );
  }

  void _showOrderConfirmation(
      BuildContext context, LocationSelected locationState, bool isDarkMode) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: isDarkMode ? Colors.grey[900] : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green[600],
              size: 24.sp,
            ),
            SizedBox(width: 12.w),
            Text(
              'Confirm Order',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).textTheme.bodyLarge?.color,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Please confirm your order details:',
              style: TextStyle(
                fontSize: 14.sp,
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.location_on,
                          size: 16.sp, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      SizedBox(width: 8.w),
                      Text(
                        'Delivery to:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    locationState.address,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    children: [
                      Icon(Icons.attach_money,
                          size: 16.sp, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7)),
                      SizedBox(width: 8.w),
                      Text(
                        'Total Amount:',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: Theme.of(context).textTheme.bodyMedium?.color,
              ),
            ),
          ),
          BlocProvider.value(
            value: BlocProvider.of<PaymenttCubit>(context),
            child: CustomButtonBlocConsumer(total: total),
          ),
        ],
      ),
    );
  }
}