import 'package:flutter/foundation.dart';

class RecipeProvider extends ChangeNotifier {
  final Set<String> _savedRecipeIds = {};

  List<String> get savedRecipeIds => _savedRecipeIds.toList();

  bool isSaved(String id) => _savedRecipeIds.contains(id);

  void toggleSaveRecipe(String id) {
    if (_savedRecipeIds.contains(id)) {
      _savedRecipeIds.remove(id);
    } else {
      _savedRecipeIds.add(id);
    }
    notifyListeners();
  }
}
