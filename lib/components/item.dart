import 'package:app_manager_finance/model/finance.dart';
import 'package:app_manager_finance/resources/app_color.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Item extends StatelessWidget {
   Item({
    super.key,
    required this.financeItem,
  });
  final FinanceItem financeItem;

  String _formatDate(String dateString) {
    try {
      // Chuyển đổi chuỗi thành đối tượng DateTime
      final DateTime parsedDate = DateTime.parse(dateString);

      // Định dạng DateTime thành chuỗi "dd-MM-yyyy"
      return DateFormat('dd-MM-yyyy').format(parsedDate);
    } catch (e) {
      return dateString; // Trả về chuỗi gốc nếu không phân tích được
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
        decoration: const BoxDecoration(
          color: AppColor.white,
          borderRadius: BorderRadius.all(Radius.circular(15.0)),
          boxShadow: [
            BoxShadow(
              color: AppColor.shadow,
              offset: Offset(0.0, 4.0),
              blurRadius: 4.0,
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset(
                'assets/images/${financeItem.category?.image ?? "logoapp.jpg"}', // Hình mặc định
                width: 50,
                height: 50,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    'assets/images/logoapp.jpg', // Hình mặc định khi lỗi
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  );
                },
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      financeItem.name,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'Date: ${_formatDate(financeItem.date)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '${financeItem.amount} \$',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 19,
                  color: financeItem.expense?.labels == 'Expand'
                      ? AppColor.red
                      : AppColor.green,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
