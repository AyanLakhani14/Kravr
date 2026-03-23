import 'package:flutter/material.dart';
import 'dart:math';

import '../database/db_helper.dart';
import '../models/food_spot.dart';
import 'add_food_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<FoodSpot> spots = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final data = await DBHelper.instance.getAllFoodSpots();

    setState(() {
      spots = data;
      isLoading = false;
    });
  }

  Widget buildStars(int rating) {
    return Row(
      children: List.generate(
        rating,
        (index) =>
            const Icon(Icons.star, size: 16, color: Colors.orange),
      ),
    );
  }

  void showNotes(FoodSpot spot) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(spot.name),
        content: Text(
          spot.notes.isNotEmpty
              ? "📝 ${spot.notes}"
              : "No notes added",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
        ],
      ),
    );
  }

  // 🎲 RANDOM FUNCTION
  void showRandomFood() {
    if (spots.isEmpty) return;

    final random = Random();
    final randomSpot = spots[random.nextInt(spots.length)];

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Try This! 🍽"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              randomSpot.name,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            Text(randomSpot.cuisine),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                randomSpot.rating,
                (index) => const Icon(
                  Icons.star,
                  color: Colors.orange,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await DBHelper.instance.insertHistory(randomSpot.name);

              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => DetailScreen(spot: randomSpot),
                ),
              );

              if (result == true) {
                await loadData();
              }
            },
            child: const Text("View"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kravr 🍔"),

        // ✅ SMALL BUTTON IN TOP BAR
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton(
              onPressed: showRandomFood,
              child: const Text(
                "Don't know?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ),
          ),
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : spots.isEmpty
              ? const Center(child: Text("No food spots yet 🍽"))
              : ListView.builder(
                  itemCount: spots.length,
                  itemBuilder: (context, index) {
                    final spot = spots[index];

                    return GestureDetector(
                      onTap: () async {
                        await DBHelper.instance.insertHistory(spot.name);

                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DetailScreen(spot: spot),
                          ),
                        );

                        if (result == true) {
                          await loadData();
                        }
                      },

                      onLongPress: () => showNotes(spot),

                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: const [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 6,
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.restaurant,
                                color: Colors.orange),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    spot.name,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  Text(
                                    spot.cuisine,
                                    style: const TextStyle(
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            buildStars(spot.rating),
                          ],
                        ),
                      ),
                    );
                  },
                ),

      // ✅ ADD BUTTON BACK TO NORMAL POSITION
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: const Icon(Icons.add),
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddFoodScreen(),
            ),
          );

          if (result == true) {
            await loadData();
          }
        },
      ),
    );
  }
}