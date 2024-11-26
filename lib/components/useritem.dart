import 'package:app_manager_finance/model/user.dart';
import 'package:flutter/material.dart';

class Useritem extends StatelessWidget {
  const Useritem({super.key, required this.userModel, });
  final UserModel userModel;
  @override
  Widget build(BuildContext context) {
    Widget buildUserInfoDisplay(String getValue, String title) => Padding(
        padding: EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 1,
            ),
            Container(
                width: 350,
                height: 40,
                decoration: const BoxDecoration(
                    border: Border(
                        bottom: BorderSide(
                  color: Colors.grey,
                  width: 1,
                ))),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    getValue,
                    style: const TextStyle(fontSize: 16, height: 1.4),
                  )),
                  const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.grey,
                    size: 40.0,
                  )
                ]))
          ],
        ));
    return SingleChildScrollView(
      child: Column(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(
              userModel.image,
            ),
            radius: 23,
          ),
          buildUserInfoDisplay(userModel.name, 'name'),
          buildUserInfoDisplay(userModel.email, 'email')
        ],
      ),
    );
  }
}
