import 'dart:convert';

import 'package:moemen/domain/models/quran/khetma_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  static Database? _database;

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final path = join(await getDatabasesPath(), 'khetma_database.db');
    return openDatabase(
      path,
      onCreate: (db, version) {
        return db.execute('''
        CREATE TABLE khetmas(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          start_date TEXT,
          duration_days INTEGER,
          portion_type INTEGER,
          daily_amount INTEGER,
          start_value INTEGER,
          days TEXT, 
          current_day_index INTEGER
        )
      ''');
      },
      version: 3,
    );
  }



  Future<int> insertKhetma(Khetma khetma) async {
    final db = await database;
    final map = khetma.toMap();
    // Convert days to JSON string
    map['days'] = jsonEncode(khetma.days.map((d) => d.toMap()).toList());
    return await db.insert('khetmas', map);
  }

  Future<List<Khetma>> getAllKhetmas() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('khetmas');

    return maps.map((map) {
      // Create a new Map instead of modifying the original one
      final newMap = Map<String, dynamic>.from(map);

      // Convert JSON string back to list
      final daysJson = jsonDecode(newMap['days']) as List;
      newMap['days'] = daysJson;

      return Khetma.fromMap(newMap);
    }).toList();
  }

  Future<int> updateKhetma(Khetma khetma) async {
    final db = await database;
    final map = khetma.toMap();
    // Convert days to JSON string
    map['days'] = jsonEncode(khetma.days.map((d) => d.toMap()).toList());
    return await db.update(
      'khetmas',
      map,
      where: 'id = ?',
      whereArgs: [khetma.id],
    );
  }

  Future<int> deleteKhetma(int id) async {
    final db = await database;
    return await db.delete(
      'khetmas',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}