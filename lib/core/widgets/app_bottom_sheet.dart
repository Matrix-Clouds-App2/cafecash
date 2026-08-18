import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/extensions.dart';
import '../utils/app_colors.dart';
import 'app_text.dart';

class AppBottomSheet extends StatelessWidget {
  const AppBottomSheet({super.key, required this.title, required this.child});

  final String title;
  final Widget child;

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    required Widget child,
  }) {
    return showModalBottomSheet<T>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AppBottomSheet(title: title, child: child),
    );
  }

  @override
  Widget build(BuildContext context) {
    // `showModalBottomSheet` doesn't lift its content above the keyboard on
    // its own — without this, any text field in [child] opens hidden behind
    // it. The keyboard inset goes on the *scroll view's own padding*, not on
    // an outer `Padding`/`AnimatedPadding` wrapping the whole decorated
    // sheet: that would force the rounded/shadowed container (plus
    // everything inside it) to re-layout on every single frame the keyboard
    // animates, which is what actually read as "heavy". Padding the scroll
    // view instead leaves the chrome's layout untouched — only the scroll
    // offset moves — and `Scrollable`'s built-in focus-tracking scrolls the
    // active field into the extra room automatically.
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.cardColor.themeColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppColors.primaryColor.themeColor,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
              16.height,
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      width: 36.r,
                      height: 36.r,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceColor.themeColor,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.close_rounded,
                          size: 18.sp,
                          color: AppColors.textSecondaryColor.themeColor),
                    ),
                  ),
                  const Spacer(),
                  AppText(
                    title,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimaryColor.themeColor,
                  ),
                  const Spacer(),
                  SizedBox(width: 36.r),
                ],
              ),
              20.height,
              child,
            ],
          ),
        ),
      ),
    );
  }
}
