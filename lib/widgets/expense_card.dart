import 'package:cash_track/constants/icons.dart';
import 'package:cash_track/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'confirm_box.dart';

class ExpenseCard extends StatelessWidget {
  final Expense exp;
  const ExpenseCard({
    super.key,
    required this.exp,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(exp.id),
      confirmDismiss: (direction) async {
        showDialog(
          context: context,
          builder: (context) => ConfirmBox(exp: exp),
        );
      },
      child: ListTile(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(icons[exp.category]),
        ),
        title: Text(
          exp.title,
        ),
        subtitle: Text(DateFormat('MMMM dd, yyyy').format(exp.date)),
        trailing: Text(NumberFormat.currency(locale: 'en_BN', symbol: '৳')
            .format(exp.amount)),
      ),
    );
  }
}
