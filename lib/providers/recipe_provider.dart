import 'package:flutter/foundation.dart' hide Category;
import '../models/meal.dart';
import '../models/category.dart';
import '../data/api_service.dart';
import '../data/database_helper.dart';

class RecipeProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Meal> _randomMeals = [];
  List<Meal> get randomMeals => _randomMeals;

  List<Meal> _exploreMeals = [];
  List<Meal> get exploreMeals => _exploreMeals;

  List<Meal> _savedMeals = [];
  List<Meal> get savedMeals => _savedMeals;

  List<Category> _categories = [];
  List<Category> get categories => _categories;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  RecipeProvider() {
    loadCategories();
    _initMeals();
    loadSavedMeals();
  }

  Future<void> _initMeals() async {
    _isLoading = true;
    notifyListeners();
    final defaultMeals = await _apiService.searchMeals('');
    _randomMeals = List.from(defaultMeals);
    _exploreMeals = List.from(defaultMeals);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategories() async {
    _categories = await _apiService.getCategories();
    notifyListeners();
  }

  Future<void> searchMeals(String query) async {
    _isLoading = true;
    notifyListeners();

    _exploreMeals = await _apiService.searchMeals(query);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadSavedMeals() async {
    _savedMeals = await _dbHelper.getFavorites();
    notifyListeners();
  }

  bool isSaved(String id) {
    return _savedMeals.any((meal) => meal.idMeal == id);
  }

  Future<void> toggleSaveRecipe(Meal meal) async {
    await _dbHelper.toggleFavorite(meal);
    await loadSavedMeals();
  }
}
