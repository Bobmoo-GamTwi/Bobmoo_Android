import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/screens/loading_screen.dart';
import 'package:bobmoo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  static const Duration _minimumSplashDuration = Duration(milliseconds: 1000);

  // 한번만 실행되게 가드역할
  bool _redirected = false;
  bool _isSplashVisible = true;

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(_minimumSplashDuration, () {
      if (!mounted) return;
      setState(() => _isSplashVisible = false);
      _tryRedirect();
    });
  }

  void _tryRedirect() {
    if (_redirected || _isSplashVisible) return;

    final univProvider = context.read<UnivProvider>();
    if (!univProvider.isInitialized) return;

    _redirected = true;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final targetRoute = (univProvider.selectedUniversity != null)
          ? "/home"
          : "/onboarding";

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(targetRoute, (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final univProvider = context.watch<UnivProvider>();
    _tryRedirect();

    if (_isSplashVisible) {
      return const SplashScreen();
    }

    if (!univProvider.isInitialized) {
      return const LoadingScreen();
    }

    // 라우트 이동 직전 프레임
    return const SizedBox.shrink();
  }
}
