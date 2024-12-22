import 'package:cash_track/widgets/expense_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/database_provider.dart';

class AllExpensesList extends StatelessWidget {
  const AllExpensesList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, child) {
        var list = db.expense;

        return list.isEmpty
            ? const Center(
                child: Text("No Entries Found!"),
              )
            : ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: list.length,
                itemBuilder: (context, index) => ExpenseCard(exp: list[index]),
              );
      },
    );
  }
}
