import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/utils/utils.dart';

class SearchRecipesWidget extends StatefulWidget {
  final Function(List<RecipeCardInfo>) onSearch; // Объявляем колбэк функцию onSearch

  const SearchRecipesWidget({Key? key, required this.onSearch}) : super(key: key);

  @override
  _SearchRecipesWidgetState createState() => _SearchRecipesWidgetState();
}

class _SearchRecipesWidgetState extends State<SearchRecipesWidget> {
  final TextEditingController _ingredientController = TextEditingController();
  List<String> selectedIngredients = [];
  DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return 
    Padding(
    padding: const EdgeInsets.only(left: defaultPadding * 1.5, right: defaultPadding * 1.5),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 10),
        Padding(
            padding: const EdgeInsets.symmetric(vertical: defaultPadding),
            child: TextFormField(
              controller: _ingredientController,
              textInputAction: TextInputAction.done,
              cursorColor: kPrimaryColor,
              decoration: const InputDecoration(
                hintText: "Enter ingredient",
                prefixIcon: Padding(
                 padding: EdgeInsets.all(defaultPadding),
                 child: Icon(
                  SolarIconsOutline.magnifier
                  ),
                ),
              ),
            ),
          ),
        SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          children: selectedIngredients.map((ingredient) {
            return Chip(
              label: Text(ingredient),
              onDeleted: () {
                setState(() {
                  selectedIngredients.remove(ingredient);
                });
              },
            );
          }).toList(),
        ),
        SizedBox(height: 10),
        Row(
          children: [
          const SizedBox(width: 35),
          ElevatedButton(
          onPressed: () {
            String ingredientName = _ingredientController.text.trim();
            if (ingredientName.isNotEmpty) {
              setState(() {
                selectedIngredients.add(ingredientName);
                _ingredientController.clear();
              });
            }
          },
          style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade300,
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                ),
              ),
          child: Text('Add Ingredient'.toUpperCase(),
                style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 10),
        ElevatedButton(
          onPressed: () async {
            if (selectedIngredients.isNotEmpty) {
              List<RecipeCardInfo> recipes =
              await _databaseHelper.getAllRecipesByIngredients(selectedIngredients);
              widget.onSearch(recipes);
            }
          },
          style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(8),
                ),
              ),
          child: Text('Search'.toUpperCase(),
                style: TextStyle(color: Colors.white),
                ),
        ),
          ],
        )
        
      ],
    )
    );
  }

  @override
  void dispose() {
    _ingredientController.dispose();
    super.dispose();
  }
}
