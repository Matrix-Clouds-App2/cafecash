import 'package:flutter/material.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class ContentSection extends StatelessWidget {
  const ContentSection({super.key, required this.title, required this.body});

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppText(
          title,
          fontSize: 15,
          fontWeight: FontWeight.w700,
          color: AppColors.textPrimaryColor.themeColor,
        ),
        8.height,
        AppText(
          body,
          fontSize: 13.5,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondaryColor.themeColor,
          height: 1.6,
        ),
        20.height,
      ],
    );
  }
}
