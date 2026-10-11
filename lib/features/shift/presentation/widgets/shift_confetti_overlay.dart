import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';

import '../../../../core/utils/app_colors.dart';

class ShiftConfettiOverlay extends StatefulWidget {
  const ShiftConfettiOverlay({super.key});

  @override
  State<ShiftConfettiOverlay> createState() => _ShiftConfettiOverlayState();
}

class _ShiftConfettiOverlayState extends State<ShiftConfettiOverlay> {
  late final ConfettiController _topLeftController;
  late final ConfettiController _topRightController;
  late final ConfettiController _topCenterController;

  @override
  void initState() {
    super.initState();
    _topLeftController =
        ConfettiController(duration: const Duration(seconds: 3));
    _topRightController =
        ConfettiController(duration: const Duration(seconds: 3));
    _topCenterController =
        ConfettiController(duration: const Duration(seconds: 3));
    WidgetsBinding.instance.addPostFrameCallback((_) => _blast());
  }

  void _blast() {
    _topLeftController.play();
    _topRightController.play();
    _topCenterController.play();
  }

  @override
  void dispose() {
    _topLeftController.dispose();
    _topRightController.dispose();
    _topCenterController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      AppColors.accentGold.themeColor,
      AppColors.primaryColor.themeColor,
      AppColors.successColor.themeColor,
      AppColors.secondaryColor.themeColor,
      AppColors.infoColor.themeColor,
    ];

    return IgnorePointer(
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ConfettiWidget(
              confettiController: _topLeftController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 22,
              maxBlastForce: 28,
              minBlastForce: 10,
              gravity: 0.25,
              colors: colors,
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: ConfettiWidget(
              confettiController: _topRightController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 22,
              maxBlastForce: 28,
              minBlastForce: 10,
              gravity: 0.25,
              colors: colors,
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _topCenterController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 30,
              maxBlastForce: 20,
              minBlastForce: 6,
              gravity: 0.3,
              colors: colors,
            ),
          ),
        ],
      ),
    );
  }
}
