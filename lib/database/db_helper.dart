import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_spot.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('kravr.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE food_spots (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT,
        cuisine TEXT,
        rating INTEGER,
        notes TEXT,
        isFavorite INTEGER
      )
    ''');
  }

  Future<int> insertFoodSpot(FoodSpot spot) async {
    final db = await instance.database;
    return await db.insert('food_spots', spot.toMap());
  }

  Future<List<FoodSpot>> getAllFoodSpots() async {
    final db = await instance.database;
    final result = await db.query('food_spots');

    return result.map((e) => FoodSpot.fromMap(e)).toList();
  }

  Future<int> updateFoodSpot(FoodSpot spot) async {
    final db = await instance.database;
    return await db.update(
      'food_spots',
      spot.toMap(),
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  Future<int> deleteFoodSpot(int id) async {
    final db = await instance.database;
    return await db.delete(
      'food_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}