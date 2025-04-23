// ignore_for_file: file_names

import 'package:cars_appointments/Screens/auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool _isAnimationCompleted = false;
  final int _animationSpeed = 3;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

@override
void dispose() {
  _controller.removeListener(_navigateToHome);
  _controller.dispose();
  super.dispose();
}

  void _navigateToHome() {
    if (!_isAnimationCompleted) {
      _isAnimationCompleted = true;
      Get.off(
        () => const OnboardingSignUpScreen(),
        transition: Transition.fadeIn,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/lottie/lottie1.json',
          controller: _controller,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration ~/ _animationSpeed
              ..forward().then((_) => _navigateToHome());
          },
          width: 1000,
          height: 1000,
          frameRate: const FrameRate(60),
          errorBuilder: (context, error, stackTrace) =>
          const CircularProgressIndicator(),
        )
      ),
    );
  }
}