import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../database/db_helper.dart';
import '../models/food_spot.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final nameController = TextEditingController();
  final cuisineController = TextEditingController();
  final notesController = TextEditingController();
  final addressController = TextEditingController();

  int rating = 3;

  double? latitude;
  double? longitude;

  LatLng mapCenter = const LatLng(33.752, -84.386);
  GoogleMapController? mapController;

  double radius = 300;

  // ✅ Favorite toggle
  bool isFavorite = false;

  // 🔍 Convert address → coordinates (FIXED)
  Future<void> convertAddress() async {
    try {
      List<Location> locations =
          await locationFromAddress(addressController.text);

      if (!mounted) return; // ✅ FIX

      if (locations.isNotEmpty) {
        final lat = locations.first.latitude;
        final lng = locations.first.longitude;

        setState(() {
          latitude = lat;
          longitude = lng;
          mapCenter = LatLng(lat, lng);
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: mapCenter,
              zoom: 17,
            ),
          ),
        );

        print("📍 Location found: $lat, $lng");
      }
    } catch (e) {
      print("❌ Geocoding error: $e");
    }
  }

  // 💾 SAVE
  Future<void> saveFood() async {
    if (nameController.text.isEmpty) return;
    if (cuisineController.text.isEmpty) return;
    if (latitude == null || longitude == null) return;

    try {
      final newSpot = FoodSpot(
        name: nameController.text,
        cuisine: cuisineController.text,
        rating: rating,
        notes: notesController.text,
        latitude: latitude!,
        longitude: longitude!,
        isFavorite: isFavorite, // ✅ FIXED
      );

      await DBHelper.instance.insertFoodSpot(newSpot);

      Navigator.pop(context, true);
    } catch (e) {
      print("❌ SAVE ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Add Food 🍔")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),

            TextField(
              controller: cuisineController,
              decoration: const InputDecoration(labelText: "Cuisine"),
            ),

            TextField(
              controller: addressController,
              decoration: const InputDecoration(labelText: "Address"),
              onSubmitted: (_) => convertAddress(),
            ),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: convertAddress,
              child: const Text("Find Location"),
            ),

            const SizedBox(height: 10),

            // 🗺 MAP
            SizedBox(
              height: 220,
              child: GoogleMap(
                onMapCreated: (controller) {
                  mapController = controller;
                },
                initialCameraPosition: CameraPosition(
                  target: mapCenter,
                  zoom: 14,
                ),
                markers: latitude != null
                    ? {
                        Marker(
                          markerId: const MarkerId("selected"),
                          position: mapCenter,
                        )
                      }
                    : {},
                circles: latitude != null
                    ? {
                        Circle(
                          circleId: const CircleId("radius"),
                          center: mapCenter,
                          radius: radius,
                          fillColor: Colors.blue.withOpacity(0.2),
                          strokeColor: Colors.blue,
                          strokeWidth: 2,
                        )
                      }
                    : {},
              ),
            ),

            const SizedBox(height: 10),

            Slider(
              value: radius,
              min: 100,
              max: 1000,
              divisions: 9,
              label: "${radius.round()}m",
              onChanged: (value) {
                setState(() {
                  radius = value;
                });
              },
            ),

            const SizedBox(height: 20),

            TextField(
              controller: notesController,
              decoration: const InputDecoration(labelText: "Notes"),
            ),

            const SizedBox(height: 20),

            Row(
              children: [
                const Text("Rating: "),
                DropdownButton<int>(
                  value: rating,
                  items: List.generate(
                    5,
                    (index) => DropdownMenuItem(
                      value: index + 1,
                      child: Text("${index + 1} ⭐"),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      rating = value!;
                    });
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // ❤️ FAVORITE TOGGLE
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Favorite"),
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
              onPressed: saveFood,
              child: const Text("Save"),
            ),
          ],
        ),
      ),
    );
  }
}