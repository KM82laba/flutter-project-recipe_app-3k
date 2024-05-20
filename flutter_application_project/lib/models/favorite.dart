class Favorite {
  final int? id;
  final int userId;
  final int recipeId;

  Favorite({this.id, required this.userId, required this.recipeId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'recipeId': recipeId,
    };
  }
}