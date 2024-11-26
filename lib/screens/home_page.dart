import 'dart:convert';
import 'package:app_manager_finance/components/item.dart';
import 'package:app_manager_finance/components/mf_appbar.dart';
import 'package:app_manager_finance/components/search_box.dart';
import 'package:app_manager_finance/model/finance.dart';
import 'package:app_manager_finance/screens/add_item.dart';
import 'package:app_manager_finance/services/local/shared_prefs.dart';
import 'package:flutter/material.dart';
import 'package:app_manager_finance/resources/app_color.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({
    super.key,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<FinanceItem> _financeItems = [];
  List<FinanceItem> _searchList = [];
  var _isLoading = true;
  String? _error;
  int _totalIncome = 0;
  int _totalExpand = 0;
  final searchController = TextEditingController();
  String? _username = '';

  void _fetchUsername() async {
    String? username = await SharedPrefs.getUsername();
    if (username != null) {
      setState(() {
        _username = username; // Update the state with the username
      });
    }
  }

  void _loadItem() async {
    final url = Uri.https(
        'managefinance-2640d-default-rtdb.firebaseio.com', 'finance-list.json');
    try {
      final response = await http.get(url);

      if (response.statusCode == 400) {
        setState(() {
          _error = 'failed to fetch data. Please try again later.';
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

      if (_username == '') {
        setState(() {
          _error = 'Username not found. Please log in again.';
          _isLoading = false;
        });
        return;
      }

      final Map<String, dynamic> listData = await json.decode(response.body);
      final List<FinanceItem> _loadedFinance = [];
      _totalIncome = 0;
      _totalExpand = 0;
      for (final item in listData.entries) {
        final itemData = item.value;

        // Kiểm tra nếu username trong dữ liệu khớp với username đã đăng nhập
        if (itemData['username'] == _username) {
          final category = Category(
            image: itemData['category']['image'],
            label: itemData['category']['label'],
          );
          final expense = Expense(
            labels: itemData['expense']['labels'],
            images: itemData['expense']['images'],
          );

          // Tính tổng thu nhập và chi tiêu
          if (expense.labels == 'Income') {
            _totalIncome += itemData['amount'] as int;
          } else if (expense.labels == 'Expand') {
            _totalExpand += itemData['amount'] as int;
          }

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
      if (_username != null) {
        setState(() {
          _financeItems = _loadedFinance;
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _error = 'Something went wrong. Please try again later.';
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchUsername();
    _loadItem();
  }

  void _search(String value) async {
    value = value.toLowerCase();

    _searchList = _financeItems
        .where((e) => (e.name).toLowerCase().contains(value))
        .toList();
    setState(() {});
  }

  void _addItem() async {
    final newItem = await Navigator.of(context).push<FinanceItem>(
      MaterialPageRoute(
        builder: (ctx) => const Add_Screen(),
      ),
    );

    if (newItem == null) {
      return;
    }
    setState(() {
      _financeItems.add(newItem);
    });
  }

  void _removeItem(FinanceItem item) async {
    final index = _financeItems.indexOf(item);
    setState(() {
      _financeItems.remove(item);

      if (item.expense?.labels == 'Income') {
        _totalIncome -= item.amount;
      } else if (item.expense?.labels == 'Expand') {
        _totalExpand -= item.amount;
      }
    });
    final url = Uri.https('managefinance-2640d-default-rtdb.firebaseio.com',
        'finance-list/${item.id}.json');

    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('error while delete data')));
      setState(() {
        _financeItems.insert(index, item);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget content = const Center(child: Text('no item added yet'));
    if (_isLoading) {
      content = const Center(child: CircularProgressIndicator());
    }
    if (_financeItems.isNotEmpty) {
      content = ListView.builder(
        itemCount:
            _searchList.isNotEmpty ? _searchList.length : _financeItems.length,
        itemBuilder: (ctx, index) => Dismissible(
          confirmDismiss: (DismissDirection direction) async {
            if (direction == DismissDirection.endToStart) {
              return await showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: const Text('Delete'),
                    content: const Text('Do you want delete?'),
                    actions: <Widget>[
                      ElevatedButton(
                        onPressed: () {
                          _removeItem(_searchList.isNotEmpty
                              ? _searchList[index]
                              : _financeItems[index]);
                          Navigator.of(context).pop();
                        },
                        child: Text('Yes'),
                      ),
                      ElevatedButton(
                        onPressed: Navigator.of(context).pop,
                        child: Text('no'),
                      ),
                    ],
                  );
                },
              );
            }
            return null;
          },
          background: Container(
            color: Colors.red,
          ),
          key: ValueKey(_searchList.isNotEmpty
              ? _searchList[index].id
              : _financeItems[index].id),
          child: Item(
              financeItem: _searchList.isNotEmpty
                  ? _searchList[index]
                  : _financeItems[index]),
        ),
//loi thieu return
      );
    }
    if (_error != null) {
      content = Center(child: Text(_error!));
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: Mfappbar(
        user: _username!,
        total: _totalIncome - _totalExpand,
        costin: _totalIncome,
        costout: _totalExpand,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          children: [
            const Text(
              'Lịch Sử Giao Dịch',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 19,
                color: AppColor.black,
              ),
            ),
            const SizedBox(height: 5),
            SearchBox(
              controller: searchController,
              onChanged: _search,
            ),
            const SizedBox(height: 5),
            Expanded(child: content),
          ],
        ),
      ),
    );
  }
}
