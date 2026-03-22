import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/food_spot.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  List<FoodSpot> favorites = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    final allSpots = await DBHelper.instance.getAllFoodSpots();
    setState(() {
      favorites = allSpots.where((spot) => spot.isFavorite).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: favorites.isEmpty
          ? const Center(child: Text('No favorites yet'))
          : ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final spot = favorites[index];
                return ListTile(
                  title: Text(spot.name),
                  subtitle: Text(spot.cuisine),
                );
              },
            ),
    );
  }
}