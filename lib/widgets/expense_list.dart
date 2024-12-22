import 'package:cash_track/provider/database_provider.dart';
import 'package:cash_track/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ExpenseList extends StatelessWidget {
  const ExpenseList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, child) {
        var exList = db.expense;
        return exList.isEmpty
            ? const Center(
                child: Text("No Expense Added"),
              )
            : ListView.builder(
                itemCount: exList.length,
                itemBuilder: (context, index) =>
                    ExpenseCard(exp: exList[index]),
              );
      },
    );
  }
}
