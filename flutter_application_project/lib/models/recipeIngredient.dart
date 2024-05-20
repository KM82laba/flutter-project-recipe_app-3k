// ignore_for_file: file_names

class RecipeIngredient {
  final int? id;
  int? recipeId;
  int ingredientId;
  int? quantity;
  String? unit;

  RecipeIngredient({this.id, this.recipeId, required this.ingredientId, this.quantity, this.unit});

  Map<String, dynamic> toMap() {
    return {
      'recipeIngredient_id': id,
      'recipe_id': recipeId,
      'ingredient_id': ingredientId,
      'quantity': quantity,
      'unit': unit,
    };
  }
}