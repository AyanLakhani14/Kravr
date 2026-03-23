import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../database/db_helper.dart';
import '../models/food_spot.dart';
import 'dart:math';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;

  List<FoodSpot> allSpots = [];
  List<FoodSpot> visibleSpots = [];

  double centerLat = 33.753746;
  double centerLng = -84.386330;

  // 🔥 CHANGED → now dynamic
  double radiusMeters = 1000;

  int? selectedIndex;

  @override
  void initState() {
    super.initState();
    loadSpots();
  }

  Future<void> loadSpots() async {
    final data = await DBHelper.instance.getAllFoodSpots();
    allSpots = data;
    filterSpots();
  }

  void filterSpots() {
    final filtered = allSpots.where((spot) {
      final distance = calculateDistance(
        centerLat,
        centerLng,
        spot.latitude,
        spot.longitude,
      );
      return distance <= radiusMeters;
    }).toList();

    setState(() {
      visibleSpots = filtered;
    });
  }

  double calculateDistance(
      double lat1, double lng1, double lat2, double lng2) {
    const R = 6371000;
    final dLat = (lat2 - lat1) * pi / 180;
    final dLng = (lng2 - lng1) * pi / 180;

    final a =
        sin(dLat / 2) * sin(dLat / 2) +
        cos(lat1 * pi / 180) *
            cos(lat2 * pi / 180) *
            sin(dLng / 2) *
            sin(dLng / 2);

    final c = 2 * atan2(sqrt(a), sqrt(1 - a));
    return R * c;
  }

  void onCameraMove(CameraPosition position) {
    centerLat = position.target.latitude;
    centerLng = position.target.longitude;
  }

  void onCameraIdle() {
    filterSpots();
  }

  void zoomToSpot(FoodSpot spot, int index) {
    mapController?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(spot.latitude, spot.longitude),
          zoom: 17,
        ),
      ),
    );

    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Explore Food 🗺')),

      body: Column(
        children: [
          // 🗺 MAP
          SizedBox(
            height: 300,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(centerLat, centerLng),
                zoom: 15,
              ),
              onMapCreated: (controller) {
                mapController = controller;
              },
              onCameraMove: onCameraMove,
              onCameraIdle: onCameraIdle,

              // 🔵 UPDATED CIRCLE (LIVE)
              circles: {
                Circle(
                  circleId: const CircleId('radius'),
                  center: LatLng(centerLat, centerLng),
                  radius: radiusMeters,
                  fillColor: Colors.orange.withOpacity(0.15),
                  strokeColor: Colors.orange,
                  strokeWidth: 2,
                ),
              },

              markers: visibleSpots.asMap().entries.map((entry) {
                final index = entry.key;
                final spot = entry.value;

                return Marker(
                  markerId: MarkerId(spot.id.toString()),
                  position: LatLng(spot.latitude, spot.longitude),

                  icon: selectedIndex == index
                      ? BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen,
                        )
                      : BitmapDescriptor.defaultMarker,

                  onTap: () {
                    setState(() {
                      selectedIndex = index;
                    });
                  },

                  infoWindow: InfoWindow(
                    title: spot.name,
                    snippet: spot.notes.isNotEmpty
                        ? "📝 ${spot.notes}"
                        : "No notes added",
                  ),
                );
              }).toSet(),
            ),
          ),

          // 🔥 NEW SLIDER SECTION
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.white,
            child: Column(
              children: [
                Text(
                  "Radius: ${radiusMeters.round()} meters",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),

                Slider(
                  value: radiusMeters,
                  min: 100,
                  max: 2000,
                  divisions: 19,
                  label: "${radiusMeters.round()}m",
                  onChanged: (value) {
                    setState(() {
                      radiusMeters = value;
                    });
                    filterSpots(); // 🔥 IMPORTANT
                  },
                ),

                Text(
                  "${visibleSpots.length} spots in range",
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),

          // 📋 LIST
          Expanded(
            child: visibleSpots.isEmpty
                ? const Center(child: Text("No spots in this area"))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: visibleSpots.length,
                    itemBuilder: (context, index) {
                      final spot = visibleSpots[index];
                      final isSelected = selectedIndex == index;

                      return GestureDetector(
                        onTap: () => zoomToSpot(spot, index),

                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),

                          decoration: BoxDecoration(
                            color: isSelected
                                ? Colors.orange.withOpacity(0.2)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 8,
                              )
                            ],
                          ),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.restaurant,
                                      color: Colors.orange),

                                  const SizedBox(width: 10),

                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          spot.name,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(spot.cuisine),
                                      ],
                                    ),
                                  ),

                                  Text("⭐ ${spot.rating}")
                                ],
                              ),

                              if (spot.notes.isNotEmpty) ...[
                                const SizedBox(height: 8),
                                Text(
                                  "📝 ${spot.notes}",
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                  ),
                                ),
                              ]
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}