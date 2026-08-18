import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/widgets/primary_header.dart';

class AuthHeaderSection extends StatelessWidget {
  const AuthHeaderSection({super.key, required this.image});

  final String image;

  @override
  Widget build(BuildContext context) {
    return PrimaryHeader(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Center(
          child: Image.asset(
            image,
            // width: 220.w,
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
