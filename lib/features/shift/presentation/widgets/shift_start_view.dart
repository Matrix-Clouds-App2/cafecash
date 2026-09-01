import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/extensions/extensions.dart';
import '../../../../core/utils/app_colors.dart';
import '../../../../core/utils/app_overlay.dart';
import '../../../../core/utils/locale_keys.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_text.dart';
// import '../../../sync/presentation/download_bootstrap_flow.dart';
import '../../logic/shift_cubit.dart';
import 'shift_amount_card.dart';

class ShiftStartView extends StatefulWidget {
  const ShiftStartView({super.key});

  @override
  State<ShiftStartView> createState() => _ShiftStartViewState();
}

class _ShiftStartViewState extends State<ShiftStartView> {
  final _amountCtrl = TextEditingController();

  @override
  void dispose() {
    _amountCtrl.dispose();
    super.dispose();
  }

  void _start(BuildContext context) {
    final amount = double.tryParse(_amountCtrl.text.trim());
    if (amount == null || amount < 0) {
      AppOverlay.showError(LocaleKeys.shift_amountInvalid.tr());
      return;
    }

    // مزامنة اختيارية عند فتح الوردية (متوقفة — المزامنة الإجبارية بعد تسجيل الدخول):
    // await offerBootstrapDownload(context);
    // if (!context.mounted) return;
    context.read<ShiftCubit>().startShift(amount);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: 16.paddingAll,
            child: ShiftAmountCard(controller: _amountCtrl),
          ),
        ),
        Padding(
          padding: EdgeInsetsDirectional.fromSTEB(16.w, 0, 16.w, 20.h),
          child: CustomButton(
            onTap: () => _start(context),
            color: AppColors.successColor.themeColor,
            customRadius: 28,
            height: 56,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AppText(
                  LocaleKeys.shift_startButton.tr(),
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
                8.width,
                Icon(Icons.play_arrow_rounded,
                    color: Colors.white, size: 20.sp),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
