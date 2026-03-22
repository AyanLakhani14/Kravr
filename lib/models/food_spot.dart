class FoodSpot {
  int? id;
  String name;
  String cuisine;
  int rating;
  String notes;
  bool isFavorite;

  FoodSpot({
    this.id,
    required this.name,
    required this.cuisine,
    required this.rating,
    required this.notes,
    this.isFavorite = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'cuisine': cuisine,
      'rating': rating,
      'notes': notes,
      'isFavorite': isFavorite ? 1 : 0,
    };
  }

  factory FoodSpot.fromMap(Map<String, dynamic> map) {
    return FoodSpot(
      id: map['id'],
      name: map['name'],
      cuisine: map['cuisine'],
      rating: map['rating'],
      notes: map['notes'],
      isFavorite: map['isFavorite'] == 1,
    );
  }
}