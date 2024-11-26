class FinanceItem {
  final String id;
  final int amount;
  final Category? category;
  final String date;
  final Expense? expense;
  final String name;

  FinanceItem({
    required this.id,
    required this.amount,
    required this.category,
    required this.date,
    required this.expense,
    required this.name,
  });
}

class Category {
  final String image;
  final String label;

  // Constructor
  Category({
    required this.image,
    required this.label,
  });
}

class Expense {
  final String images;
  final String labels;

  // Constructor
  Expense({
    required this.images,
    required this.labels,
  });
}
