class MealCategory {
  final String name;
  final String thumbnail;
  final String description;

  MealCategory({
    required this.name,
    required this.thumbnail,
    required this.description,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    return MealCategory(
      name: json['strCategory'],
      thumbnail: json['strCategoryThumb'],
      description: json['strCategoryDescription'],
    );
  }
}
