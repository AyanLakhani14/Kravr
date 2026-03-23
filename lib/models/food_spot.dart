class FoodSpot {
  final int? id;
  final String name;
  final String cuisine;
  final int rating;
  final String notes;
  final double latitude;
  final double longitude;
  final bool isFavorite; // ✅ ADD THIS

  FoodSpot({
    this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.notes,
    required this.latitude,
    required this.longitude,
    this.isFavorite = false, // ✅ DEFAULT
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'rating': rating,
      'notes': notes,
      'latitude': latitude,
      'longitude': longitude,
      'isFavorite': isFavorite ? 1 : 0, // ✅ STORE AS INT
    };
  }

  factory FoodSpot.fromMap(Map<String, dynamic> map) {
    return FoodSpot(
      id: map['id'],
      name: map['name'],
      cuisine: map['cuisine'],
      rating: map['rating'],
      notes: map['notes'],
      latitude: map['latitude'],
      longitude: map['longitude'],
      isFavorite: map['isFavorite'] == 1, // ✅ READ INT
    );
  }
}