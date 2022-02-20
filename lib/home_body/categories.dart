import 'package:flutter/material.dart';

class Categories extends StatelessWidget {
  final Function _updateCategoryFunction;
  final List<String> _categoriesList;

  const Categories(this._updateCategoryFunction, this._categoriesList,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: _categoriesList
          .map((category) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextButton(
                    onPressed: () {
                      _updateCategoryFunction(category);
                      Navigator.pop(context);
                    },
                    child: Text(category),
                  ),
                ),
              ))
          .toList(),
      scrollDirection: Axis.vertical,
    );
  }
}
