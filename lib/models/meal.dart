class Meal {
  final String idMeal;
  final String strMeal;
  final String strCategory;
  final String strArea;
  final String strInstructions;
  final String strMealThumb;
  final String strTags;
  final String strYoutube;
  final List<String> ingredients;
  final List<String> measures;

  Meal({
    required this.idMeal,
    required this.strMeal,
    required this.strCategory,
    required this.strArea,
    required this.strInstructions,
    required this.strMealThumb,
    required this.strTags,
    required this.strYoutube,
    required this.ingredients,
    required this.measures,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    List<String> ingredients = [];
    List<String> measures = [];

    for (int i = 1; i <= 20; i++) {
      String? ingredient = json['strIngredient$i'];
      String? measure = json['strMeasure$i'];

      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(ingredient.trim());
        measures.add((measure != null && measure.trim().isNotEmpty) ? measure.trim() : '');
      }
    }

    return Meal(
      idMeal: json['idMeal'] as String? ?? '',
      strMeal: json['strMeal'] as String? ?? '',
      strCategory: json['strCategory'] as String? ?? '',
      strArea: json['strArea'] as String? ?? '',
      strInstructions: json['strInstructions'] as String? ?? '',
      strMealThumb: json['strMealThumb'] as String? ?? '',
      strTags: json['strTags'] as String? ?? '',
      strYoutube: json['strYoutube'] as String? ?? '',
      ingredients: ingredients,
      measures: measures,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'idMeal': idMeal,
      'strMeal': strMeal,
      'strCategory': strCategory,
      'strArea': strArea,
      'strInstructions': strInstructions,
      'strMealThumb': strMealThumb,
      'strTags': strTags,
      'strYoutube': strYoutube,
      'ingredients': ingredients.join('||'),
      'measures': measures.join('||'),
    };
  }

  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      idMeal: map['idMeal'] as String? ?? '',
      strMeal: map['strMeal'] as String? ?? '',
      strCategory: map['strCategory'] as String? ?? '',
      strArea: map['strArea'] as String? ?? '',
      strInstructions: map['strInstructions'] as String? ?? '',
      strMealThumb: map['strMealThumb'] as String? ?? '',
      strTags: map['strTags'] as String? ?? '',
      strYoutube: map['strYoutube'] as String? ?? '',
      ingredients: (map['ingredients'] as String? ?? '').split('||').where((e) => e.isNotEmpty).toList(),
      measures: (map['measures'] as String? ?? '').split('||').where((e) => e.isNotEmpty).toList(),
    );
  }
}
