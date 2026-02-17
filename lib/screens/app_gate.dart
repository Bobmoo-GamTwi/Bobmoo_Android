import 'package:bobmoo/providers/univ_provider.dart';
import 'package:bobmoo/screens/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AppGate extends StatefulWidget {
  const AppGate({super.key});

  @override
  State<AppGate> createState() => _AppGateState();
}

class _AppGateState extends State<AppGate> {
  // 한번만 실행되게 가드역할
  bool _redirected = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final univProvider = context.watch<UnivProvider>();

    if (_redirected) return;

    if (!univProvider.isInitialized) {
      // 아직 초기화 전이면 UI만 보여주고 대기
      return;
    }

    _redirected = true;

    // build 후에 이동
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final targetRoute = (univProvider.selectedUniversity != null)
          ? "/home"
          : "/onboarding";

      Navigator.of(context).pushReplacementNamed(targetRoute);
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
