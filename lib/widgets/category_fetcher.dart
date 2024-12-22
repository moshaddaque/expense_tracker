import 'package:animated_glow_border/animated_glow_border.dart';
import 'package:cash_track/provider/database_provider.dart';
import 'package:cash_track/screens/allExpenses/all_expenses.dart';
import 'package:cash_track/widgets/category_list.dart';
import 'package:cash_track/widgets/total_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryFetcher extends StatefulWidget {
  const CategoryFetcher({super.key});

  @override
  State<CategoryFetcher> createState() => _CategoryFetcherState();
}

class _CategoryFetcherState extends State<CategoryFetcher> {
  late Future _categoryList;

  Future getCategoryList() async {
    final provider = Provider.of<DatabaseProvider>(context, listen: false);
    return await provider.fetchCategories();
  }

  @override
  void initState() {
    super.initState();
    _categoryList = getCategoryList();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _categoryList,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 8,
                    ),
                    child: const SizedBox(
                      height: 250,
                      width: double.infinity,
                      child: AnimatedGlowBorder(
                        borderWidth: 0,
                        animationDuration: Duration(seconds: 5),
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: TotalChart(),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Expenses",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.redAccent,
                          fontSize: 20,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed(AllExpenses.name);
                        },
                        child: const Text(
                          "View All",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.redAccent,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Expanded(
                    child: CategoryList(),
                  ),
                ],
              ),
            );
          }
        } else {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
