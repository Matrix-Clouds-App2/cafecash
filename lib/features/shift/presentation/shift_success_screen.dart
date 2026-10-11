import 'dart:io';
import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_overlay.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../data/models/shift_reconciliation.dart';
import '../data/models/shift_summary.dart';
import 'widgets/shift_confetti_overlay.dart';
import 'widgets/shift_reconciliation_report_card.dart';
import 'widgets/shift_success_card.dart';

class ShiftSuccessScreen extends StatefulWidget {
  const ShiftSuccessScreen({
    super.key,
    required this.summary,
    required this.reconciliation,
  });

  final ShiftSummary summary;
  final ShiftReconciliation reconciliation;

  @override
  State<ShiftSuccessScreen> createState() => _ShiftSuccessScreenState();
}

class _ShiftSuccessScreenState extends State<ShiftSuccessScreen> {
  final GlobalKey _cardBoundaryKey = GlobalKey();
  bool _isSharingCard = false;
  bool _isSharingWhatsapp = false;

  String get _shareMessage {
    final summary = widget.summary;
    return '${LocaleKeys.shift_success_shareMessage.tr()}\n'
        '${LocaleKeys.treasury_totalIncome.tr()}: '
        '${summary.totalIncome.toStringAsFixed(0)} ${LocaleKeys.common_currency.tr()}'
        '\n\n${AppConstants.appName}\n${AppConstants.storeUrl}';
  }

  Future<File?> _captureCardImage() async {
    final boundary = _cardBoundaryKey.currentContext?.findRenderObject()
        as RenderRepaintBoundary?;
    if (boundary == null) return null;

    final image = await boundary.toImage(pixelRatio: 3);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return null;

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}/shift_success_${DateTime.now().millisecondsSinceEpoch}.png',
    );
    return file.writeAsBytes(byteData.buffer.asUint8List());
  }

  Future<void> _shareCard() => _share(
        setLoading: (v) {
          if (mounted) setState(() => _isSharingCard = v);
        },
      );

  Future<void> _shareToWhatsapp() => _share(
        setLoading: (v) {
          if (mounted) setState(() => _isSharingWhatsapp = v);
        },
      );

  Future<void> _share({required void Function(bool) setLoading}) async {
    if (_isSharingCard || _isSharingWhatsapp) return;
    setLoading(true);
    try {
      final file = await _captureCardImage();
      if (file != null) {
        await SharePlus.instance.share(
          ShareParams(text: _shareMessage, files: [XFile(file.path)]),
        );
      } else {
        await SharePlus.instance.share(ShareParams(text: _shareMessage));
      }
    } catch (_) {
      AppOverlay.showError(LocaleKeys.shift_success_shareFailed.tr());
    } finally {
      setLoading(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isBalanced = widget.reconciliation.isBalanced;
    final showConfetti = isBalanced || widget.reconciliation.isSurplus;

    return PopScope(
      canPop: true,
      child: Scaffold(
        backgroundColor: AppColors.backgroundColor.themeColor,
        body: Stack(
          children: [
            if (showConfetti) const Positioned.fill(child: ShiftConfettiOverlay()),
            SafeArea(
              child: Center(
                child: SingleChildScrollView(
                  padding: 24.paddingAll,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (isBalanced)
                        RepaintBoundary(
                          key: _cardBoundaryKey,
                          child: ShiftSuccessCard(summary: widget.summary),
                        )
                      else
                        ShiftReconciliationReportCard(
                          reconciliation: widget.reconciliation,
                        ),
                      28.height,
                      if (isBalanced) ...[
                        CustomButton(
                          color: AppColors.accentGold.themeColor,
                          borderColor: AppColors.accentGold.themeColor,
                          loading: _isSharingCard,
                          onTap: _shareCard,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.ios_share_rounded,
                                  color: Colors.white, size: 18.sp),
                              8.width,
                              AppText(
                                LocaleKeys.shift_success_shareButton.tr(),
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        12.height,
                        CustomButton(
                          isOutlined: true,
                          borderColor: const Color(0xFF25D366),
                          loading: _isSharingWhatsapp,
                          onTap: _shareToWhatsapp,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const FaIcon(FontAwesomeIcons.whatsapp,
                                  color: Color(0xFF25D366), size: 18),
                              8.width,
                              AppText(
                                LocaleKeys.shift_success_shareWhatsapp.tr(),
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF25D366),
                              ),
                            ],
                          ),
                        ),
                        18.height,
                      ],
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: AppText(
                          LocaleKeys.shift_success_continueButton.tr(),
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textSecondaryColor.themeColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
