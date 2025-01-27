import 'package:sqflite/sqflite.dart';

import 'db_constant.dart';

class LocalDB {
  static final LocalDB instance = LocalDB._internal();
  static Database? _db;

  LocalDB._internal();

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
      version: 1,
      onCreate: _createDB,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    // staff
    await db.execute('''
      CREATE TABLE ${DBConstant.tableStaff} (
        ${DBConstant.userId} ${DBConstant.textType}, 
        ${DBConstant.staffId} ${DBConstant.textType}, 
        ${DBConstant.userName} ${DBConstant.textType},
        ${DBConstant.designation} ${DBConstant.textTypeWithNull}
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.db;
    await db.close();
  }
}
