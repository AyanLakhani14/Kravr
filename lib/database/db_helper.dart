import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/food_spot.dart';

class DBHelper {
  static final DBHelper instance = DBHelper._init();
  static Database? _database;

  DBHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('food.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 3, 
      onCreate: _createDB,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS food_spots');
        await db.execute('DROP TABLE IF EXISTS history');
        await _createDB(db, newVersion);
      },
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
CREATE TABLE food_spots(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  cuisine TEXT,
  rating INTEGER,
  notes TEXT,
  latitude REAL,
  longitude REAL,
  isFavorite INTEGER
)
''');

    await db.execute('''
CREATE TABLE history(
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT,
  timestamp TEXT
)
''');
  }

  // ✅ INSERT
  Future<int> insertFoodSpot(FoodSpot spot) async {
    final db = await database;
    return await db.insert('food_spots', spot.toMap());
  }

  // ✅ GET ALL
  Future<List<FoodSpot>> getAllFoodSpots() async {
    final db = await database;
    final result = await db.query('food_spots');

    return result.map((e) => FoodSpot.fromMap(e)).toList();
  }

  // ✅ UPDATE
  Future<int> updateFoodSpot(FoodSpot spot) async {
    final db = await database;

    return await db.update(
      'food_spots',
      spot.toMap(),
      where: 'id = ?',
      whereArgs: [spot.id],
    );
  }

  // ✅ DELETE
  Future<int> deleteFoodSpot(int id) async {
    final db = await database;

    return await db.delete(
      'food_spots',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ✅ HISTORY
  Future<void> insertHistory(String name) async {
    final db = await database;

    await db.insert('history', {
      'name': name,
      'timestamp': DateTime.now().toString(),
    });
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    final db = await database;
    return await db.query('history', orderBy: 'id DESC');
  }

  Future<void> clearHistory() async {
    final db = await database;
    await db.delete('history');
  }
}