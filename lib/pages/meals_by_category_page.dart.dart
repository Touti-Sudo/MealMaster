import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/pages/recipe_detail_page.dart';
import 'package:login/services/favorite_service.dart';

class MealsByCategoryPage extends StatefulWidget {
  final String category;

  const MealsByCategoryPage({super.key, required this.category});

  @override
  State<MealsByCategoryPage> createState() => _MealsByCategoryPageState();
}

class _MealsByCategoryPageState extends State<MealsByCategoryPage> {
  List<dynamic> _meals = [];
  bool _isLoading = true;
  Map<String, bool> favoriteStatus = {};
  final user = FirebaseAuth.instance.currentUser!;
  final FavoriteService _favoriteService = FavoriteService();

  @override
  void initState() {
    super.initState();
    _fetchMealsByCategory();
    _loadFavorites();
  }

  Future<void> _fetchMealsByCategory() async {
    final response = await http.get(
      Uri.parse(
        'https://www.themealdb.com/api/json/v1/1/filter.php?c=${widget.category}',
      ),
    );
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _meals = data['meals'];
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load meals');
    }
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavorites(user.uid);
    setState(() {
      favoriteStatus = {for (var meal in favorites) meal['idMeal']: true};
    });
  }

  List<String> _extractIngredients(Map<String, dynamic> meal) {
    List<String> ingredients = [];
    for (int i = 1; i <= 20; i++) {
      final ingredient = meal['strIngredient$i'];
      final measure = meal['strMeasure$i'];
      if (ingredient != null &&
          ingredient.toString().isNotEmpty &&
          ingredient.toString().toLowerCase() != 'null') {
        ingredients.add('$ingredient - ${measure ?? ""}'.trim());
      }
    }
    return ingredients;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(title: Text(widget.category),backgroundColor: Theme.of(context).colorScheme.primary,),
      
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: _meals.length,
              itemBuilder: (context, index) {
                final meal = _meals[index];
                final mealId = meal['idMeal'];
                final isFavorite = favoriteStatus[mealId] ?? false;

                return GestureDetector(
                  onTap: () async {

                    final response = await http.get(
                      Uri.parse(
                        'https://www.themealdb.com/api/json/v1/1/lookup.php?i=$mealId',
                      ),
                    );
                    final data = json.decode(response.body);
                    final fullMeal = data['meals'][0];

                    final ingredients = _extractIngredients(fullMeal);

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeDetailPage(
                          title: fullMeal['strMeal'],
                          image: fullMeal['strMealThumb'],
                          description: fullMeal['strInstructions'] ?? '',
                          youtube: fullMeal['strYoutube'] ?? '',
                          ingredients: ingredients,
                        ),
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 6,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                          child: Image.network(
                            meal['strMealThumb'],
                            height: 200,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  meal['strMeal'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                ),
                                onPressed: () async {
                                  setState(() {
                                    favoriteStatus[mealId] = !isFavorite;
                                  });

                                  if (!isFavorite) {
                                    await _favoriteService.addToFavorites(
                                      user.uid,
                                      meal,
                                    );
                                  } else {
                                    await _favoriteService.removeFavorite(
                                      user.uid,
                                      mealId,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
