// ignore_for_file: file_names, non_constant_identifier_names

class RecipeStep {
  final int? step_id;
  int? recipeId;
  String description;
  int stepNumber;

  RecipeStep({this.step_id, this.recipeId, required this.description, required this.stepNumber});

  Map<String, dynamic> toMap(recipeId_value) {
    return {
      'step_id': step_id,
      'recipe_id': recipeId_value,
      'description': description,
      'step_number': stepNumber,
    };
  }
}