import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: () {
          Navigator.of(context).pushReplacementNamed("/select_school");
          return;
        },
        child: Center(
          child: Text("시작하기", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }
}
