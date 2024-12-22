import 'package:cash_track/constants/icons.dart';
import 'package:cash_track/models/ex_category.dart';
import 'package:cash_track/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseProvider with ChangeNotifier {
  Database? _database;

  String _searchText = '';
  String get searchText => _searchText;
  set searchText(String value) {
    _searchText = value;
    notifyListeners();
  }

  // in app memory holding the expense categories temporarily

  List<ExpenseCategory> _categories = [];
  List<ExpenseCategory> get categories => _categories;

  // Expense List
  List<Expense> _expense = [];
  List<Expense> get expense {
    return _searchText != ''
        ? _expense
            .where(
              (element) => element.title
                  .toLowerCase()
                  .contains(_searchText.toLowerCase()),
            )
            .toList()
        : _expense;
  }

  Future<Database> get database async {
    // dtabase directory
    final dbDirectory = await getDatabasesPath();

    // databse name
    const dbName = 'expense_tc.db';
    // full path
    final path = join(dbDirectory, dbName);

    _database = await openDatabase(path, version: 1, onCreate: _createDb);
    return _database!;
  }

  // create database function
  static const cTable = 'categoryTable';
  static const eTable = 'expenseTable';
  Future<void> _createDb(Database db, int version) async {
    await db.transaction(
      (txn) async {
        // CATEGORY TABLE
        await txn.execute('''CREATE TABLE $cTable(
        title TEXT,
        entries INTEGER,
        totalAmount TEXT
        )''');

        // EXPENSE TABLE
        await txn.execute('''CREATE TABLE $eTable(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount TEXT,
        date TEXT,
        category TEXT
        )''');

        for (int i = 0; i < icons.length; i++) {
          await txn.insert(cTable, {
            'title': icons.keys.toList()[i],
            'entries': 0,
            'totalAmount': (0.0).toString(),
          });
        }
      },
    );
  }

  // method to fetch categories
  Future<List<ExpenseCategory>> fetchCategories() async {
    // get the databse

    final db = await database;

    return await db.transaction(
      (txn) async {
        return await txn.query(cTable).then(
          (data) {
            // convert Map<String, object> to Map<String, dynamic>
            final converted = List<Map<String, dynamic>>.from(data);

            // create expenseCategory from every map in this converted

            List<ExpenseCategory> nList = List.generate(
              converted.length,
              (index) => ExpenseCategory.fromString(converted[index]),
            );

            // set the value of categories to nList
            _categories = nList;

            // return the categories

            return _categories;
          },
        );
      },
    );
  }

  // method to update category
  Future<void> updateCategory(
      String category, int nEntries, double nTotalAmount) async {
    final db = await database;

    await db.transaction(
      (txn) async {
        await txn
            .update(
          cTable, // category table
          {
            'entries': nEntries, // new entries
            'totalAmount': nTotalAmount.toString(), // new amount
          },
          where: 'title == ?', // in table where title ==
          whereArgs: [category],
        )
            .then(
          (value) {
            // after updating the database, now update app memory too
            var file = _categories.firstWhere(
              (element) => element.title == category,
            );
            file.entries = nEntries;
            file.totalAmount = nTotalAmount;
            notifyListeners();
          },
        ); // this category
      },
    );
  }

  // method to add an expense to database
  Future<void> addExpense(Expense exp) async {
    final db = await database;

    await db.transaction(
      (txn) async {
        await txn
            .insert(
          eTable,
          exp.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        )
            .then(
          (generatedId) {
            // add expense with generated ID
            final file = Expense(
              id: generatedId,
              title: exp.title,
              amount: exp.amount,
              date: exp.date,
              category: exp.category,
            );

            _expense.add(file);

            // notify the listeners about the change in value of '_expense'
            notifyListeners();

            // update the category
            var ex = findCategory(exp.category);
            updateCategory(
                exp.category, ex.entries + 1, ex.totalAmount + exp.amount);
          },
        );
      },
    );
  }

  // method to delete an expense to database
  Future<void> deleteExpense(int expId, String category, double amount) async {
    final db = await database;
    await db.transaction(
      (txn) async {
        await txn.delete(eTable, where: 'id == ?', whereArgs: [expId]).then(
          (value) {
            _expense.removeWhere(
              (element) => element.id == expId,
            );
            notifyListeners();

            // we have to update the entries and total amount

            // update the category
            var ex = findCategory(category);
            updateCategory(category, ex.entries - 1, ex.totalAmount - amount);
          },
        );
      },
    );
  }

  // fetch expense from database by category
  Future<List<Expense>> fetchExpense(String category) async {
    final db = await database;
    return await db.transaction(
      (txn) async {
        return await txn
            .query(eTable, where: 'category == ?', whereArgs: [category]).then(
          (data) {
            final converted = List<Map<String, dynamic>>.from(data);

            List<Expense> nList = List.generate(
              converted.length,
              (index) => Expense.fromString(converted[index]),
            );
            _expense = nList;
            return _expense;
          },
        );
      },
    );
  }

  // // fetch all expense from database
  Future<List<Expense>> fetchAllExpenses() async {
    final db = await database;
    return await db.transaction(
      (txn) async {
        return await txn.query(eTable).then(
          (data) {
            final converted = List<Map<String, dynamic>>.from(data);
            List<Expense> nList = List.generate(
              converted.length,
              (index) => Expense.fromString(converted[index]),
            );
            _expense = nList;
            return _expense;
          },
        );
      },
    );
  }

  ExpenseCategory findCategory(String title) {
    return _categories.firstWhere(
      (element) => element.title == title,
    );
  }

  // calculate total entries and amount
  Map<String, dynamic> calculateEntriesAndAmount(String category) {
    double total = 0.0;

    var list = _expense.where(
      (element) => element.category == category,
    );
    for (final i in list) {
      total += i.amount;
    }

    return {
      'entries': list.length,
      'totalAmount': total,
    };
  }

  //calculate total expense
  double calculateTotalExpense() {
    return _categories.fold(
      0.0,
      (previousValue, element) => previousValue + element.totalAmount,
    );
  }

  // calculate last week expenses
  calculateWeekExpenses() {
    List<Map<String, dynamic>> data = [];

    // 1 total for  each entry
    for (int i = 0; i < 7; i++) {
      double total = 0.0;

      final weekDay = DateTime.now().subtract(Duration(days: i));

      // check how many transaction happened
      for (int j = 0; j < _expense.length; j++) {
        if (_expense[j].date.year == weekDay.year &&
            _expense[j].date.month == weekDay.month &&
            _expense[j].date.day == weekDay.day) {
          // if found then add the amount to total
          total += _expense[j].amount;
        }
      }

      data.add({'day': weekDay, 'amount': total});
    }
    // return the list
    return data;
  }
}
