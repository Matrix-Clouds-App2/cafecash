import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/widgets/app_text.dart';

class AuthFieldLabel extends StatelessWidget {
  const AuthFieldLabel({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AppText(
        text,
        fontSize: 14,
        color: AppColors.textPrimaryColor.themeColor,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}
