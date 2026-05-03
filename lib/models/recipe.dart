class Ingredient {
  final String name;

  const Ingredient({required this.name});
}

class Recipe {
  final String id;
  final String name;
  final String country;
  final String category;
  final List<Ingredient> ingredients;
  final List<String> steps;
  final String? youtubeUrl;

  const Recipe({
    required this.id,
    required this.name,
    required this.country,
    required this.category,
    required this.ingredients,
    required this.steps,
    this.youtubeUrl,
  });
}
