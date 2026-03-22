import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Map 🗺')),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(33.753746, -84.386330),
          zoom: 14,
        ),
        markers: {
          const Marker(
            markerId: MarkerId('gsu'),
            position: LatLng(33.753746, -84.386330),
            infoWindow: InfoWindow(title: 'Georgia State University'),
          ),
        },
      ),
    );
  }
}