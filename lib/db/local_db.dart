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
    // Debug aid: helps confirm the running build includes latest DB migration logic.
    // (Safe to keep; it's low-volume and only runs once per app start.)
    // ignore: avoid_print
    print('[DB] init trackAll.db version=4 (patched create-table safety)');
    return await openDatabase(
      path,
      version: 4,
      onCreate: _createDB,
      onUpgrade: _onUpgrade,
    );
  }

  Future<void> _createDB(Database db, int version) async {
    await _createStaffTable(db);
    await _createPendingTaskQueueTable(db);
    await _createPendingTaskUpdateQueueTable(db);
  }

  Future<void> _executeCreateTable(Database db, String sql) async {
    try {
      await db.execute(sql);
    } on DatabaseException catch (e) {
      // Some older app installs may hit onUpgrade paths where the table already
      // exists. Treat that as a no-op so startup doesn't crash.
      if (e.toString().contains("already exists")) return;
      rethrow;
    }
  }

  Future<void> _createStaffTable(Database db) async {
    await _executeCreateTable(db, '''
        CREATE TABLE IF NOT EXISTS ${DBConstant.tableStaff}(
          ID INTEGER PRIMARY KEY,
          ${DBConstant.userId} ${DBConstant.textTypeWithNull},
          ${DBConstant.compId} ${DBConstant.textTypeWithNull},
          ${DBConstant.compName} ${DBConstant.textTypeWithNull},
          ${DBConstant.userHris} ${DBConstant.textTypeWithNull},
          ${DBConstant.userName} ${DBConstant.textTypeWithNull},
          ${DBConstant.searchName} ${DBConstant.textTypeWithNull},
          ${DBConstant.displayName} ${DBConstant.textTypeWithNull}
        )
      ''');
  }

  Future<void> _createPendingTaskQueueTable(Database db) async {
    await _executeCreateTable(db, '''
      CREATE TABLE IF NOT EXISTS ${DBConstant.tablePendingTaskQueue}(
        ${DBConstant.queueId} ${DBConstant.idType},
        ${DBConstant.queueCompanyId} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueInquiryId} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueCustomerId} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueCustomerName} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueIsSample} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueTitle} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueDetails} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueDueDate} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueStartDate} ${DBConstant.textTypeWithNull},
        ${DBConstant.queuePriorityId} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueUserId} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueAssignees} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueCreatedAt} ${DBConstant.textTypeWithNull},
        ${DBConstant.queueRetryCount} INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 3) {
      await _createPendingTaskQueueTable(db);
    }
    if (oldVersion < 4) {
      await _createPendingTaskUpdateQueueTable(db);
    }
  }

  Future<void> _createPendingTaskUpdateQueueTable(Database db) async {
    await _executeCreateTable(db, '''
      CREATE TABLE IF NOT EXISTS ${DBConstant.tablePendingTaskUpdateQueue}(
        ${DBConstant.updateQueueId} ${DBConstant.idType},
        ${DBConstant.updateQueueInquiryId} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueueTaskId} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueuePriorityId} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueueDescription} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueueUserId} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueuePercentage} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueueCreatedAt} ${DBConstant.textTypeWithNull},
        ${DBConstant.updateQueueRetryCount} INTEGER DEFAULT 0
      )
    ''');
  }

  Future<void> close() async {
    final db = await instance.db;
    await db.close();
  }
}
