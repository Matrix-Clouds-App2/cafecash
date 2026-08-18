import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router/routes.dart';
import '../../../core/extensions/extensions.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_empty.dart';
import '../../../core/widgets/custom_loading_widget.dart';
import '../logic/shift_cubit.dart';
import 'widgets/shift_history_card.dart';

class ShiftHistoryScreen extends StatelessWidget {
  const ShiftHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: AppColors.surfaceColor.themeColor,
      appBar: AppBar(
          title: Text(LocaleKeys.shift_historyTitle.tr()),
          backgroundColor: primary,
          foregroundColor: AppColors.textPrimaryColor.themeColor),
      body: BlocBuilder<ShiftCubit, ShiftState>(
        builder: (context, state) {
          if (state is! ShiftReady) {
            return Center(
              child: CustomLoadingWidget(color: primary, size: 40),
            );
          }

          final history = state.history;
          if (history.isEmpty) {
            return AppEmpty(
              message: LocaleKeys.shift_historyEmpty.tr(),
              icon: Icons.history_rounded,
            );
          }

          return ListView.separated(
            padding: 16.paddingAll,
            itemCount: history.length,
            separatorBuilder: (_, __) => 14.height,
            itemBuilder: (_, i) {
              final shift = history[i];
              return ShiftHistoryCard(
                shift: shift,
                onTap: () => context.pushNamed(
                  Routes.shiftSummaryScreen,
                  arguments: {'shift': shift},
                ),
              );
            },
          );
        },
      ),
    );
  }
}
