import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_constants.dart';
import '../../../../core/widgets/custom_tap_effect.dart';

class HallAddTableCard extends StatelessWidget {
  const HallAddTableCard({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final accent = AppColors.accentGold.themeColor;

    return CustomTapEffect(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surfaceColor.themeColor,
          borderRadius: BorderRadius.circular(AppConstants.cardBorderRadius),
          border: Border.all(color: accent.withValues(alpha: 0.5), width: 1.4),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = (constraints.maxWidth * 0.4).clamp(20.0, 44.0);
            return Center(
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.add_rounded, color: accent, size: size * 0.6),
              ),
            );
          },
        ),
      ),
    );
  }
}
