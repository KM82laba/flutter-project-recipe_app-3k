// ignore_for_file: file_names, non_constant_identifier_names

import 'dart:typed_data';

class RecipeCardInfo {
  final int? recipe_id;
  final int user_id;
  final String title;
  final String? description;
  final Uint8List? image;
  final double? calories;
  final double? weight;
  final String? preparation_time;
  final int? servings;
  final String? category;
  List<IngredientCardRecipe> ingredients;
  final List<RecipeStepCard> steps;
  bool is_favorite;

  RecipeCardInfo({
    this.recipe_id,
    required this.user_id,
    required this.title,
    this.description,
    this.image,
    this.calories,
    this.weight,
    this.preparation_time,
    this.servings,
    this.category,
    required this.ingredients,
    required this.steps,
    this.is_favorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipe_id': recipe_id,
      'user_id': user_id,
      'title': title,
      'description': description,
      'image': image,
      'calories': calories,
      'weight': weight,
      'preparation_time': preparation_time,
      'servings': servings,
      'category': category,
      'is_favorite': is_favorite,
      'ingredients': ingredients.map((ingredient) => ingredient.toMap()).toList(),
      'steps': steps.map((step) => step.toMap()).toList(),
    };
  }
}

class IngredientCardRecipe {
  final int? ingredient_id;
  final String name;
  final int? quantity;
  final String? unit;

  IngredientCardRecipe({
    this.ingredient_id,
    required this.name,
    this.quantity,
    this.unit,
  });

  Map<String, dynamic> toMap() {
    return {
      'ingredient_id': ingredient_id,
      'name': name,
      'quantity': quantity,
      'unit': unit,
    };
  }
}

class RecipeStepCard {
  final int? step_id;
  final String description;
  final int stepNumber;

  RecipeStepCard({
    this.step_id,
    required this.description,
    required this.stepNumber,
  });

  Map<String, dynamic> toMap() {
    return {
      'step_id': step_id,
      'description': description,
      'step_number': stepNumber,
    };
  }
}
