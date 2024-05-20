// ignore_for_file: unused_import, file_names, depend_on_referenced_packages, prefer_const_declarations, no_leading_underscores_for_local_identifiers

import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter_application_project/models/ingredient.dart';
import 'package:flutter_application_project/models/recipe.dart';
import 'package:flutter_application_project/models/recipeCardInfo.dart';
import 'package:flutter_application_project/models/recipeIngredient.dart';
import 'package:flutter_application_project/models/recipeStep.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_application_project/models/user.dart';

class DatabaseHelper {
  static const _databaseName = "RecipeDatabaseApp.db";
  static const _databaseVersion = 1;

  static const table = 'Users';

  static const columnId = 'id';
  static const columnUsername = 'username';
  static const columnPassword = 'password';
  static const columnFirstName = 'firstName';
  static const columnLastName = 'lastName';

  static const recipesTable = 'Recipes';
  static const ingredientsTable = 'Ingredients';
  static const recipeIngredientTable = 'RecipeIngredient';
  static const recipeStepTable = 'RecipeStep';

  static const columnRecipeId = 'recipe_id';
  static const columnUserId = 'user_id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnImage = 'image';
  static const columnCalories = 'calories';
  static const columnWeight = 'weight';
  static const columnPreparationTime = 'preparation_time';
  static const columnServings = 'servings';
  static const columnCategory = 'category';

  static const columnIngredientId = 'ingredient_id';
  static const columnName = 'name';
  static const columnQuantity = 'quantity';
  static const columnUnit = 'unit';

  static const columnRecipeIngredientId = 'recipeIngredient_id';

  static const columnStepId = 'step_id';
  static const columnStepRecipeId = 'recipe_id';
  static const columnStepDescription = 'description';
  static const columnStepNumber = 'step_number';

  static const favoritesTable = 'Favorites';

  static const columnFavoriteId = 'favorite_id';

