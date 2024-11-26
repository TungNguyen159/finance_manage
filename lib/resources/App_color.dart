import 'package:flutter/material.dart';

class AppColor {
  AppColor._();
  static const Color appbar1 = Color.fromARGB(255, 54, 72, 137);
  static const Color appbar2 = Color.fromARGB(255, 71, 112, 200);
  static const Color red = Colors.red;
  static const Color green = Colors.green;
  static const Color blue = Color(0xFF5F52EE);
  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color grey = Colors.grey;
  static const Color grey1 = Color.fromARGB(255, 226, 219, 207);
  static const Color brown = Colors.brown;
  static const Color pink = Colors.pink;
  static const Color orange = Colors.orange;
  static const Color bgColor = Color(0xFFEEEFF5);
  static const Color shadow = Colors.black26;
  static const Color white12 = Colors.white12;
  static const Color green1 =  Color(0xff368983);
}
// SliverList(
//                     delegate: SliverChildBuilderDelegate(
//                       (context, index) {
//                         final data = financeData
//                             .where((money) => money.buy == true)
//                             .toList()
//                           ..sort((a, b) =>
//                               int.parse(b.fee!).compareTo(int.parse(a.fee!)));
//                         final item = data[index];
//                         return ListTile(
//                           leading: ClipRRect(
//                             borderRadius: BorderRadius.circular(5),
//                             child:
//                                 Image.asset('images/${item.image}', height: 40),
//                           ),
//                           title: Text(
//                             item.name ?? '',
//                             style: const TextStyle(
//                               fontSize: 17,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           subtitle: Text(
//                             ' ${item.time}',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           trailing: Text(
//                             item.fee ?? '',
//                             style: const TextStyle(
//                               fontWeight: FontWeight.w600,
//                               fontSize: 19,
//                               color: Colors.red, // Change color to red
//                             ),
//                           ),
//                         );
//                       },
//                       childCount: financeData
//                           .where((money) => money.buy == true)
//                           .length,
//                     ),
//                   ),