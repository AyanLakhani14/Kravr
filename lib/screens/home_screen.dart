import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/food_spot.dart';
import 'add_food_screen.dart';
import 'detail_screen.dart';
import 'favorites_screen.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FoodSpot> spots = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DBHelper.instance.getAllFoodSpots();
    setState(() {
      spots = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Kravr'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SettingsScreen(),
                ),
              );
            },
          ),
        ],
      ),

      body: spots.isEmpty
          ? const Center(child: Text('No food spots yet'))
          : ListView.builder(
              itemCount: spots.length,
              itemBuilder: (context, index) {
                final spot = spots[index];
                return ListTile(
                  title: Text(spot.name),
                  subtitle: Text(spot.cuisine),
                  onTap: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            DetailScreen(spot: spot),
                      ),
                    );

                    if (result == true) {
                      loadData();
                    }
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddFoodScreen(),
            ),
          );

          if (result == true) {
            loadData();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}