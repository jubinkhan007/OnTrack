import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class DBHelper {
  static Database? _database;

  // Singleton pattern to ensure only one instance of DBHelper
  static final DBHelper instance = DBHelper._();

  DBHelper._();

  // Create or open the database
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  // Initialize the database
  Future<Database> _initDatabase() async {
    // Get the path to the app's document directory
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'staff_database.db');

    // Open the database and create the table if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  // SQL command to create the staff table
  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE staff (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        compId TEXT,
        userId TEXT,
        userHris TEXT,
        userName TEXT,
        searchName TEXT,
        displayName TEXT
      )
    ''');
  }

  // Batch insert staff data into the database
  Future<void> insertStaffList(List<Map<String, dynamic>> staffList) async {
    Database db = await database;
    Batch batch = db.batch();

    // Add each staff record to the batch
    for (var staff in staffList) {
      batch.insert('staff', staff, conflictAlgorithm: ConflictAlgorithm.replace);
    }

    // Execute the batch
    await batch.commit(noResult: true);
  }

  // Retrieve all staff from the database
  Future<List<Map<String, dynamic>>> getAllStaff() async {
    Database db = await database;
    return await db.query('staff');
  }

  // Delete all staff data from the database (optional)
  Future<int> deleteAllStaff() async {
    Database db = await database;
    return await db.delete('staff');
  }
}
