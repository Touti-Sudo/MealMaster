import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class RecipeDetailPage extends StatefulWidget {
  final String title;
  final String image;
  final String description;
  final String youtube;
  final List<String> ingredients;

  const RecipeDetailPage({
    super.key,
    required this.title,
    required this.image,
    required this.description,
    required this.youtube,
    required this.ingredients,
  });

  @override
  State<RecipeDetailPage> createState() => _RecipeDetailPageState();
}

class _RecipeDetailPageState extends State<RecipeDetailPage> {
late YoutubePlayerController _controller;
@override
void initState() {
  super.initState();
  final videoID = YoutubePlayer.convertUrlToId(widget.youtube);
  _controller = YoutubePlayerController(
    initialVideoId: videoID ?? '',
    flags: const YoutubePlayerFlags(
      autoPlay: false,
      mute: false,
    ),
  );
}

@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
@override
Widget build(BuildContext context) {
  return YoutubePlayerBuilder(
    player: YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
    ),
    builder: (context, player) {
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(widget.title),
          backgroundColor: Theme.of(context).colorScheme.primary,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  widget.image,
                  width: double.infinity,
                  height: 250,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                widget.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Theme.of(context).colorScheme.secondary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 20),
              Text(
                ' Ingredients:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
fontSize: 20
                    ),
              ),
              const SizedBox(height: 8),
              ...widget.ingredients.map((item) {
                final parts = item.split(' - ');
                final name = parts[0].trim();
                final quantity = parts.length > 1 ? parts[1].trim() : '';
                final imageUrl =
                    'https://www.themealdb.com/images/ingredients/$name-Small.png';

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          imageUrl,
                          height: 32,
                          width: 32,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              Icon(Icons.image_not_supported,
                                  size: 32, color: Colors.grey),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '$name${quantity.isNotEmpty ? ' - $quantity' : ''}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
              Text(
                ' Instructions:',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.description,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Container(color: Theme.of(context).colorScheme.surface,child: player,),
            ],
          ),
        ),
      );
    },
  );
}}