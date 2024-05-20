// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_application_project/constants.dart';
import 'package:flutter_application_project/dbhelper/DatabaseHelper.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/screens/ReciepList/components/list_recieps.dart';
import 'package:flutter_application_project/screens/ReciepList/components/search.dart';
import '../../size_config.dart';

class ListReciepScreen extends StatefulWidget {
  const ListReciepScreen({Key? key}) : super(key: key);

  @override
  _ListReciepScreenState createState() => _ListReciepScreenState();
}

class _ListReciepScreenState extends State<ListReciepScreen> {
  List<String> selectedIngredients = [];
  List<RecipeCardInfo> filteredRecipes = []; // Добавлено для отображения отфильтрованных результатов

  void _searchRecipes(List<RecipeCardInfo> selectedrecieps) async {
    if (selectedrecieps.isNotEmpty) {
      setState(() {
        filteredRecipes = selectedrecieps;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      appBar: buildAppBar(context),
      body: Column(
        children: [
          SearchRecipesWidget(
            onSearch: _searchRecipes,
          ),
          Expanded(
            child: ListCardsRecipe(recipes: filteredRecipes)
          ),
        ],
      ),
    );
  }

  AppBar buildAppBar(context) {
    return AppBar(
      backgroundColor: kPrimaryColor,
      leading: const SizedBox(),
      centerTitle: true,
      title: const Text("Explore",
          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
    );
  }
}
