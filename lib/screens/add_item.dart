import 'dart:convert';
import 'package:app_manager_finance/components/menu_button.dart';
import 'package:app_manager_finance/config/apikey.dart';
import 'package:app_manager_finance/model/finance.dart';
import 'package:app_manager_finance/resources/app_color.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Add_Screen extends StatefulWidget {
  const Add_Screen({super.key});

  @override
  State<Add_Screen> createState() => _Add_ScreenState();
}

class _Add_ScreenState extends State<Add_Screen> {
  DateTime date = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  var _enteredExplain = '';
  var _enteredPrice = 1;
  var _isSending = false;
  String? _selectedCategoryLabel;
  String? _selectedCategoryImage;
  String? _selectedExpenseLabel;
  String? _selectedExpenseImage;
  List<Map<String, String>> selectedItems = [];
  final List<Map<String, String>> _itemCategory = [
    {'label': 'Food', 'image': 'food.png'},
    {'label': 'Transfer', 'image': 'transfer.png'},
    {'label': 'Transportation', 'image': 'transportation.png'},
    {'label': 'Education', 'image': 'education.png'},
  ];
  final List<Map<String, String>> _itemExpense = [
    {'labels': 'Income', 'images': 'Thu nhập.png'},
    {'labels': 'Expand', 'images': 'Thanh toán.png'},
  ];
  void _saveItem() async {
    final user = FirebaseAuth.instance.currentUser!;
    final userData = await FirebaseFirestore.instance
         .collection('users')
        .doc(user.uid)
       .get();
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSending = true;
      });
      _formKey.currentState!.save();
      final url = Uri.https(apiKeys.apiKey,
          'finance-list.json');
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode(
          {
            'name': _enteredExplain,
            'amount': _enteredPrice,
            'category': {
              'label': _selectedCategoryLabel, // Tên danh mục đã chọn
              'image': _selectedCategoryImage // Đường dẫn hình ảnh đã chọn
            },
            'expense': {
              'labels':
                  _selectedExpenseLabel, // Tên loại chi phí đã chọn (Expense/Income)
              'images':
                  _selectedExpenseImage // Đường dẫn hình ảnh của loại chi phí đã chọn
            },
            'date': date.toString(),
            'userId': user.uid,
            'username': userData.data()!['username'],
          },
        ),
      );
      final Map<String, dynamic> resData = json.decode(response.body);
      if (!context.mounted) {
        return;
      }
      Navigator.of(context).pop(FinanceItem(
        id: resData['name'],
        amount: _enteredPrice,
        category: Category(
          // Tạo đối tượng Category
          label: _selectedCategoryLabel!, // Tên danh mục đã chọn
          image:
              _selectedCategoryImage!, // Đường dẫn hình ảnh danh mục đã chọn,
        ),
        date: date.toString(),
        expense: Expense(
          // Tạo đối tượng Expense
          labels: _selectedExpenseLabel!, // Tên loại chi phí đã chọn
          images: _selectedExpenseImage!, // Đường dẫn hình ảnh chi phí đã chọn
        ),
        name: _enteredExplain,
      ));
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) =>const MenuButton(),
        ),
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.green1,
        title: const Text(
          'Adding',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Stack(
          alignment: AlignmentDirectional.center,
          children: [
            backgroundcontainer(context),
            Positioned(
              top: 50,
              child: main_container(),
            ),
          ],
        ),
      ),
    );
  }

  Container main_container() {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white,
      ),
      height: 600,
      width: 340,
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const SizedBox(height: 30),
            category(),
            const SizedBox(height: 20),
            explains(),
            const SizedBox(height: 20),
            price(),
            const SizedBox(height: 20),
            expense(),
            const SizedBox(height: 20),
            date_time(),
            const SizedBox(height: 20),
            save(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  void _onCategorySelected(String? selectedCategory) {
    setState(() {
      _selectedCategoryLabel = selectedCategory;
      _selectedCategoryImage = _itemCategory
          .firstWhere((item) => item['label'] == selectedCategory)['image'];
    });
  }

  void _onExpenseSelected(String? selectedExpense) {
    setState(() {
      _selectedExpenseLabel = selectedExpense;
      _selectedExpenseImage = _itemExpense
          .firstWhere((item) => item['labels'] == selectedExpense)['images'];
    });
  }

  GestureDetector save() {
    return GestureDetector(
      onTap: () {
         _isSending ? null : _saveItem();
      },
      child: _isSending
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(),
            )
          : Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: AppColor.green1,
              ),
              width: 120,
              height: 50,
              child: const Text(
                'Save',
                style: TextStyle(
                  fontFamily: 'f',
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
            ),
    );
  }

  Widget date_time() {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () async {
        DateTime? newDate = await showDatePicker(
            context: context,
            initialDate: date,
            firstDate: DateTime(2020),
            lastDate: DateTime(2100));
        if (newDate == Null) return;
        setState(() {
          date = newDate!;
        });
      },
      child: Container(
        alignment: Alignment.bottomLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 2, color: AppColor.grey)),
        width: 300,
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 15.0),
        child: Text(
          'Date : ${date.day} / ${date.month} / ${date.year}',
          style: const TextStyle(
            fontSize: 15,
            color: AppColor.black,
          ),
        ),
      ),
    );
  }

  Widget category() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: DropdownButtonFormField<String>(
          decoration: const InputDecoration(
            contentPadding: EdgeInsets.only(bottom: 8),
            hintText: 'Select a category',
            border: InputBorder.none,
          ),

          value: _selectedCategoryLabel,
          items: _itemCategory.map((item) {
            return DropdownMenuItem<String>(
              value: item['label'],
              child: Row(
                children: <Widget>[
                  Image.asset(
                    'assets/images/${item['image']}',
                    width: 24,
                    height: 24,
                  ),
                  const SizedBox(width: 10),
                  Text(item['label']!),
                ],
              ),
            );
          }).toList(),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a category';
            }
            return null;
          },
          onChanged:
              _onCategorySelected, // Cập nhật giá trị khi người dùng chọn
        ),
      ),
    );
  }

  Padding expense() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 2,
            color: const Color(0xffC5C5C5),
          ),
        ),
        child: DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              contentPadding: EdgeInsets.only(bottom: 8),
              hintText: 'Select an option',
              border: InputBorder.none,
            ),
            value: _selectedExpenseLabel,
            items: _itemExpense.map((item) {
              return DropdownMenuItem<String>(
                value: item['labels'],
                child: Row(
                  children: <Widget>[
                    Image.asset(
                      'assets/images/${item['images']}',
                      width: 24,
                      height: 24,
                    ),
                    const SizedBox(width: 10),
                    Text(item['labels']!),
                  ],
                ),
              );
            }).toList(),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select an expense';
              }
              return null;
            },
            onChanged: _onExpenseSelected),
      ),
    );
  }

  Padding price() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: TextFormField(
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.only(bottom: 8),
            labelText: 'price',
            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
            border: InputBorder.none,
          ),
          initialValue: '',
          validator: (value) {
            if (value == null || int.tryParse(value) == null) {
              return 'must be a valid positive number!';
            }
            return null;
          },
          onSaved: (value) {
            _enteredPrice = int.parse(value!);
          },
        ),
      ),
    );
  }

  Widget explains() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        padding: const EdgeInsets.only(left: 15, right: 15),
        width: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(width: 2, color: const Color(0xffC5C5C5)),
        ),
        child: TextFormField(
          decoration: InputDecoration(
            labelText: 'explain',
            border: InputBorder.none,
            labelStyle: TextStyle(fontSize: 17, color: Colors.grey.shade500),
          ),
          // ignore: body_might_complete_normally_nullable
          validator: (value) {
            if (value == null ||
                value.trim().length <= 1 ||
                value.trim().length > 50) {
              return 'must be between 1 and 50 characters';
            }
          },
          onSaved: (value) {
            _enteredExplain = value!;
          },
        ),
      ),
    );
  }

  Column backgroundcontainer(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          height: 260,
          decoration: const BoxDecoration(
            color: AppColor.green1,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(20),
              bottomRight: Radius.circular(20),
            ),
          ),
          // child: const Column(
          //   children: [
          //     SizedBox(height: 40),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 15),
          //       child: Row(
          //         mainAxisAlignment: MainAxisAlignment.center,
          //         children: [
          //           Text(
          //             'Adding',
          //             style: TextStyle(
          //                 fontSize: 20,
          //                 fontWeight: FontWeight.w600,
          //                 color: Colors.white),
          //           ),
          //         ],
          //       ),
          //     )
          //   ],
          // ),
        ),
      ],
    );
  }
}
