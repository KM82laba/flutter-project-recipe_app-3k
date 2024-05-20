// ignore_for_file: non_constant_identifier_names

import 'dart:typed_data';

class Recipe {
  final int? recipe_id;
  final int userId;
  final String title;
  final String? description;
  final Uint8List? image;
  final double? calories;
  final double? weight;
  final String? preparationTime;
  final int? servings;
  final String? category;
  
  Recipe({
    this.recipe_id,
    required this.userId,
    required this.title,
    this.description,
    this.image,
    this.calories,
    this.weight,
    this.preparationTime,
    this.servings,
    this.category,
  });

  Map<String, dynamic> toMap() {
    return {
      'recipe_id': recipe_id,
      'user_id': userId,
      'title': title,
      'description': description,
      'image': image,
      'calories': calories,
      'weight': weight,
      'preparation_time': preparationTime,
      'servings': servings,
      'category': category, 
    };
  }
}
