import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login/API/APi.dart';
import 'package:login/pages/meals_by_category_page.dart.dart';
import 'package:login/pages/recipe_detail_page.dart';
import 'package:login/services/favorite_service.dart';
import 'package:login/util/emoji.dart';

class SecondPage extends StatefulWidget {
  const SecondPage({super.key});

  @override
  State<SecondPage> createState() => _SecondPageState();
}

class _SecondPageState extends State<SecondPage> {
  Widget fadeSlideAnimation(Widget child, int index, {double offsetY = 30,}) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0, end: 1),
      duration: Duration(milliseconds: 1000 + index * 100),
      builder: (context, value, _) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, (1 - value) * offsetY),
            child: child,
          ),
        );
      },
    );
  }

  Widget _buildCategoryCard(
    Map<String, dynamic> category,
    BuildContext context,
  ) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                MealsByCategoryPage(category: category['strCategory']),
          ),
        );
      },
      child: Container(
        height: 180,
        margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          image: DecorationImage(
            image: NetworkImage(category['strCategoryThumb']),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.4),
              BlendMode.darken,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(
            category['strCategory'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
              shadows: [Shadow(color: Colors.black, blurRadius: 10)],
            ),
          ),
        ),
      ),
    );
  }

  List<dynamic> _categories = [];

  Future<void> _fetchCategories() async {
    final response = await RecipeApi.fetchCategories();
    setState(() {
      _categories = response;
    });
  }

  bool _isLoading = false;
  List<dynamic> _randomMeals = [];
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

  void onPressed() async {}
  void _fetchRandomMeals() async {
    setState(() {
      _isLoading = true;
    });

    List<dynamic> results = [];
    for (int i = 0; i < 20; i++) {
      final meal = await RecipeApi.getRandomMeal();
      results.add(meal);
    }

    setState(() {
      _randomMeals = results;
      _isLoading = false;
    });
  }

  Future<void> _loadFavorites() async {
    final userId = user.uid;
    final FavoriteService _favoriteService = FavoriteService();

    final favorites = await _favoriteService.getFavorites(userId);

    setState(() {
      favoriteStatus = {for (var meal in favorites) meal['idMeal']: true};
    });
  }

  final TextEditingController _controller = TextEditingController();
  List<dynamic> _recipes = [];

  void _search(String mealName) async {
    final results = await RecipeApi.searchRecipes(mealName);
    setState(() {
      _recipes = results;
    });
  }

  final user = FirebaseAuth.instance.currentUser!;
  List<Map<String, dynamic>> meals = [];
  Map<String, bool> favoriteStatus = {};

  @override
  void initState() {
    super.initState();
    _fetchRandomMeals();
    _loadFavorites();
    _fetchCategories();
  }

  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      appBar: AppBar(
        title: Text('MasterMeal'),
        backgroundColor: Theme.of(context).colorScheme.primary,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              _fetchRandomMeals();
              _controller.clear();
              setState(() {
                _recipes = [];
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DrawerHeader(
              child: Image.asset(
                "assets/images/icon.png",
                height: 700,
                width: 700,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Emoji(),
                SizedBox(width: 10),
                Text("Hi again ${user!.email!}"),
              ],
            ),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.home_rounded),
                    title: Text("H O M E"),
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.favorite),
                    title: Text("F A V O R I T E S"),
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/favorites');
                    },
                  ),

                  ListTile(
                    leading: Icon(Icons.settings),
                    title: Text("S E T T I N G S"),
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/settingspage');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.person),
                    title: Text("P R O F I L"),
                    iconColor: Colors.redAccent,
                    onTap: () {
                      Navigator.pushNamed(context, '/profilepage');
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.logout),
                    title: Text("L O G O U T"),
                    iconColor: Colors.redAccent,
                    onTap: () async {
                      await FirebaseAuth.instance.signOut();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 50,
                  child: SearchBar(
                    hintText: "Which recipe are you looking for?",
                    hintStyle: WidgetStatePropertyAll(
                      TextStyle(color: Colors.black),
                    ),
                    backgroundColor: WidgetStatePropertyAll(Colors.white),
                    leading: Icon(Icons.search, color: Colors.black),
                    onSubmitted: (value) {
                      _search(value.trim());
                    },
                  ),
                ),
              ),
              if (_categories.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    fadeSlideAnimation(
                      const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: Text(
                          "🍽 Categories",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      0,
                    ),
                    SizedBox(
                      height: 400,
                      child: PageView.builder(
                        itemCount: (_categories.length / 4).ceil(),
                        controller: PageController(viewportFraction: 0.95),
                        itemBuilder: (context, pageIndex) {
                          final start = pageIndex * 4;
                          final end = (start + 4) > _categories.length
                              ? _categories.length
                              : (start + 4);
                          final pageItems = _categories.sublist(start, end);

                          return GridView.count(

                            crossAxisCount: 2,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            padding: const EdgeInsets.all(8),
                            mainAxisSpacing: 12,
                            crossAxisSpacing: 12,
                            children: List.generate(pageItems.length, (index) {
                              return fadeSlideAnimation(
                                _buildCategoryCard(pageItems[index], context),
                                index,
                              );
                            }),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              fadeSlideAnimation(
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16.0,
                    vertical: 12,
                  ),
                  child: Text(
                    _recipes.isNotEmpty
                        ? "🔍 Search results:"
                        : "🔥🔥 Hot recipes :",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                0,
              ),

              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : (_recipes.isNotEmpty ? _recipes : _randomMeals).isEmpty
                  ? Center(child: Text("No recipes found."))
                  : Column(
                      children: (_recipes.isNotEmpty ? _recipes : _randomMeals)
                          .asMap()
                          .entries
                          .map((entry) {
                            final index = entry.key;
                            final meal = entry.value;
                            final title = meal['strMeal'] ?? '';
                            final image = meal['strMealThumb'] ?? '';
                            final youtube = meal['strYoutube'] ?? '';
                            final instructions = meal['strInstructions'] ?? '';
                            final description =
                                instructions.split('.').take(2).join('. ') +
                                '.';
                            final ingredients = _extractIngredients(meal);
                            final mealId = meal['idMeal'];
                            final isFavorite = favoriteStatus[mealId] ?? false;
                            final FavoriteService _favoriteService =
                                FavoriteService();

                            return fadeSlideAnimation( GestureDetector(
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
                                child: Container(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(16),
                                        ),
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
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12.0,
                                        ),
                                        child: Text(
                                          description,
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(
                                            color: Colors.grey[700],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.symmetric(),
                                            child: ElevatedButton.icon(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    WidgetStatePropertyAll(
                                                      Colors.grey[350],
                                                    ),
                                              ),
                                              onPressed: () {},
                                              label: IconButton(
                                                icon: Icon(
                                                  isFavorite
                                                      ? Icons.favorite
                                                      : Icons.favorite_border,
                                                  color: Colors.red,
                                                  size: 20,
                                                ),
                                                onPressed: () async {
                                                  final userId = user!.uid;
                                                  setState(() {
                                                    favoriteStatus[mealId] =
                                                        !isFavorite;
                                                  });

                                                  if (!isFavorite) {
                                                    await _favoriteService
                                                        .addToFavorites(
                                                          userId,
                                                          meal,
                                                        );
                                                  } else {
                                                    await _favoriteService
                                                        .removeFavorite(
                                                          userId,
                                                          mealId,
                                                        );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                    ],
                                  ),
                                ),
                              ),
                               index,
                            );
                          })
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
