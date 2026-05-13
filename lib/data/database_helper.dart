import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/meal.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('recipes.db');
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
      CREATE TABLE favorites (
        idMeal TEXT PRIMARY KEY,
        strMeal TEXT,
        strCategory TEXT,
        strArea TEXT,
        strInstructions TEXT,
        strMealThumb TEXT,
        strTags TEXT,
        strYoutube TEXT,
        ingredients TEXT,
        measures TEXT
      )
    ''');
  }

  Future<void> toggleFavorite(Meal meal) async {
    final db = await instance.database;
    final isFav = await isFavorite(meal.idMeal);
    if (isFav) {
      await db.delete('favorites', where: 'idMeal = ?', whereArgs: [meal.idMeal]);
    } else {
      await db.insert('favorites', meal.toMap(), conflictAlgorithm: ConflictAlgorithm.replace);
    }
  }

  Future<bool> isFavorite(String id) async {
    final db = await instance.database;
    final maps = await db.query(
      'favorites',
      columns: ['idMeal'],
      where: 'idMeal = ?',
      whereArgs: [id],
    );
    return maps.isNotEmpty;
  }

  Future<List<Meal>> getFavorites() async {
    final db = await instance.database;
    final result = await db.query('favorites');
    return result.map((json) => Meal.fromMap(json)).toList();
  }
}
