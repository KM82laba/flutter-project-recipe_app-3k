// ignore_for_file: use_build_context_synchronously, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipe.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/models/recipeIngredient.dart';
import 'package:flutter_application_project/models/recipeStep.dart';
import 'package:flutter_application_project/screens/profile/components/recipe_form_edit.dart';
import 'package:flutter_application_project/utils/utils.dart';
import '../../size_config.dart';


class ProfileEditReciep extends StatelessWidget {
  final RecipeCardInfo recipeCardInfo;

   const ProfileEditReciep({super.key, required this.recipeCardInfo});

  void onSubmit(BuildContext context , Recipe recipe, List<RecipeIngredient> ingredients, List<RecipeStep> steps) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    try {
      await databaseHelper.deleteRecipe(recipeCardInfo.recipe_id!);
      await databaseHelper.insertRecipe(recipe, steps, ingredients);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recipe updated successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update recipe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void onDelete(BuildContext context) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    try {
      await databaseHelper.deleteRecipe(recipeCardInfo.recipe_id!);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Recipe deleted successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete recipe: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: RecipeFormEdit(onSubmit: onSubmit, recipeCardInfo: recipeCardInfo , onDelete: onDelete),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: IconButton(
        icon: Icon(SolarIconsOutline.arrowLeft, color: Colors.white),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      centerTitle: true,
      title: const Text("Update Recipe", style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold)),
    );
  }
}
