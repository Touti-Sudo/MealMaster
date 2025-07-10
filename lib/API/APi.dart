import 'dart:convert';
import 'package:http/http.dart' as http;

class RecipeApi {
  static Future<List<dynamic>> searchRecipes(String mealName) async {
    final url = Uri.parse("https://www.themealdb.com/api/json/v1/1/search.php?s=$mealName");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'] ?? [];
    } else {
      throw Exception("Failed to load recipes");
    }
  }


  static Future<dynamic> getRandomMeal() async {
    final url = Uri.parse("https://www.themealdb.com/api/json/v1/1/random.php");
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['meals'][0];
    } else {
      throw Exception("Failed to fetch random meal");
    }
  }

  static Future<List<dynamic>> fetchCategories() async {
      final response = await http.get(
        Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'),
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['categories'];
      } else {
        throw Exception('Failed to fetch categories');
      }
    }

  static Future<List<dynamic>> fetchMealsByCategory(String category) async {
    final response = await http.get(
      Uri.parse('https://www.themealdb.com/api/json/v1/1/filter.php?c=$category'),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['meals'];
    } else {
      throw Exception('Failed to fetch meals by category');
    }
  }
}