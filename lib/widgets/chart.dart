import 'package:app_manager_finance/model/finance.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

//import 'package:app_manager_finance/pages/add_page.dart';
import 'package:intl/intl.dart';

class Chart extends StatefulWidget {
  final List<FinanceItem> financeItems;

  const Chart({Key? key, required this.financeItems}) : super(key: key);

  @override
  _ChartState createState() => _ChartState();
}

class _ChartState extends State<Chart> {
  DateTime currentDayDate = DateTime.now();
  DateTime currentWeekDate = DateTime.now();
  bool showWeekChart = false;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showWeekChart = false;
                  });
                },
                child: const Text('Day'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    showWeekChart = true;
                  });
                },
                child: const Text('Week'),
              ),
            ],
          ),
          SizedBox(
            width: double.infinity,
            height: 300,
            child: showWeekChart ? _buildWeekChart() : _buildDayChart(),
          ),
          if (!showWeekChart)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentDayDate =
                          currentDayDate.subtract(const Duration(days: 7));
                    });
                  },
                ),
                Text(
                  DateFormat('yyyy').format(currentDayDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      currentDayDate =
                          currentDayDate.add(const Duration(days: 7));
                    });
                  },
                ),
              ],
            ),
          if (showWeekChart)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    setState(() {
                      currentWeekDate = DateTime(
                          currentWeekDate.year, currentWeekDate.month - 1, 1);
                    });
                  },
                ),
                Text(
                  DateFormat('MMMM yyyy').format(currentWeekDate),
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    setState(() {
                      currentWeekDate = DateTime(
                          currentWeekDate.year, currentWeekDate.month + 1, 1);
                    });
                  },
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildWeekChart() {
    List<_ChartData> chartData = [];
    DateTime startOfMonth =
        DateTime(currentWeekDate.year, currentWeekDate.month, 1);
    DateTime endOfMonth =
        DateTime(currentWeekDate.year, currentWeekDate.month + 1, 0);

    int daysInMonth = endOfMonth.day;
    int daysPerWeek = (daysInMonth / 4).ceil();

    for (int i = 0; i < 4; i++) {
      double totalIncome = 0;
      double totalExpense = 0;
      DateTime weekStart = startOfMonth.add(Duration(days: i * daysPerWeek));
      DateTime weekEnd = (i == 3)
          ? endOfMonth
          : weekStart.add(Duration(days: daysPerWeek - 1));

      String weekRange = DateFormat('dd/MM').format(weekStart) +
          ' - ' +
          DateFormat('dd/MM').format(weekEnd);

      for (var entry in widget.financeItems) {
        DateTime entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(entry.date);
        if (entryDate.isAfter(weekStart.subtract(const Duration(days: 1))) &&
            entryDate.isBefore(weekEnd.add(const Duration(days: 1)))) {
          if (entry.expense?.labels == 'Expand') {
            totalExpense += entry.amount.toDouble();
          } else if (entry.expense?.labels == 'Income') {
            totalIncome += entry.amount.toDouble();
          }
        }
      }

      chartData.add(_ChartData(weekRange, totalExpense, totalIncome));
    }

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        ColumnSeries<_ChartData, String>(
          color: Colors.red,
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.expense,
        ),
        ColumnSeries<_ChartData, String>(
          color: Colors.green,
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.income,
        ),
      ],
    );
  }

  Widget _buildDayChart() {
    DateTime startOfWeek =
        currentDayDate.subtract(Duration(days: currentDayDate.weekday - 1));
    List<_ChartData> chartData = [];
    Map<String, List<double>> weeklyData = {};

    for (int i = 0; i < 7; i++) {
      DateTime date = startOfWeek.add(Duration(days: i));
      String formattedDate = DateFormat('dd/MM').format(date);
      String dayOfWeek = DateFormat('E').format(date);
      weeklyData['$dayOfWeek\n$formattedDate'] = [0, 0];
    }

    for (var entry in widget.financeItems) {
      DateTime entryDate = DateFormat('yyyy-MM-dd HH:mm:ss.SSS').parse(entry.date);
      String formattedEntryDate = DateFormat('dd/MM').format(entryDate);
      String dayOfWeek = DateFormat('E').format(entryDate);
      if (weeklyData.containsKey('$dayOfWeek\n$formattedEntryDate')) {
        double amount = entry.amount.toDouble();
        if (entry.expense?.labels == 'Income') {
          weeklyData['$dayOfWeek\n$formattedEntryDate']![1] += amount;
        } else if (entry.expense?.labels == 'Expand') {
          weeklyData['$dayOfWeek\n$formattedEntryDate']![0] += amount;
        }
      }
    }
    weeklyData.forEach((date, amounts) {
      chartData.add(_ChartData(date, amounts[0], amounts[1]));
    });

    return SfCartesianChart(
      primaryXAxis: CategoryAxis(),
      series: <ChartSeries>[
        ColumnSeries<_ChartData, String>(
          color: Colors.red,
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.expense,
        ),
        ColumnSeries<_ChartData, String>(
          color: Colors.green,
          dataSource: chartData,
          xValueMapper: (_ChartData data, _) => data.date,
          yValueMapper: (_ChartData data, _) => data.income,
        ),
      ],
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.expense, this.income);

  final String date;
  final double expense;
  final double income;
}
