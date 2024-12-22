import 'package:cash_track/constants/icons.dart';
import 'package:cash_track/models/expense.dart';
import 'package:cash_track/provider/database_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ExpenseForm extends StatefulWidget {
  const ExpenseForm({super.key});

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> {
  final _title = TextEditingController();
  final _amount = TextEditingController();
  DateTime? _date;
  String _initialValue = 'Other';

  //
  _pickDate() async {
    DateTime? pickDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (pickDate != null) {
      setState(() {
        _date = pickDate;
      });
    }
  }

  //
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(labelText: 'Title of Expense'),
            ),
            const SizedBox(
              height: 20,
            ),
            TextField(
              controller: _amount,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount of Expense'),
            ),
            const SizedBox(
              height: 20,
            ),
            //Date picker
            Row(
              children: [
                Expanded(
                  child: Text(_date != null
                      ? DateFormat("MMM dd, yyyy").format(_date!)
                      : 'Select Date'),
                ),
                IconButton(
                  onPressed: () => _pickDate(),
                  icon: const Icon(Icons.calendar_month),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(
              children: [
                const Text('Category'),
                // const Expanded(
                //   child:
                // ),
                const Spacer(),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Expanded(
                    child: DropdownButton(
                      items: icons.keys
                          .map(
                            (e) => DropdownMenuItem(value: e, child: Text(e)),
                          )
                          .toList(),
                      value: _initialValue,
                      onChanged: (newValue) {
                        setState(() {
                          _initialValue = newValue!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20.0,
            ),

            ElevatedButton.icon(
              onPressed: () {
                if (_title.text != '' && _amount.text != '') {
                  // create an expense
                  final file = Expense(
                    id: 0,
                    title: _title.text,
                    amount: double.parse(_amount.text),
                    date: _date != null ? _date! : DateTime.now(),
                    category: _initialValue,
                  );

                  // add it in database
                  provider.addExpense(file);

                  Navigator.of(context).pop();
                }
              },
              label: const Text("add Expense"),
              icon: const Icon(Icons.add),
            ),
          ],
        ),
      ),
    );
  }
}
