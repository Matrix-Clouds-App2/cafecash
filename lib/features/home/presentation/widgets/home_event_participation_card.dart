import 'package:coffee_shop/core/utils/app_images.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// The large card showing the Saudi delegation's participation banner image.
///
/// Uses [AppImages.onboarding1] as placeholder until a dedicated asset is
/// provided.  The card has rounded corners and fills its full width.
class HomeEventParticipationCard extends StatelessWidget {
  const HomeEventParticipationCard({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: AspectRatio(
          aspectRatio: 16 / 10,
          child: Image.asset(
            AppImages.onboarding1,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

