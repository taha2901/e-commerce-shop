import 'package:ecommerce_app/features/location_picker/logic/location_cubit.dart';
import 'package:ecommerce_app/features/location_picker/logic/location_state.dart';
import 'package:ecommerce_app/features/location_picker/ui/location_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class CheckoutLocationWidget extends StatelessWidget {
  const CheckoutLocationWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        return Container(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(8.w),
                      decoration: BoxDecoration(
                        color: theme.primaryColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        Icons.location_on_rounded,
                        color: theme.primaryColor,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 12.w),
                    Text(
                      'Delivery Location',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.textTheme.bodyLarge?.color,
                        fontSize: 18.sp,
                      ),
                    ),
                  ],
                ),
              ),

              // Location Content
              if (state is LocationSelected)
                _buildSelectedLocation(context, state)
              else
                _buildSelectLocationPrompt(context),

              SizedBox(height: 16.h),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSelectedLocation(BuildContext context, LocationSelected state) {
    final theme = Theme.of(context);
    final greenShade = theme.colorScheme.secondary.withOpacity(0.1);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          // Selected location display
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: theme.colorScheme.secondary,
                      size: 20.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'Location Selected',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  state.address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 14.sp,
                    color: theme.textTheme.bodySmall?.color,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Lat: ${state.location.latitude.toStringAsFixed(6)}, '
                  'Lng: ${state.location.longitude.toStringAsFixed(6)}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 12.sp,
                    color: theme.hintColor,
                    fontFamily: 'monospace',
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 16.h),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    _openLocationPicker(context, state.location, state.address);
                  },
                  icon: Icon(Icons.edit_location_alt, size: 18.sp),
                  label: Text(
                    'Change',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: theme.primaryColor,
                    side: BorderSide(color: theme.primaryColor),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    context.read<LocationCubit>().clearLocation();
                  },
                  icon: Icon(Icons.clear, size: 18.sp),
                  label: Text(
                    'Remove',
                    style: TextStyle(fontSize: 14.sp),
                  ),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.red[600],
                    side: BorderSide(color: Colors.red[600]!),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectLocationPrompt(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              color: theme.dividerColor.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.add_location_alt_rounded,
              size: 40.sp,
              color: theme.dividerColor,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'No delivery location selected',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: theme.textTheme.bodyLarge?.color,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'Please select your delivery location to continue with checkout',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 14.sp,
              color: theme.hintColor,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            height: 48.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  theme.primaryColor,
                  theme.primaryColor.withOpacity(0.8),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: ElevatedButton.icon(
              onPressed: () => _openLocationPicker(context),
              icon: Icon(Icons.location_searching, size: 20.sp),
              label: Text(
                'Select Location',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.transparent,
                foregroundColor: Colors.white,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
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
}

class MiniLocationDisplay extends StatelessWidget {
  final VoidCallback? onTap;
  final bool showEditButton;

  const MiniLocationDisplay({
    super.key,
    this.onTap,
    this.showEditButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<LocationCubit, LocationState>(
      builder: (context, state) {
        if (state is! LocationSelected) {
          return GestureDetector(
            onTap: onTap,
            child: Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: theme.dividerColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: theme.dividerColor),
              ),
              child: Row(
                children: [
                  Icon(Icons.location_off, color: theme.hintColor, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Select delivery location',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.hintColor,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                  if (showEditButton)
                    Icon(Icons.arrow_forward_ios, 
                         color: theme.hintColor.withOpacity(0.6), size: 16.sp),
                ],
              ),
            ),
          );
        }

        return GestureDetector(
          onTap: onTap,
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.secondary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.secondary.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.location_on, color: theme.colorScheme.secondary, size: 20.sp),
                SizedBox(width: 8.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Delivery to:',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.secondary,
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        state.address,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.textTheme.bodyLarge?.color,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                if (showEditButton)
                  Icon(Icons.edit, color: theme.colorScheme.secondary, size: 16.sp),
              ],
            ),
          ),
        );
      },
    );
  }
}
