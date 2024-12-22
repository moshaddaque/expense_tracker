import 'package:cash_track/provider/database_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TotalChart extends StatefulWidget {
  const TotalChart({super.key});

  @override
  State<TotalChart> createState() => _TotalChartState();
}

class _TotalChartState extends State<TotalChart> {
  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, child) {
        var list = db.categories;
        var total = db.calculateTotalExpense();
        return Row(
          children: [
            Expanded(
                flex: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    FittedBox(
                      alignment: Alignment.center,
                      fit: BoxFit.scaleDown,
                      child: Text(
                        "Total Expense: ${NumberFormat.currency(
                          locale: 'en_BN',
                          symbol: '৳',
                        ).format(total)}",
                        textScaleFactor: 1.5,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    ...list.map(
                      (e) => Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              color: Colors.primaries[list.indexOf(e)],
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(
                              e.title,
                            ),
                            const SizedBox(
                              width: 3,
                            ),
                            Text(total == 0
                                ? '0%'
                                : '${((e.totalAmount / total) * 100).toStringAsFixed(2)}%'),
                          ],
                        ),
                      ),
                    )
                  ],
                )),
            Expanded(
                flex: 38,
                child: PieChart(
                  PieChartData(
                    centerSpaceRadius: 20.0,
                    sections: total != 0
                        ? list
                            .map(
                              (e) => PieChartSectionData(
                                showTitle: false,
                                value: e.totalAmount,
                                color: Colors.primaries[list.indexOf(e)],
                              ),
                            )
                            .toList()
                        : list
                            .map(
                              (e) => PieChartSectionData(
                                showTitle: false,
                                color: Colors.primaries[list.indexOf(e)],
                              ),
                            )
                            .toList(),
                  ),
                )),
          ],
        );
      },
    );
  }
}
