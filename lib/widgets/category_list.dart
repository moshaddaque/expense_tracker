import 'package:cash_track/provider/database_provider.dart';
import 'package:cash_track/widgets/category_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CategoryList extends StatelessWidget {
  const CategoryList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<DatabaseProvider>(
      builder: (context, db, child) {
        var list = db.categories;
        return ListView.builder(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          itemCount: list.length,
          itemBuilder: (context, index) {
            return CategoryCard(category: list[index]);
          },
        );
      },
    );
  }
}
