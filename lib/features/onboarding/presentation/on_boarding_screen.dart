import 'package:easy_localization/easy_localization.dart';
import 'package:app_base/core/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_colors.dart';
import '../../../core/utils/app_constants.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/locale_keys.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/widgets/image/custom_image.dart';

class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  final _pageController = PageController();
  int _currentPage = 0;
  List<_OnboardingSlide> _slides = [];

  List<_OnboardingSlide> _buildSlides() {
    return [
      _OnboardingSlide(
        imageUrl: AppImages.onboarding1,
        title: LocaleKeys.onboarding_slide1_title.tr(),
        subtitle: LocaleKeys.onboarding_slide1_subtitle.tr(),
      ),
      _OnboardingSlide(
        imageUrl: AppImages.onboarding2,
        title: LocaleKeys.onboarding_slide2_title.tr(),
        subtitle: LocaleKeys.onboarding_slide2_subtitle.tr(),
      ),
      _OnboardingSlide(
        imageUrl: AppImages.onboarding3,
        title: LocaleKeys.onboarding_slide3_title.tr(),
        subtitle: LocaleKeys.onboarding_slide3_subtitle.tr(),
      ),
    ];
  }

  bool get _isLast => _currentPage == _slides.length - 1;

  void _nextPage() {
    if (_isLast) {
      _finish();
    } else {
      _pageController.nextPage(
        duration: AppConstants.defaultAnimationDuration,
        curve: Curves.easeInOut,
      );
    }
  }

  void _finish() {
    getIt<LocalStorage>().setOnboardingSeen();
    Navigator.pushNamedAndRemoveUntil(
        context, Routes.loginScreen, (_) => false);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _slides = _buildSlides();
    // Guard: if page jumped beyond new slides count, clamp it
    if (_currentPage >= _slides.length) _currentPage = _slides.length - 1;
    final slides = _slides;
    final currentSlide = slides[_currentPage];

    final primaryColor = AppColors.primaryColor.themeColor;
    final accentGold = AppColors.accentGold.themeColor;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: 20.paddingHorizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ── Logo ────────────────────────────────────────────────────
              Center(
                child: Image.asset(
                  AppImages.logo3,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),

              // ── Image card (PageView) ────────────────────────────────────
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: slides.length,
                    onPageChanged: (i) => setState(() => _currentPage = i),
                    itemBuilder: (_, i) => SingleChildScrollView(
                      padding: 10.paddingBottom,
                      child: Column(
                        children: [
                          if (slides[i].imageUrl.isNotEmpty)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(30),
                              child: CustomImage(
                                image: slides[i].imageUrl,
                                fit: BoxFit.contain,
                                width: double.infinity,
                              ),
                            ),
                          16.height,
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: List.generate(
                              slides.length,
                              (j) => AnimatedContainer(
                                duration: AppConstants.shortAnimationDuration,
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                width: _currentPage == j ? 24 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: _currentPage == j
                                      ? primaryColor
                                      : primaryColor.withValues(alpha: 0.35),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                              ),
                            ),
                          ),
                          20.height,
                          AnimatedOpacity(
                            opacity: currentSlide.hasText ? 1.0 : 0.0,
                            duration: AppConstants.defaultAnimationDuration,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.defaultPadding),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  AppText(
                                    currentSlide.title,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.sp,
                                    textAlign: TextAlign.center,
                                    // height: 1.0,
                                  ),
                                  SizedBox(height: 16.h),
                                  AppText(
                                    currentSlide.subtitle,
                                    color: Colors.black.withValues(alpha: 0.9),
                                    height: 1.5,
                                    fontSize: 16.sp,
                                    maxLines: 20,
                                    fontWeight: FontWeight.w400,
                                    textAlign: TextAlign.center,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // ── Primary button ───────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.defaultPadding),
                child: CustomButton(
                  title: _isLast
                      ? LocaleKeys.onboarding_getStarted.tr()
                      : LocaleKeys.onboarding_next.tr(),
                  onTap: _nextPage,
                  color: _isLast ? accentGold : null,
                  borderColor: _isLast ? accentGold : null,
                  textColor: _isLast ? AppColors.primaryColor.themeColor : null,
                ),
              ),

              // ── Skip ─────────────────────────────────────────────────────
              Center(
                child: TextButton(
                  onPressed: _finish,
                  child: AppText(
                    LocaleKeys.onboarding_skip.tr(),
                    color: Colors.black.withValues(alpha: 0.70),
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

// ── Data model ───────────────────────────────────────────────────────────────

class _OnboardingSlide {
  const _OnboardingSlide({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  final String imageUrl;
  final String title;
  final String subtitle;

  bool get hasText => title.isNotEmpty;
}
