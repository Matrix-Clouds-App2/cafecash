import 'package:app_base/core/extensions/extensions.dart';
import 'package:flutter/material.dart';

import '../utils/app_images.dart';

class WatermarkBackground extends StatelessWidget {
  const WatermarkBackground({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(

          child: Center(
            child: Padding(
              padding: 130.paddingTop,
              child: IgnorePointer(
                child: Opacity(
                  opacity: 0.04,
                  child: Image.asset(AppImages.visitor, fit: BoxFit.cover),
                ),
              ),
            ),
          ),
        ),
        child,
      ],
    );
  }
}
