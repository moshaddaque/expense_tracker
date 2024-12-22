import 'package:cash_track/provider/database_provider.dart';
import 'package:cash_track/screens/allExpenses/all_expenses.dart';
import 'package:cash_track/screens/expenseScreen/expense_screen.dart';
import 'package:cash_track/screens/homeScreen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => DatabaseProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: HomeScreen.name,
      title: 'Cash Track',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routes: {
        // HomeScreen.name: (_) => const HomeScreen(),
        ExpenseScreen.name: (_) => const ExpenseScreen(),
        AllExpenses.name: (_) => const AllExpenses(),
      },
      home: const HomeScreen(),
    );
  }
}
