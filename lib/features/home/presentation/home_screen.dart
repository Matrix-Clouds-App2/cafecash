 import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:geolocator/geolocator.dart';
import 'package:coffee_shop/core/extensions/extensions.dart';
import 'package:coffee_shop/core/utils/app_colors.dart';
import 'package:coffee_shop/core/widgets/app_button.dart';
import 'package:coffee_shop/core/widgets/custom_loading_widget.dart';
import 'package:coffee_shop/core/widgets/screen_state_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../app/router/routes.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/convert_helper.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/image/custom_image_slider.dart';
import '../../../main.dart';
import '../../home/logic/home_cubit.dart';
import 'widgets/home_countdown_section.dart';
import 'widgets/home_header.dart';
import 'widgets/home_participants_section.dart';
import 'widgets/home_quick_access_section.dart';
import 'widgets/home_sessions_section.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static final _fallbackDate = DateTime(2026, 5, 17);

  late Timer _timer;
  Duration _remaining = Duration.zero;

  @override
  void initState() {
    super.initState();
    _updateCountdown();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _updateCountdown());
  }

  DateTime _resolveEventDate() {
    final state = context.read<HomeCubit>().state;
    if (state is HomeSuccess) {
      return state.home.settings.startDate ?? _fallbackDate;
    }
    return _fallbackDate;
  }

  void _updateCountdown() {
    final eventDate = _resolveEventDate();
    final diff = eventDate.difference(DateTime.now());
    if (mounted) {
      setState(() => _remaining = diff.isNegative ? Duration.zero : diff);
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }
  Position? _calPosA;
  Position? _calPosB;
  final bool _isSettingStart = true;
  void _goTo(int page) => Navigator.pushNamed(
        context,
        Routes.layoutScreen,
        arguments: {'currentPage': page},
      );

  void _onSliderTap(int index) {
    final state = context.read<HomeCubit>().state;
    if (state is! HomeSuccess) return;
    if (index < 0 || index >= state.home.sliders.length) return;

    final slider = state.home.sliders[index];
    if (!slider.hasDetailsContent) return;

    Navigator.pushNamed(
      context,
      Routes.sliderDetailsScreen,
      arguments: {
        'title': slider.title,
        'image': slider.image,
        'mainTitle': slider.mainTitle,
        'description': slider.description,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<HomeCubit>().state;

    final home = state is HomeSuccess ? state.home : null;
    final settings = home?.settings;

    final isLoading = state is HomeLoading || state is HomeInitial;
    final error = state is HomeError
        ? ErrorModel(code: ErrorEnum.other, errorMessage: state.message)
        : null;

    final days = _remaining.inDays;
    final hours = _remaining.inHours.remainder(24);
    final minutes = _remaining.inMinutes.remainder(60);
    final seconds = _remaining.inSeconds.remainder(60);
    final showCountdown = _remaining > Duration.zero;

    return Scaffold(
      // backgroundColor: AppColors.primaryColor.themeColor,
      body: RefreshIndicator(
        onRefresh: () async => context.read<HomeCubit>().loadHome(),
        color: AppColors.primaryColor.themeColor,
        child: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ──────────────────────────────────────────────────────
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  padding: 12.paddingHorizontal,
                  color: AppColors.primaryColor.themeColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      40.height,
                      Row(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              AppText(
                                LocaleKeys.home_welcome.tr(),
                                textAlign: TextAlign.end,
                                fontSize: 13.sp,

                                fontWeight: FontWeight.w500,
                                color: Colors.white.withValues(alpha: 0.75),
                              ),

                            ],
                          ),

                          const Spacer(),
                          ChatIconButton(onTap: (){
                            Navigator.pushNamed(context, Routes.liveForumScreen);
                          }),


                        ],
                      ),
                      // 10.width,
                      AppText(
                        kUserModel?.name ?? '',
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                      12.height,
                      if(settings?.eventTitle.isNotEmpty == true)
                        Container(
                          width: double.infinity,
                          color: AppColors.primaryColor.themeColor,
                          padding: 16.paddingHorizontal+20.paddingBottom,
                          child: EventInfoCard(
                            title: settings?.eventTitle,
                            endDates: settings?.eventEndDate,
                            startDates: settings?.eventStartDate,
                            location: settings?.eventLocation,
                          ),
                        ),
                    ],
                  ),
                ),
                PositionedDirectional(
                  top: -65.h,
                  end: -55.w,
                  child: IgnorePointer(
                    child: Container(
                      width: 170.h,
                      height: 170.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.accentGold.themeColor
                            .withValues(alpha: 0.12),
                      ),
                    ),
                  ),
                ),
              ],
            ),



            // ── Scrollable body ──────────────────────────────────────────────
            Container(
              color: const Color(0xFFF4F5F3),
              child: CustomScreenStateLayout(
                isLoading: isLoading,
                error: error,
                onRetry: () => context.read<HomeCubit>().loadHome(),
                loadingBuilder: (context)=>Container(
                  width: double.infinity,
                  height: MediaQuery.sizeOf(context).height*0.8,
                  color: Colors.white,
                  child:  Center(child: CustomLoadingWidget(color: AppColors.primaryColor.themeColor,)),
                ),
                onRefresh: () async => context.read<HomeCubit>().loadHome(),
                builder: (_) => Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(
                    horizontal: 18.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // ── Sliders ───────────────────────────────────────
                      if (home!.sliders.isNotEmpty)
                        CustomImageSlider(
                          height: 144.h,
                          margin: EdgeInsets.zero,
                          imageWidth: 500.w,
                          width: double.infinity,
                          radius: 24,
                          viewportFraction: 0.96,
                          itemHorizontalPadding: 2,
                          sliders: home.sliders.map((s) => s.image).toList(),
                          onTap: _onSliderTap,
                        ),

                      20.verticalSpace,

                      // ── Countdown ─────────────────────────────────────
                      if (showCountdown) ...[
                       HomeCountdownSection(
                        days: days,
                        hours: hours,
                        minutes: minutes,
                        seconds: seconds,
                        startDates:
                        ConvertHelper.formatDateTime(  settings?.eventStartDate??'')

                      ),
                      20.verticalSpace,],
                      // ── Participants ───────────────────────────────────
                      HomeParticipantsSection(
                        participants: home.participatingDelegations,
                        onCtaTap: () => Navigator.pushNamed(
                            context, Routes.participantsScreen),
                      ),
                      20.verticalSpace,

                      // ── Quick access ───────────────────────────────────
                      HomeQuickAccessSection(
                        onMediaTap: () => _goTo(1),
                        onAgendaTap: () => _goTo(
                        (isAfterTwoDaysResult==true)?3:

                          2),
                        onMapTap: () => Navigator.pushNamed(context, Routes.expoMapScreen),
                        onExhibitorsTap: () => Navigator.pushNamed(
                            context, Routes.exhibitorsScreen),
                        onHelpTap: () {
                          _goTo(
                              2
                          );
                        },
                        onAssistantTap: () => Navigator.pushNamed(
                            context, Routes.exploreScreen),
                      ),
                      22.verticalSpace,

                      // ── Today sessions ─────────────────────────────────
                      HomeSessionsSection(
                        forums: home.forums,
                        categories: home.categories,
                      ),
                      // 24.verticalSpace,
                      // CustomButton(
                      //   title: _isSettingStart ? '📍 سجل بداية الشقة' : '📍 سجل نهاية الشقة',
                      //   onTap: () async {
                      //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      //     //     CalibrationScreen()
                      //     // ));
                      //     // return;
                      //     final pos = await Geolocator.getCurrentPosition();
                      //
                      //     if (_isSettingStart) {
                      //       _calPosA = pos;
                      //
                      //       setState(() {
                      //         _isSettingStart = false;
                      //       });
                      //
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(content: Text('تم تسجيل بداية الشقة')),
                      //       );
                      //
                      //     } else {
                      //       _calPosB = pos;
                      //
                      //       if (_calPosA != null && _calPosB != null) {
                      //
                      //         // final calibration = CalibrationModel(
                      //         //   latA: _calPosA!.latitude,
                      //         //   lngA: _calPosA!.longitude,
                      //         //   latB: _calPosB!.latitude,
                      //         //   lngB: _calPosB!.longitude,
                      //         // );
                      //
                      //         // Navigator.push(context, MaterialPageRoute(builder: (context)=>
                      //         // IndoorMapScreen(calibration: calibration,)
                      //         // ));
                      //         // 🔥 نخزنها مؤقتًا أو نبعتهـا
                      //         // Navigator.pushNamed(
                      //         //   context,
                      //         //   Routes.indoorMapScreen,
                      //         //   arguments: calibration,
                      //         // );
                      //       }
                      //
                      //       setState(() {
                      //         _isSettingStart = true;
                      //       });
                      //     }
                      //   },
                      // )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
