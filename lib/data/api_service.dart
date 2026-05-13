import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/meal.dart';
import '../models/category.dart';

class ApiService {
  static const String _baseUrl = 'https://www.themealdb.com/api/json/v1/1';

  Future<List<Meal>> searchMeals(String query) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/search.php?s=$query'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['meals'] != null) {
          return (data['meals'] as List).map((json) => Meal.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('Error searching meals: $e');
    }
    return [];
  }

  Future<List<Category>> getCategories() async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/categories.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['categories'] != null) {
          return (data['categories'] as List).map((json) => Category.fromJson(json)).toList();
        }
      }
    } catch (e) {
      print('Error getting categories: $e');
    }
    return [];
  }
}
