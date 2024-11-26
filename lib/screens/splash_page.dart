import 'package:app_manager_finance/screens/checkauth.dart';
import 'package:app_manager_finance/screens/onboarding_page.dart';
import 'package:app_manager_finance/services/local/shared_prefs.dart';

import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {

  @override
  void initState() {
    super.initState();
    _checkAppState();
  }

  Future<void> _checkAppState() async {
    await Future.delayed(const Duration(milliseconds: 2000));
    bool isFirstRun = await SharedPrefs.isFirstRun();
    if (isFirstRun) {
      await SharedPrefs.setFirstRun(false);
      _navigateToPage(OnboardingPage());
    } else {
      _navigateToPage(authCheck());
    }
  }

  void _navigateToPage(Widget page) {
    Route route = MaterialPageRoute(
      builder: (context) => page,
    );

    Navigator.pushAndRemoveUntil(
      context,
      route,
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            'assets/images/background.jpg',
            width: size.width,
            height: size.height,
            fit: BoxFit.fill,
          ),
          Center(
            child: Image.asset(
              'assets/images/logo.jpg',
              width: 200.0,
            ),
          ),
        ],
      ),
    );
  }
}
