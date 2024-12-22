import 'package:flutter/material.dart';

import '../../widgets/all_expenses_fetcher.dart';

class AllExpenses extends StatelessWidget {
  static const name = '/all_expenses';
  const AllExpenses({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("All Expenses"),
      ),
      body: const AllExpensesFetcher(),
    );
  }
}
