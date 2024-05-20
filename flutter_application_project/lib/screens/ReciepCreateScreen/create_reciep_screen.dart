// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipe.dart';
import 'package:flutter_application_project/models/recipeIngredient.dart';
import 'package:flutter_application_project/models/recipeStep.dart';
import 'package:flutter_application_project/screens/ReciepCreateScreen/components/recipe_form.dart';
import '../../size_config.dart';

class CreateReciepScreen extends StatelessWidget {
  const CreateReciepScreen({super.key});

  void onSubmit(BuildContext context , Recipe recipe, List<RecipeIngredient> ingredients, List<RecipeStep> steps) async {
    final DatabaseHelper databaseHelper = DatabaseHelper();
    try {
      await databaseHelper.insertRecipe(recipe, steps, ingredients);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Recipe created successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to create recipe: $e'),
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
      body: RecipeForm(onSubmit: onSubmit),
      // bottomNavigationBar: const MyBottomNavBar(),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: const SizedBox(),
      centerTitle: true,
      title: const Text("Create Recipe", style: TextStyle(color: Colors.white , fontSize: 20 , fontWeight: FontWeight.bold)),
    );
  }

}
