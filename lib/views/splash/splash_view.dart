import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

import '../../routes/app_routes.dart';
import '../../services/storage_service.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  final StorageService _storage = StorageService();

  LottieComposition? _composition;
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _loadLottie();
  }

  /// 🔹 Preload Lottie (CRITICAL FIX)
  Future<void> _loadLottie() async {
    final composition = await AssetLottie('assets/lottie/splash.json').load();

    if (!mounted) return;

    setState(() {
      _composition = composition;
      _visible = true;
    });

    _bootstrap();
  }

  Future<void> _bootstrap() async {
    // Let animation play smoothly
    await Future.delayed(const Duration(milliseconds: 2200));

    final bool isLoggedIn = await _storage.isLoggedIn();
    if (!mounted) return;

    Get.offAllNamed(isLoggedIn ? AppRoutes.home : AppRoutes.login);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF673AB7), // Deep Purple
              Color(0xFF9C27B0), // Purple
            ],
          ),
        ),
        child: Center(
          child: AnimatedOpacity(
            opacity: _visible ? 1 : 0,
            duration: const Duration(milliseconds: 500),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // ================= LOTTIE =================
                if (_composition != null)
                  SizedBox(
                    height: 220,
                    child: Lottie(
                      composition: _composition!,
                      repeat: true,
                      frameRate: FrameRate.max,
                    ),
                  ),

                const SizedBox(height: 24),

                const Text(
                  'Inventory Management',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),

                const SizedBox(height: 18),

                const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.4,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
