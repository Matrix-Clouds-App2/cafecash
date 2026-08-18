import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_images.dart';
import '../../../core/utils/default_items_seeder.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController _gifController;
  Timer? _fallbackTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this)
      ..addStatusListener(_onGifStatusChanged);
    // Safety net فقط لو الـ GIF فشل يتحمّل/يشتغل، عشان الشاشة متفضلش عالقة.
    _fallbackTimer = Timer(const Duration(seconds: 5), _navigate);
  }

  @override
  void dispose() {
    _fallbackTimer?.cancel();
    _gifController.removeStatusListener(_onGifStatusChanged);
    _gifController.dispose();
    super.dispose();
  }

  void _onGifStatusChanged(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _navigate();
    }
  }

  Future<void> _navigate() async {
    if (_navigated || !mounted) return;
    _navigated = true;
    _fallbackTimer?.cancel();

    await DefaultItemsSeeder.seedIfNeeded();
    if (!mounted) return;

    final storage = getIt<LocalStorage>();
    if (storage.isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.layoutScreen, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.loginScreen, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SizedBox(
          child: Gif(
            controller: _gifController,
            autostart: Autostart.once,
            image: const AssetImage(AppImages.introGif),
            fit: BoxFit.contain,
            width: double.infinity,
            height: double.infinity,
          ),
        ),
      ),
    );
  }
}
