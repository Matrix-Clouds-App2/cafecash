import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_text.dart';
import 'package:coffee_shop/core/widgets/expandable_html.dart';
import 'package:coffee_shop/core/widgets/image/custom_image.dart';

class SliderDetailsScreen extends StatelessWidget {
  const SliderDetailsScreen({
    super.key,
    required this.title,
    required this.image,
    required this.mainTitle,
    required this.description,
  });

  final String title;
  final String image;
  final String mainTitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;
    final pageTitle = title.trim().isNotEmpty ? title.trim() : mainTitle.trim();
    final headingTitle = mainTitle.trim();
    final hasDescription = description.trim().isNotEmpty;
    final hasTextContent = headingTitle.isNotEmpty || hasDescription;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F3),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        centerTitle: true,
        title: AppText(
          pageTitle,
          fontSize: 16,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(22.r),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: image.isNotEmpty
                    ? CustomImage(
                        image: image,
                        fit: BoxFit.fill,
                      )
                    : Container(
                        color:
                            AppColors.primaryColor.themeColor.withValues(alpha: 0.12),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.image_outlined,
                          size: 46.sp,
                          color: AppColors.primaryColor.themeColor,
                        ),
                      ),
              ),
            ),
            14.height,
            if (hasTextContent)
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(14.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(
                    color:
                        AppColors.primaryColor.themeColor.withValues(alpha: 0.07),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (headingTitle.isNotEmpty)
                      AppText(
                        headingTitle,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimaryColor.themeColor,
                      ),
                    if (headingTitle.isNotEmpty && hasDescription) 8.height,
                    if (hasDescription)
                      ExpandableHtml(
                        data: description,
                        collapsedLines: 8,
                        fadeColor: Colors.white,
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}

