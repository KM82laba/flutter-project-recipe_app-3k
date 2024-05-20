// ignore_for_file: file_names, non_constant_identifier_names

class Ingredient {
  final int? ingredient_id;
  final String name;

  Ingredient({this.ingredient_id, required this.name});

  Map<String, dynamic> toMap() {
    return {
      'ingredient_id': ingredient_id,
      'name': name,
    };
  }
}