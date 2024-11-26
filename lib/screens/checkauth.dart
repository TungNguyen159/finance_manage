import 'package:app_manager_finance/components/menu_button.dart';
import 'package:app_manager_finance/screens/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class authCheck extends StatelessWidget {
  const authCheck({super.key});

  @override
  Widget build(BuildContext context) {
    
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasData) {
          return const MenuButton();
        }
        return const AuthScreen();
      },
    );
  }
}