 static Database? _database;
 Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
 }

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
 }

Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUsername TEXT NOT NULL,
            $columnPassword TEXT NOT NULL,
            $columnFirstName TEXT NOT NULL,
            $columnLastName TEXT NOT NULL
          )
          ''');
     await db.execute('''
          CREATE TABLE $recipesTable (
            $columnRecipeId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserId INTEGER,
            $columnTitle TEXT NOT NULL,
            $columnDescription TEXT,
            $columnImage BLOB,
            $columnCalories REAL,
            $columnWeight REAL,
            $columnPreparationTime TEXT,
            $columnCategory TEXT,
            $columnServings INTEGER,
            FOREIGN KEY ($columnUserId) REFERENCES $table($columnId) ON DELETE CASCADE
          )
          ''');
          
    await db.execute('''
          CREATE TABLE $ingredientsTable (
            $columnIngredientId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnName TEXT NOT NULL
          )
          ''');

    await db.execute('''
          CREATE TABLE $recipeIngredientTable (
            $columnRecipeIngredientId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnRecipeId INTEGER,
            $columnIngredientId INTEGER,
            $columnQuantity INTEGER,
            $columnUnit TEXT,
            FOREIGN KEY ($columnRecipeId) REFERENCES $recipesTable($columnRecipeId) ON DELETE CASCADE,
            FOREIGN KEY ($columnIngredientId) REFERENCES $ingredientsTable($columnIngredientId) ON DELETE CASCADE
          )
          ''');
    await db.execute('''
          CREATE TABLE $recipeStepTable (
            $columnStepId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnStepRecipeId INTEGER,
            $columnStepDescription TEXT,
            $columnStepNumber INTEGER,
            FOREIGN KEY ($columnStepRecipeId) REFERENCES $recipesTable($columnRecipeId) ON DELETE CASCADE
          )
          ''');
    await db.execute('''
          CREATE TABLE $favoritesTable (
            $columnFavoriteId INTEGER PRIMARY KEY AUTOINCREMENT,
            $columnUserId INTEGER,
            $columnRecipeId INTEGER,
            FOREIGN KEY ($columnUserId) REFERENCES $table($columnId) ON DELETE CASCADE,
            FOREIGN KEY ($columnRecipeId) REFERENCES $recipesTable($columnRecipeId) ON DELETE CASCADE
          )
          ''');
}

 // CRUD operations: Create, Read, Update, Delete

 Future<int> insert(User user) async {
    Database db = await database;
    return await db.insert(table, user.toMap());
 }

 Future<List<User>> queryAll() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) {
      return User(
        id: maps[i][columnId],
        username: maps[i][columnUsername],
        password: maps[i][columnPassword],
        firstName: maps[i][columnFirstName],
        lastName: maps[i][columnLastName],
      );
    });
 }
 // Updates a user in the database with the provided User object.
 Future<int> update(User user) async {
    Database db = await database;
    int? id = user.id;
    return await db.update(table, user.toMap(),
        where: '$columnId = ?', whereArgs: [id]);
 }

 Future<int> delete(int id) async {
    Database db = await database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
 }

 Future<User?> getUserById(int id) async {
  Database db = await database;
  List<Map<String, dynamic>> maps = await db.query(table,
      where: '$columnId = ?',
      whereArgs: [id]);
  if (maps.isEmpty) {
    return null;
  }
  return User(
    id: maps[0][columnId],
    username: maps[0][columnUsername],
    password: maps[0][columnPassword],
    firstName: maps[0][columnFirstName],
    lastName: maps[0][columnLastName],
  );
}
  Future<int> insertRecipe(Recipe recipe, List<RecipeStep> steps, List<RecipeIngredient> recipeIngredients) async {
    Database db = await database;
    int recipeId = await db.insert(recipesTable, recipe.toMap());
    for (RecipeIngredient ingredient in recipeIngredients) {
      ingredient.recipeId = recipeId;
      await db.insert(recipeIngredientTable, ingredient.toMap());
    }
    for (RecipeStep step in steps) {
      step.recipeId = recipeId;
      await db.insert(recipeStepTable, step.toMap(recipeId));
    }
    return recipeId;
  }

  Future<List<Recipe>> queryAllRecipes() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(recipesTable);
    return List.generate(maps.length, (i) {
      return Recipe(
        recipe_id: maps[i][columnRecipeId],
        userId: maps[i][columnUserId],
        title: maps[i][columnTitle],
        description: maps[i][columnDescription],
        image: maps[i][columnImage],
        calories: maps[i][columnCalories],
        weight: maps[i][columnWeight],
        preparationTime: maps[i][columnPreparationTime],
        servings: maps[i][columnServings],
      );
    });
  }
  Future<int> updateRecipe(Recipe recipe) async {
    Database db = await database;
    int? id = recipe.recipe_id;
    return await db.update(recipesTable, recipe.toMap(),
        where: '$columnRecipeId =?', whereArgs: [id]);
  }
  Future<int> deleteRecipe(int id) async {
    Database db = await database;
    return await db.delete(recipesTable, where: '$columnRecipeId =?', whereArgs: [id]);
  }
  // Future<int> insertRecipeStep(RecipeStep step) async {
  //   Database db = await database;
  //   return await db.insert(recipeStepTable, step.toMap());
  // }
  Future<List<RecipeStep>> getRecipeSteps(int recipeId) async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      recipeStepTable,
      where: '$columnStepRecipeId =?',
      whereArgs: [recipeId],
    );
    return List.generate(maps.length, (i) {
      return RecipeStep(
        step_id: maps[i][columnStepId],
        recipeId: maps[i][columnStepRecipeId],
        description: maps[i][columnStepDescription],
        stepNumber: maps[i][columnStepNumber],
      );
    });
  }

  Future<int> insertIngredient(Ingredient ingredient) async {
    Database db = await database;
    return await db.insert(ingredientsTable, ingredient.toMap());
  }

  // Метод для получения всех ингредиентов из таблицы
  Future<List<Ingredient>> queryAllIngredients() async {
    Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query(ingredientsTable);
    return List.generate(maps.length, (i) {
      return Ingredient(
        ingredient_id: maps[i][columnIngredientId],
        name: maps[i][columnName],
      );
    });
  }

  Future<List<RecipeCardInfo>> getAllRecipes() async {
    final Database db = await database;
    final String _userIdKey = 'id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt(_userIdKey);

  List<Map<String, dynamic>> recipeData = await db.query(recipesTable);

  List<RecipeCardInfo> recipes = [];
  for (var recipeMap in recipeData) {
    int recipeId = recipeMap[columnRecipeId];

    List<Map<String, dynamic>> ingredientData = await db.query(recipeIngredientTable,
        where: '$columnRecipeId = ?', whereArgs: [recipeId]);
    

    List<IngredientCardRecipe> ingredients = [];
    for (var ingredientMap in ingredientData) {
      int ingredientId = ingredientMap[columnIngredientId];
      
      List<Map<String, dynamic>> ingredientInfo = await db.query(ingredientsTable,
          where: '$columnIngredientId = ?', whereArgs: [ingredientId]);

      if (ingredientInfo.isNotEmpty) {
        String name = ingredientInfo.first[columnName];
        IngredientCardRecipe ingredient = IngredientCardRecipe(
          ingredient_id: ingredientId,
          name: name,
          quantity: ingredientMap[columnQuantity],
          unit: ingredientMap[columnUnit],
        );
        ingredients.add(ingredient);
      }
    }

    List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
        where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);
    

    List<RecipeStepCard> steps = stepData.map((stepMap) {
      return RecipeStepCard(
        step_id: stepMap[columnStepId],
        description: stepMap[columnStepDescription],
        stepNumber: stepMap[columnStepNumber],
      );
    }).toList();

    List<Map<String, dynamic>> favoriteData = await db.query(favoritesTable,
        where: '$columnUserId = ? AND $columnRecipeId = ?',
        whereArgs: [userId, recipeId]);
    

    bool isFavorite = favoriteData.isNotEmpty;

    RecipeCardInfo recipe = RecipeCardInfo(
      recipe_id: recipeMap[columnRecipeId],
      user_id: recipeMap[columnUserId],
      title: recipeMap[columnTitle],
      description: recipeMap[columnDescription],
      image: recipeMap[columnImage],
      calories: recipeMap[columnCalories],
      weight: recipeMap[columnWeight],
      preparation_time: recipeMap[columnPreparationTime],
      servings: recipeMap[columnServings],
      ingredients: ingredients,
      steps: steps,
      is_favorite: isFavorite,
    );

    recipes.add(recipe);
  }

  return recipes;
  }

Future<List<RecipeCardInfo>> getAllRecipesByIngredients(List<String> ingredientNames) async {
  final Database db = await database;
  final String _userIdKey = 'id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt(_userIdKey);

  List<RecipeCardInfo> recipes = [];

  for (String ingredientName in ingredientNames) {
    List<Map<String, dynamic>> ingredientData = await db.query(ingredientsTable,
        where: '$columnName = ?', whereArgs: [ingredientName]);

    if (ingredientData.isNotEmpty) {
      int ingredientId = ingredientData.first[columnIngredientId];

      List<Map<String, dynamic>> recipeIdsData = await db.query(recipeIngredientTable,
          where: '$columnIngredientId = ?', whereArgs: [ingredientId]);

      for (var recipeIdMap in recipeIdsData) {
        int recipeId = recipeIdMap[columnRecipeId];

        List<Map<String, dynamic>> recipeData = await db.query(recipesTable,
            where: '$columnRecipeId = ?', whereArgs: [recipeId]);

        if (recipeData.isNotEmpty) {
          String title = recipeData.first[columnTitle];
          String description = recipeData.first[columnDescription];
          Uint8List image = recipeData.first[columnImage];
          double? calories = recipeData.first[columnCalories];
          double? weight = recipeData.first[columnWeight];
          String? preparationTime = recipeData.first[columnPreparationTime];
          int? servings = recipeData.first[columnServings];

          List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
              where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);

          List<RecipeStepCard> steps = stepData.map((stepMap) {
            return RecipeStepCard(
              step_id: stepMap[columnStepId],
              description: stepMap[columnStepDescription],
              stepNumber: stepMap[columnStepNumber],
            );
          }).toList();

          List<Map<String, dynamic>> favoriteData = await db.query(favoritesTable,
              where: '$columnUserId = ? AND $columnRecipeId = ?',
              whereArgs: [userId, recipeId]);

          bool isFavorite = favoriteData.isNotEmpty;

          RecipeCardInfo recipe = RecipeCardInfo(
            recipe_id: recipeId,
            user_id: recipeData.first[columnUserId],
            title: title,
            description: description,
            image: image,
            calories: calories,
            weight: weight,
            preparation_time: preparationTime,
            servings: servings,
            ingredients: [],
            steps: steps,
            is_favorite: isFavorite,
          );
          List<Map<String, dynamic>> ingredientDataForRecipe = await db.query(recipeIngredientTable,
              where: '$columnRecipeId = ?', whereArgs: [recipeId]);

          List<IngredientCardRecipe> ingredients = [];
          for (var ingredientMap in ingredientDataForRecipe) {
            int ingredientId = ingredientMap[columnIngredientId];

            List<Map<String, dynamic>> ingredientInfo = await db.query(ingredientsTable,
                where: '$columnIngredientId = ?', whereArgs: [ingredientId]);

            if (ingredientInfo.isNotEmpty) {
              String name = ingredientInfo.first[columnName];
              IngredientCardRecipe ingredient = IngredientCardRecipe(
                ingredient_id: ingredientId,
                name: name,
                quantity: ingredientMap[columnQuantity],
                unit: ingredientMap[columnUnit],
              );
              ingredients.add(ingredient);
            }
          }

          recipe.ingredients = ingredients;

          recipes.add(recipe);
        }
      }
    }
  }

  return recipes;
}



Future<List<RecipeCardInfo>> getAllRecipesByCategory({required String category}) async {
  final Database db = await database;
  final String _userIdKey = 'id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt(_userIdKey);

  List<Map<String, dynamic>> recipeData;
  if (category == "All") {
    recipeData = await db.query(recipesTable);
  } else {
    recipeData = await db.query(recipesTable, where: '$columnCategory = ?', whereArgs: [category]);
  }

  List<RecipeCardInfo> recipes = [];
  for (var recipeMap in recipeData) {
    int recipeId = recipeMap[columnRecipeId];

    List<Map<String, dynamic>> ingredientData = await db.query(recipeIngredientTable,
        where: '$columnRecipeId = ?', whereArgs: [recipeId]);

    List<IngredientCardRecipe> ingredients = [];
    for (var ingredientMap in ingredientData) {
      int ingredientId = ingredientMap[columnIngredientId];

      List<Map<String, dynamic>> ingredientInfo = await db.query(ingredientsTable,
          where: '$columnIngredientId = ?', whereArgs: [ingredientId]);

      if (ingredientInfo.isNotEmpty) {
        String name = ingredientInfo.first[columnName];
        IngredientCardRecipe ingredient = IngredientCardRecipe(
          ingredient_id: ingredientId,
          name: name,
          quantity: ingredientMap[columnQuantity],
          unit: ingredientMap[columnUnit],
        );
        ingredients.add(ingredient);
      }
    }

    List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
        where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);

    List<RecipeStepCard> steps = stepData.map((stepMap) {
      return RecipeStepCard(
        step_id: stepMap[columnStepId],
        description: stepMap[columnStepDescription],
        stepNumber: stepMap[columnStepNumber],
      );
    }).toList();

    List<Map<String, dynamic>> favoriteData = await db.query(favoritesTable,
        where: '$columnUserId = ? AND $columnRecipeId = ?',
        whereArgs: [userId, recipeId]);

    bool isFavorite = favoriteData.isNotEmpty;

    RecipeCardInfo recipe = RecipeCardInfo(
      recipe_id: recipeMap[columnRecipeId],
      user_id: recipeMap[columnUserId],
      title: recipeMap[columnTitle],
      description: recipeMap[columnDescription],
      image: recipeMap[columnImage],
      calories: recipeMap[columnCalories],
      weight: recipeMap[columnWeight],
      preparation_time: recipeMap[columnPreparationTime],
      servings: recipeMap[columnServings],
      ingredients: ingredients,
      steps: steps,
      is_favorite: isFavorite,
    );

    recipes.add(recipe);
  }

  return recipes;
}
Future<List<RecipeCardInfo>> getAllUserFavoriteRecipes() async {
  final Database db = await database;
  final String _userIdKey = 'id';
  SharedPreferences prefs = await SharedPreferences.getInstance();
  int? userId = prefs.getInt(_userIdKey);

  List<Map<String, dynamic>> favoriteRecipesData = await db.rawQuery('''
    SELECT * FROM $recipesTable 
    INNER JOIN $favoritesTable 
    ON $recipesTable.$columnRecipeId = $favoritesTable.$columnRecipeId
    WHERE $favoritesTable.$columnUserId = ?
  ''', [userId]);

  List<RecipeCardInfo> recipes = [];
  for (var recipeMap in favoriteRecipesData) {
    int recipeId = recipeMap[columnRecipeId];

    // Fetching ingredients
    List<Map<String, dynamic>> ingredientData = await db.query(recipeIngredientTable,
        where: '$columnRecipeId = ?', whereArgs: [recipeId]);
    List<IngredientCardRecipe> ingredients = [];
    for (var ingredientMap in ingredientData) {
      int ingredientId = ingredientMap[columnIngredientId];
      List<Map<String, dynamic>> ingredientInfo = await db.query(ingredientsTable,
          where: '$columnIngredientId = ?', whereArgs: [ingredientId]);
      if (ingredientInfo.isNotEmpty) {
        String name = ingredientInfo.first[columnName];
        IngredientCardRecipe ingredient = IngredientCardRecipe(
          ingredient_id: ingredientId,
          name: name,
          quantity: ingredientMap[columnQuantity],
          unit: ingredientMap[columnUnit],
        );
        ingredients.add(ingredient);
      }
    }

    // Fetching steps
    List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
        where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);
    List<RecipeStepCard> steps = stepData.map((stepMap) {
      return RecipeStepCard(
        step_id: stepMap[columnStepId],
        description: stepMap[columnStepDescription],
        stepNumber: stepMap[columnStepNumber],
      );
    }).toList();

    // Checking if recipe is favorite
    bool isFavorite = true;

    RecipeCardInfo recipe = RecipeCardInfo(
      recipe_id: recipeMap[columnRecipeId],
      user_id: recipeMap[columnUserId],
      title: recipeMap[columnTitle],
      description: recipeMap[columnDescription],
      image: recipeMap[columnImage],
      calories: recipeMap[columnCalories],
      weight: recipeMap[columnWeight],
      preparation_time: recipeMap[columnPreparationTime],
      servings: recipeMap[columnServings],
      ingredients: ingredients,
      steps: steps,
      is_favorite: isFavorite,
    );

    recipes.add(recipe);
  }

  return recipes;
}


  Future<RecipeCardInfo> getRecipeCardInfo(int recipeId, int userId) async {
      final Database db = await database;
      List<Map<String, dynamic>> recipeData = await db.query(recipesTable,
          where: '$columnRecipeId = ?', whereArgs: [recipeId]);

      if (recipeData.isEmpty) {
        throw Exception('Recipe with id $recipeId not found.');
      }

      Map<String, dynamic> recipeMap = recipeData.first;

      List<Map<String, dynamic>> ingredientData = await db.query(recipeIngredientTable,
          where: '$columnRecipeId = ?', whereArgs: [recipeId]);

      List<IngredientCardRecipe> ingredients = ingredientData.map((ingredientMap) {
        return IngredientCardRecipe(
          ingredient_id: ingredientMap[columnIngredientId],
          name: ingredientMap[columnName],
          quantity: ingredientMap[columnQuantity],
          unit: ingredientMap[columnUnit],
        );
      }).toList();

      List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
          where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);

      List<RecipeStepCard> steps = stepData.map((stepMap) {
        return RecipeStepCard(
          step_id: stepMap[columnStepId],
          description: stepMap[columnStepDescription],
          stepNumber: stepMap[columnStepNumber],
        );
      }).toList();

      List<Map<String, dynamic>> favoriteData = await db.query(favoritesTable,
          where: '$columnUserId = ? AND $columnRecipeId = ?',
          whereArgs: [userId, recipeId]);

      bool isFavorite = favoriteData.isNotEmpty;

      return RecipeCardInfo(
        recipe_id: recipeMap[columnRecipeId],
        user_id: recipeMap[columnUserId],
        title: recipeMap[columnTitle],
        description: recipeMap[columnDescription],
        image: recipeMap[columnImage],
        calories: recipeMap[columnCalories],
        weight: recipeMap[columnWeight],
        preparation_time: recipeMap[columnPreparationTime],
        servings: recipeMap[columnServings],
        ingredients: ingredients,
        steps: steps,
        is_favorite: isFavorite,
      );
  }
  Future<List<RecipeCardInfo>> getUserRecipes(int userId) async {
  final Database db = await database;

  List<Map<String, dynamic>> recipeData = await db.query(recipesTable,
      where: '$columnUserId = ?', whereArgs: [userId]);

  List<RecipeCardInfo> recipes = [];
  for (var recipeMap in recipeData) {
    int recipeId = recipeMap[columnRecipeId];

    List<Map<String, dynamic>> ingredientData = await db.query(recipeIngredientTable,
        where: '$columnRecipeId = ?', whereArgs: [recipeId]);
    

    List<IngredientCardRecipe> ingredients = [];
    for (var ingredientMap in ingredientData) {
      int ingredientId = ingredientMap[columnIngredientId];
      
      List<Map<String, dynamic>> ingredientInfo = await db.query(ingredientsTable,
          where: '$columnIngredientId = ?', whereArgs: [ingredientId]);

      if (ingredientInfo.isNotEmpty) {
        String name = ingredientInfo.first[columnName];
        IngredientCardRecipe ingredient = IngredientCardRecipe(
          ingredient_id: ingredientId,
          name: name,
          quantity: ingredientMap[columnQuantity],
          unit: ingredientMap[columnUnit],
        );
        ingredients.add(ingredient);
      }
    }

    List<Map<String, dynamic>> stepData = await db.query(recipeStepTable,
        where: '$columnStepRecipeId = ?', whereArgs: [recipeId]);
    

    List<RecipeStepCard> steps = stepData.map((stepMap) {
      return RecipeStepCard(
        step_id: stepMap[columnStepId],
        description: stepMap[columnStepDescription],
        stepNumber: stepMap[columnStepNumber],
      );
    }).toList();

    List<Map<String, dynamic>> favoriteData = await db.query(favoritesTable,
        where: '$columnUserId = ? AND $columnRecipeId = ?',
        whereArgs: [userId, recipeId]);
    

    bool isFavorite = favoriteData.isNotEmpty;

    RecipeCardInfo recipe = RecipeCardInfo(
      recipe_id: recipeMap[columnRecipeId],
      user_id: recipeMap[columnUserId],
      title: recipeMap[columnTitle],
      description: recipeMap[columnDescription],
      image: recipeMap[columnImage],
      calories: recipeMap[columnCalories],
      weight: recipeMap[columnWeight],
      preparation_time: recipeMap[columnPreparationTime],
      servings: recipeMap[columnServings],
      ingredients: ingredients,
      steps: steps,
      is_favorite: isFavorite,
    );

    recipes.add(recipe);
  }

  return recipes;
}

  Future<void> updateFavoriteStatus(int recipeId, bool isFavorite) async {
    final Database db = await database;
    final String _userIdKey = 'id';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt(_userIdKey);

    if (!isFavorite) {
      await db.delete(favoritesTable,
          where: '$columnUserId =? AND $columnRecipeId =?',
          whereArgs: [userId, recipeId]);
    }
    else {
      await db.insert(favoritesTable, {'user_id': userId, 'recipe_id': recipeId});
    }
  }
}
