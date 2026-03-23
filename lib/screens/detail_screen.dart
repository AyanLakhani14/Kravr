import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

import '../models/food_spot.dart';
import '../database/db_helper.dart';

class DetailScreen extends StatefulWidget {
  final FoodSpot spot;

  const DetailScreen({super.key, required this.spot});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController cuisineController;
  late TextEditingController notesController;
  final addressController = TextEditingController();

  int rating = 1;
  bool isFavorite = false;

  double? latitude;
  double? longitude;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.spot.name);
    cuisineController = TextEditingController(text: widget.spot.cuisine);
    notesController = TextEditingController(text: widget.spot.notes);

    rating = widget.spot.rating;
    isFavorite = widget.spot.isFavorite;

    latitude = widget.spot.latitude;
    longitude = widget.spot.longitude;
  }

  // 🔥 FIXED GEOLOCATION
  Future<void> convertAddress() async {
    try {
      List<Location> locations =
          await locationFromAddress(addressController.text);

      if (!mounted) return; // ✅ FIX

      if (locations.isNotEmpty) {
        setState(() {
          latitude = locations.first.latitude;
          longitude = locations.first.longitude;
        });

        print("📍 Updated location: $latitude, $longitude");
      }
    } catch (e) {
      print("❌ Geocoding error: $e");
    }
  }

  Future<void> updateSpot() async {
    if (_formKey.currentState!.validate()) {
      final updatedSpot = FoodSpot(
        id: widget.spot.id,
        name: nameController.text,
        cuisine: cuisineController.text,
        rating: rating,
        notes: notesController.text,
        latitude: latitude!,
        longitude: longitude!,
        isFavorite: isFavorite,
      );

      await DBHelper.instance.updateFoodSpot(updatedSpot);
      Navigator.pop(context, true);
    }
  }

  Future<void> deleteSpot() async {
    await DBHelper.instance.deleteFoodSpot(widget.spot.id!);
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Food Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Enter name' : null,
                ),

                TextFormField(
                  controller: cuisineController,
                  decoration: const InputDecoration(labelText: 'Cuisine'),
                ),

                // ✅ ADDRESS INPUT
                TextField(
                  controller: addressController,
                  decoration: const InputDecoration(labelText: "Address"),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: convertAddress,
                  child: const Text("Update Location"),
                ),

                const SizedBox(height: 10),

                // ✅ SHOW UPDATED LOCATION
                Text(
                  latitude != null && longitude != null
                      ? "📍 $latitude, $longitude"
                      : "No location selected",
                ),

                const SizedBox(height: 10),

                TextFormField(
                  controller: notesController,
                  decoration: const InputDecoration(labelText: 'Notes'),
                ),

                const SizedBox(height: 10),

                DropdownButtonFormField<int>(
                  initialValue: rating,
                  decoration: const InputDecoration(labelText: 'Rating'),
                  items: [1, 2, 3, 4, 5]
                      .map((e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e Stars'),
                          ))
                      .toList(),
                  onChanged: (value) {
                    setState(() {
                      rating = value!;
                    });
                  },
                ),

                const SizedBox(height: 10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Favorite'),
                    Switch(
                      value: isFavorite,
                      onChanged: (value) {
                        setState(() {
                          isFavorite = value;
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: updateSpot,
                  child: const Text('Update'),
                ),

                const SizedBox(height: 10),

                ElevatedButton(
                  onPressed: deleteSpot,
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  child: const Text('Delete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}