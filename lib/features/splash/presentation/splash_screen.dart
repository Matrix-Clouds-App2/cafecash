import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gif/gif.dart';

import '../../../app/router/routes.dart';
import '../../../core/di/injection.dart';
import '../../../core/storage/local_storage.dart';
import '../../../core/utils/app_images.dart';
import '../../home/logic/home_cubit.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final GifController _gifController;
  Timer? _minTimer;
  Timer? _maxWaitTimer;
  bool _navigated = false;
  bool _minDelayDone = false;
  bool _settingsDone = false;
  bool _homeDone = false;
  bool _forceProceed = false;

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);
    _minTimer = Timer(const Duration(seconds: 2), () {
      _minDelayDone = true;
      _tryNavigate();
    });
    _maxWaitTimer = Timer(const Duration(seconds: 12), () {
      _forceProceed = true;
      _tryNavigate();
    });
    context.read<HomeCubit>().loadHome();
  }

  @override
  void dispose() {
    _minTimer?.cancel();
    _maxWaitTimer?.cancel();
    _gifController.dispose();
    super.dispose();
  }

  void _tryNavigate() {
    final apiFinished = _settingsDone && _homeDone;
    if ((apiFinished || _forceProceed) && _minDelayDone) {
      _navigate();
    }
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
    return MultiBlocListener(
      listeners: [

        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeSuccess || state is HomeError) {
              _homeDone = true;
              _tryNavigate();
            }
          },
        ),
      ],
      child: Scaffold(
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
      ),
    );
  }
}
