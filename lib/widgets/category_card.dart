import 'package:cash_track/models/ex_category.dart';
import 'package:cash_track/screens/expenseScreen/expense_screen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CategoryCard extends StatelessWidget {
  final ExpenseCategory category;
  const CategoryCard({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      shape: const Border(
        top: BorderSide.none,
        right: BorderSide.none,
        left: BorderSide.none,
        bottom: BorderSide(color: Colors.black12),
      ),
      leading: Icon(category.icon),
      title: Text(category.title),
      subtitle: Text('${category.entries}'),
      trailing: Text(NumberFormat.currency(locale: 'en_BN', symbol: '৳')
          .format(category.totalAmount)),
      onTap: () {
        Navigator.of(context).pushNamed(
          ExpenseScreen.name,
          arguments: category.title,
        );
      },
    );
  }
}
