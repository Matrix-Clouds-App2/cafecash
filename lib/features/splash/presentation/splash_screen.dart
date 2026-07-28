import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif/gif.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_images.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController _gifController;
  Timer? _minTimer;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _minTimer = Timer(const Duration(seconds: 2), _navigate);
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _gifController.dispose();
    super.dispose();
  }

  void _navigate() {
    if (_navigated || !mounted) return;
    _navigated = true;
    final storage = getIt<LocalStorage>();
    if (storage.isLoggedIn) {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.layoutScreen, (_) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
          context, Routes.onBoardingScreen, (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox.expand(
        child: Gif(
          controller: _gifController,
          autostart: Autostart.loop,
          image: const AssetImage(AppImages.introGif),
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
      ),
    );
  }
}
