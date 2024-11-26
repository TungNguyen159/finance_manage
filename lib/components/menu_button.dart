import 'package:app_manager_finance/screens/add_item.dart';
import 'package:app_manager_finance/screens/home_page.dart';
import 'package:app_manager_finance/screens/profile_page.dart';
import 'package:app_manager_finance/screens/settings_page.dart';
import 'package:app_manager_finance/screens/statistics.dart';

import 'package:app_manager_finance/resources/app_color.dart';
import 'package:flutter/material.dart';

class MenuButton extends StatefulWidget {
  const MenuButton({super.key});

  @override
  State<MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<MenuButton> {
  int index_color = 0;
  List Screen = [
    HomePage(),
    Statistics(),
    ProfilePage(),
    SettingsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Screen[index_color],
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) =>const Add_Screen()));
        },
        child: Icon(Icons.add,color: AppColor.white),
        backgroundColor: AppColor.green1,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        child: Padding(
          padding: const EdgeInsets.only(top: 6.5, bottom: 6.5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 0;
                  });
                },
                child: Icon(
                  Icons.home,
                  size: 30,
                  color: index_color == 0 ? AppColor.green1 : AppColor.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 1;
                  });
                },
                child: Icon(
                  Icons.bar_chart_outlined,
                  size: 30,
                  color: index_color == 1 ? AppColor.green1 : AppColor.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 2;
                  });
                },
                child: Icon(
                  Icons.person_outlined,
                  size: 30,
                  color: index_color == 2 ? AppColor.green1 : AppColor.grey,
                ),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    index_color = 3;
                  });
                },
                child: Icon(
                  Icons.settings,
                  size: 30,
                  color: index_color == 3 ? AppColor.green1 : AppColor.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
