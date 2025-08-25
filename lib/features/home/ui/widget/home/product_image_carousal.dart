import 'package:cached_network_image/cached_network_image.dart';
import 'package:ecommerce_app/features/home/data/home_carousal_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProductImageCarousel extends StatelessWidget {
  final dynamic state;
  const ProductImageCarousel({
    super.key,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterCarousel.builder(
          itemCount: dummyHomeCarouselItems.length,
          itemBuilder: (context, index, realIndex) {
            final item = dummyHomeCarouselItems[index];
            return CachedNetworkImage(
              imageUrl: item.imgUrl,
              width: screenWidth,
              fit: BoxFit.cover,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator.adaptive(),
              ),
              errorWidget: (context, url, error) => Icon(
                Icons.broken_image_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
            );
          },
          options: FlutterCarouselOptions(
            height: 200.h,
            autoPlay: true,
            viewportFraction: 1,
            showIndicator: true,
            slideIndicator: CircularWaveSlideIndicator(),
          ),
        ),
      ),
    );
  }
}
