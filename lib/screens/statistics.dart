import 'dart:convert';

import 'package:app_manager_finance/components/item.dart';
import 'package:app_manager_finance/model/finance.dart';
import 'package:app_manager_finance/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';

import 'package:app_manager_finance/widgets/chart.dart';
import 'package:app_manager_finance/resources/app_color.dart';
import 'package:http/http.dart' as http;

class Statistics extends StatefulWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  _StatisticsState createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  var _isLoading = true;
  String? _error;
  List<FinanceItem> _financeItems = [];
  bool _showTopIncome = false;
  SharedPrefs prefs = SharedPrefs();
  @override
  void initState() {
    super.initState();
    _loadItem();
  }

  void _loadItem() async {
    final url = Uri.https(
        'managefinance-2640d-default-rtdb.firebaseio.com', 'finance-list.json');
    try {
      final response = await http.get(url);

      if (response.statusCode != 200) {
        // Kiểm tra mã phản hồi
        setState(() {
          _error = 'Failed to fetch data. Please try again later.';
          _isLoading = false;
        });
        return;
      }

      if (response.body == 'null') {
        setState(() {
          _isLoading = false;
        });
        return;
      }

      // Lấy username từ SharedPreferences
      String? username = await SharedPrefs.getUsername();
      if (username == null) {
        setState(() {
          _error = 'Username not found. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = json.decode(response.body);
      final List<FinanceItem> _loadedFinance = [];

      for (final item in listData.entries) {
        final itemData = item.value;

        // Kiểm tra nếu username trong dữ liệu khớp với username đã đăng nhập
        if (itemData['username'] == username) {
          final category = Category(
            image: itemData['category']['image'],
            label: itemData['category']['label'],
          );
          final expense = Expense(
            labels: itemData['expense']['labels'],
            images: itemData['expense']['images'],
          );

          // Thêm vào danh sách _loadedFinance
          _loadedFinance.add(
            FinanceItem(
              id: item.key,
              amount: itemData['amount'],
              name: itemData['name'],
              category: category,
              expense: expense,
              date: itemData['date'],
            ),
          );
        }
      }

      setState(() {
        _financeItems = _loadedFinance;
        _isLoading = false;
      });
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sort finance items by income (amount) in descending order
    List<FinanceItem> topIncomeItems = List.from(_financeItems)
      ..sort((a, b) => b.amount.compareTo(a.amount));

    // Display only the top 5 items
    topIncomeItems = topIncomeItems.take(5).toList();
    Widget content = const Center(child: Text('No item added yet'));
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    } else if (_financeItems.isNotEmpty) {
      content = ListView.builder(
        shrinkWrap: true, // Allows ListView to wrap its content size
        physics: const NeverScrollableScrollPhysics(),
        itemCount: _financeItems.length,
        itemBuilder: (ctx, index) {
          return Item(financeItem: _financeItems[index]);
        },
      );
    } else if (_error != null) {
      content = Center(child: Text(_error!));
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColor.green1, // Set background color for appbar
        centerTitle: true, // Center align title
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: AppColor.white, // Set text color for appbar to match AddPage
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 20),
            Chart(
              financeItems:
                  _financeItems, // Sử dụng _financeItems để hiển thị biểu đồ
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Top Spending',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.swap_vert,
                      size: 25,
                      color: Colors.grey,
                    ),
                    onPressed: () {
                      setState(() {
                        _showTopIncome = !_showTopIncome; // Toggle visibility
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            if (_showTopIncome) // Show top income items if _showTopIncome is true
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: topIncomeItems.length,
                itemBuilder: (ctx, index) {
                  return Item(financeItem: topIncomeItems[index]);
                },
              ),
            if (!_showTopIncome) content,
          ],
        ),
      ),
    );
  }
}
