import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:login/pages/recipe_detail_page.dart';
import 'package:login/services/favorite_service.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final user = FirebaseAuth.instance.currentUser!;
  final FavoriteService _favoriteService = FavoriteService();

  List<Map<String, dynamic>> _favorites = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await _favoriteService.getFavorites(user.uid);
    setState(() {
      _favorites = favorites;
      _isLoading = false;
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
      appBar: AppBar(
        title: Text('Your Favorites'),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _favorites.isEmpty
              ? Center(child: Text('No favorites yet.'))
              : ListView.builder(
                  itemCount: _favorites.length,
                  itemBuilder: (context, index) {
                    final meal = _favorites[index];
                    final title = meal['strMeal'] ?? '';
                    final image = meal['strMealThumb'] ?? '';
                    final youtube = meal['strYoutube'] ?? '';
                    final instructions = meal['strInstructions'] ?? '';
                    final ingredients = _extractIngredients(meal);

                    return TweenAnimationBuilder(
                      tween: Tween<double>(begin: 0, end: 1),
                      duration: Duration(milliseconds: 500 + index * 100),
                      builder: (context, value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Dismissible(
                        key: Key(meal['idMeal']),
                        direction: DismissDirection.endToStart,
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          color: Colors.red,
                          child: Icon(Icons.delete, color: Colors.white, size: 35),
                        ),
                        confirmDismiss: (direction) async {
                          return await showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Remove Favorite"),
                              content: Text("Are you sure you want to remove this meal from favorites?"),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(false),
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(true),
                                  child: Text("Remove"),
                                ),
                              ],
                            ),
                          );
                        },
                        onDismissed: (direction) async {
                          await _favoriteService.removeFavorite(user.uid, meal['idMeal']);
                          setState(() {
                            _favorites.removeAt(index);
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("$title removed from favorites")),
                          );
                        },
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RecipeDetailPage(
                                  title: title,
                                  image: image,
                                  description: instructions,
                                  youtube: youtube,
                                  ingredients: ingredients,
                                ),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 4,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                                  child: Image.network(
                                    image,
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(12.0),
                                  child: Text(
                                    title,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
