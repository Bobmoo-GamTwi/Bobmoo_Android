import 'package:bobmoo/models/university.dart';
import 'package:bobmoo/providers/univ_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TextButton(
        onPressed: _openSelectSchool,
        child: Center(
          child: Text("시작하기", style: TextStyle(color: Colors.black)),
        ),
      ),
    );
  }

  Future<void> _openSelectSchool() async {
    final University? university = await Navigator.of(
      context,
    ).pushNamed<University?>("/select_school", arguments: false);

    if (!mounted) return;

    if (university != null) {
      context.read<UnivProvider>().updateUniversity(university);
    }
    Navigator.of(context).pushNamedAndRemoveUntil("/home", (route) => false);
  }
}
