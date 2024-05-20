import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../../../size_config.dart';

class Categories extends StatefulWidget {
  final Function(String) onCategorySelected;

  const Categories({Key? key, required this.onCategorySelected}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  List<String> categories = ["All", 'Breakfast', 'Lunch', 'Dinner', 'Snack'];
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 2),
      child: SizedBox(
        height: SizeConfig.defaultSize * 3.5, // 35
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: categories.length,
          itemBuilder: (context, index) => buildCategoriItem(index),
        ),
      ),
    );
  }

  Widget buildCategoriItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedIndex = index;
        });
        widget.onCategorySelected(categories[index]);
      },
      child: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: SizeConfig.defaultSize * 2),
        padding: EdgeInsets.symmetric(
          horizontal: SizeConfig.defaultSize * 2, //20
          vertical: SizeConfig.defaultSize * 0.5, //5
        ),
        decoration: BoxDecoration(
          color: selectedIndex == index ? const Color(0xFFEFF3EE) : Colors.transparent,
          borderRadius: BorderRadius.circular(
            SizeConfig.defaultSize * 1.6, // 16
          ),
        ),
        child: Text(
          categories[index],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: selectedIndex == index ? kPrimaryColor : const Color(0xFFC2C2B5),
          ),
        ),
      ),
    );
  }
}
