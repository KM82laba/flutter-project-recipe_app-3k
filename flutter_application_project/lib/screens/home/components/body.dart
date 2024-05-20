import 'package:flutter/material.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/screens/ReciepList/components/list_recieps.dart';
import '../../../models/RecipeBundel.dart';
import '../../../size_config.dart';

import './categories.dart';
import './recipe_bundel_card.dart';

class Body extends StatefulWidget {
  const Body({Key? key}) : super(key: key);

  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String selectedCategory = "All";

  @override
  Widget build(BuildContext context) {
    DatabaseHelper _databaseHelper = DatabaseHelper();

    return SafeArea(
      child: Column(
        children: <Widget>[
          Categories(
            onCategorySelected: (category) {
              setState(() {
                selectedCategory = category;
              });
            },
          ),
          Expanded(
            child: FutureBuilder<List<RecipeCardInfo>>(
              future: _databaseHelper.getAllRecipesByCategory(category: selectedCategory),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: SizeConfig.defaultSize * 3),
                    child: GridView.builder(
                      itemCount: snapshot.data!.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: SizeConfig.orientation == Orientation.landscape ? 2 : 1,
                        mainAxisSpacing: 20,
                        crossAxisSpacing: SizeConfig.orientation == Orientation.landscape
                            ? SizeConfig.defaultSize * 2
                            : 0,
                        childAspectRatio: 1.65,
                      ),
                      itemBuilder: (context, index) => RecipeBundelCard(
                        reciep: snapshot.data![index],
                        press: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecipeDetailPage(
                                        reciep: snapshot.data![index]
                              )));
                        },
                      ),
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}