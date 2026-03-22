import 'package:flutter/material.dart';
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
  int rating = 1;
  bool isFavorite = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.spot.name);
    cuisineController = TextEditingController(text: widget.spot.cuisine);
    notesController = TextEditingController(text: widget.spot.notes);
    rating = widget.spot.rating;
    isFavorite = widget.spot.isFavorite;
  }

  Future<void> updateSpot() async {
    if (_formKey.currentState!.validate()) {
      final updatedSpot = FoodSpot(
        id: widget.spot.id,
        name: nameController.text,
        cuisine: cuisineController.text,
        rating: rating,
        notes: notesController.text,
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
              TextFormField(
                controller: notesController,
                decoration: const InputDecoration(labelText: 'Notes'),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<int>(
                value: rating,
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
    );
  }
}