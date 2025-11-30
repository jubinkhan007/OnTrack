
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'db_constant.dart';

class LocalDBNew {
  static final LocalDBNew instance = LocalDBNew._internal();
  static Database? _db;

  LocalDBNew._internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await _initDB();
    return _db!;
  }

  Future<Database> _initDB() async {
    final defaultPath = await getDatabasesPath();
    final path = '$defaultPath/trackAll.db';
    return await openDatabase(
      path,
      version: 2, // Increment the version if needed
      onCreate: _createDB,
      onUpgrade: _onUpgrade,  // Handle schema migrations here
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // Create BU table
    await db.execute('''
      CREATE TABLE ${DBConstant.tableBU} (
        ${DBConstant.id} INTEGER PRIMARY KEY,
        ${DBConstant.buId} TEXT,
        ${DBConstant.buName} TEXT
      )
    ''');

    // Create Staff table with foreign key to BU
    await db.execute('''
      CREATE TABLE ${DBConstant.tableStaff} (
        ${DBConstant.compId} INTEGER,
        ${DBConstant.userId} INTEGER PRIMARY KEY,
        ${DBConstant.staffId} TEXT,
        ${DBConstant.userName} TEXT,
        ${DBConstant.searchName} TEXT,
        ${DBConstant.displayName} TEXT,
        ${DBConstant.buId} INTEGER,
        FOREIGN KEY(${DBConstant.buId}) REFERENCES ${DBConstant.tableBU}(${DBConstant.buId})
      )
    ''');
  }

  // Handle schema upgrades (e.g., adding new columns or tables)
  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      // Example of altering a table (e.g., adding a new column)
      await db.execute('ALTER TABLE ${DBConstant.tableStaff} ADD COLUMN newColumn TEXT');
    }
    // Handle further schema upgrades for future versions
  }

  // Close the database connection
  Future<void> close() async {
    final db = await instance.db;
    await db.close();
  }
}



class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  Database? _database;

  DatabaseHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  _initDB() async {
    var dbPath = await getDatabasesPath();
    String path = join(dbPath, 'business_unit.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  _onCreate(Database db, int version) async {
    // Create BU table with TEXT IDs
    await db.execute('''
      CREATE TABLE bu (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        bu_id TEXT,
        name TEXT
      )
    ''');

    // Create Staff table with TEXT IDs
    /*await db.execute('''
      CREATE TABLE staff (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        comp_id TEXT,
        user_id TEXT,
        user_hris TEXT,
        user_name TEXT,
        search_name TEXT,
        display_name TEXT,
        bu_id TEXT,
        FOREIGN KEY (bu_id) REFERENCES bu(id)
      )
    ''');*/
    await db.execute('''
      CREATE TABLE staff (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        comp_id TEXT,
        user_id TEXT,
        user_hris TEXT,
        user_name TEXT,
        search_name TEXT,
        display_name TEXT,
        bu_id TEXT
      )
    ''');
  }

  // Insert BU data
  Future<int> insertBU(Map<String, dynamic> buData) async {
    final db = await database;
    return await db.insert('bu', buData);
  }

  // Insert Staff data
  Future<int> insertStaff(Map<String, dynamic> staffData) async {
    final db = await database;
    return await db.insert('staff', staffData);
  }

  // Get all BU
  Future<List<Map<String, dynamic>>> getAllBU() async {
    final db = await database;
    return await db.query('bu');
  }

  // Get all Staffs by BU
  Future<List<Map<String, dynamic>>> getStaffsByBU(String buId) async {
    final db = await database;
    return await db.query('staff', where: 'bu_id = ?', whereArgs: [buId]);
  }



}

