import 'package:flutter/material.dart';
import '../database/db_helper.dart';
import '../models/food_spot.dart';

class AddFoodScreen extends StatefulWidget {
  const AddFoodScreen({super.key});

  @override
  State<AddFoodScreen> createState() => _AddFoodScreenState();
}

class _AddFoodScreenState extends State<AddFoodScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController cuisineController = TextEditingController();
  final TextEditingController notesController = TextEditingController();

  int rating = 1;

  Future<void> saveFoodSpot() async {
    if (_formKey.currentState!.validate()) {
      final newSpot = FoodSpot(
        name: nameController.text,
        cuisine: cuisineController.text,
        rating: rating,
        notes: notesController.text,
      );

      await DBHelper.instance.insertFoodSpot(newSpot);

      Navigator.pop(context, true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Food Spot')),
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
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveFoodSpot,
                child: const Text('Save'),
              )
            ],
          ),
        ),
      ),
    );
  }
}