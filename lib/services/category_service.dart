import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:login/models/category.dart';

class MealService {
  Future<List<MealCategory>> fetchCategories() async {
    final response = await http.get(Uri.parse('https://www.themealdb.com/api/json/v1/1/categories.php'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['categories'] as List)
          .map((json) => MealCategory.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load categories');
    }
  }
}
