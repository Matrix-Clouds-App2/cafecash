import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:app_base/core/widgets/app_text.dart';
import 'package:app_base/core/widgets/screen_state_layout.dart';

import '../../../core/utils/app_colors.dart';
import '../../../core/utils/locale_keys.dart';
import '../logic/terms_cubit.dart';
import '../logic/terms_state.dart';

class TermsScreen extends StatefulWidget {
  const TermsScreen({super.key});

  @override
  State<TermsScreen> createState() => _TermsScreenState();
}

class _TermsScreenState extends State<TermsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<TermsCubit>().loadTerms();
  }

  @override
  Widget build(BuildContext context) {
    final primary = AppColors.primaryColor.themeColor;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F5F3),
      appBar: AppBar(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: AppText(
          LocaleKeys.terms_title.tr(),
          fontSize: 17,
          fontWeight: FontWeight.w700,
          color: Colors.white,
        ),
      ),
      body: BlocBuilder<TermsCubit, TermsState>(
        builder: (context, state) {
          final isLoading = state is TermsLoading || state is TermsInitial;
          final errorState = state is TermsError ? state : null;
          final content = state is TermsSuccess ? state.content : '';
          final isEmpty = state is TermsSuccess && content.isEmpty;

          return CustomScreenStateLayout(
            isLoading: isLoading,
            isEmpty: isEmpty,
            error: errorState != null
                ? ErrorModel(
                    code: ErrorEnum.other,
                    errorMessage: errorState.message,
                  )
                : null,
            onRetry: () => context.read<TermsCubit>().loadTerms(),
            onRefresh: () async => context.read<TermsCubit>().loadTerms(),
            builder: (_) => SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 24.h),
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20.r),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // // ── Header ──────────────────────────────────────────────
                    // Row(
                    //   children: [
                    //     Container(
                    //       width: 40.r,
                    //       height: 40.r,
                    //       decoration: BoxDecoration(
                    //         shape: BoxShape.circle,
                    //         color: primary.withValues(alpha: 0.1),
                    //       ),
                    //       child: Icon(Icons.gavel_rounded,
                    //           color: primary, size: 20.sp),
                    //     ),
                    //     12.width,
                    //     AppText(
                    //       LocaleKeys.terms_title.tr(),
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w700,
                    //       color: AppColors.textPrimaryColor.themeColor,
                    //     ),
                    //   ],
                    // ),
                    // 16.height,
                    // Divider(color: Colors.grey.shade100, thickness: 1),
                    // 16.height,

                    // ── Content ─────────────────────────────────────────────
                    AppText(
                      content,
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: AppColors.textSecondaryColor.themeColor,
                      height: 1.8,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
