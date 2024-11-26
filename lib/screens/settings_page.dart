import 'package:app_manager_finance/resources/app_color.dart';
import 'package:app_manager_finance/services/local/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.green1,
        title: const Text(
          'Setting',
          style: TextStyle(
            color: AppColor.white,
          ),
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () {},
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.green1),
                child: const Text(
                  'Change password',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.white,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  _showLogoutDialog(context);
                },
                style:
                    ElevatedButton.styleFrom(backgroundColor: AppColor.green1),
                child: const Text(
                  'Log out',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppColor.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: <Widget>[
            TextButton(
              child: const Text("Yes"),
              onPressed: () async {
                FirebaseAuth.instance.signOut();
                await SharedPrefs.removeUsername();

                Navigator.of(context).pop();
                await SharedPrefs.setLoggedIn(false);
              },
            ),
            TextButton(
              child: const Text("No"),
              onPressed: () {
                // Handle your logout logic here
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
