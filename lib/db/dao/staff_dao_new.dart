/*
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmbi/db/local_db.dart';
import 'package:tmbi/db/progress_notifier.dart';

import '../db_constant.dart';

class StaffDaoNew {
  final LocalDB _localDB = LocalDB.instance;
  final Dio dio;

  StaffDaoNew({required this.dio});

  Future<void> insertBuWithStaffs(BU bu, ProgressNotifier pn) async {
    Database db = await _localDB.db;
    await db.transaction((txn) async {
      int buId = await txn.insert(
        DBConstant.tableBU,
        {
          DBConstant.buId: bu.id,
          DBConstant.buName: bu.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // insert each staff
      int processedItems = 0;
      pn.start(bu.staffs.length); // start progress tracking

      for (var staff in bu.staffs) {
        await txn.insert(
            DBConstant.tableStaff, staff.toMap()..[DBConstant.buId] = buId,
            conflictAlgorithm: ConflictAlgorithm.replace);

        processedItems++;
        pn.updateProgress(processedItems); // update progress after each insert
      }
    });
    pn.complete(); // complete
  }

  // Check if the staff table is empty
  Future<bool> isStaffTableEmpty() async {
    Database db = await _localDB.db;
    var result =
        await db.rawQuery("SELECT COUNT(*) FROM ${DBConstant.tableStaff}");
    int count = Sqflite.firstIntValue(result)!;
    return count == 0;
  }

  Future<void> getBUFromApiAndSaveToDb(
      String staffId, ProgressNotifier pn) async {
    try {
      final headers = {
        "vm": "BUALL",
        "va": "0",
        "vb": staffId,
        "vc": "0",
        "vd": "BU"
      };

      final response = await dio.get(
        "getall",
        options: Options(headers: headers),
      );
      debugPrint("RESPONSE#${response.data}");

      // Log Response details
      //debugPrint("Response Status: ${response.statusCode}");
      //debugPrint("Response Data: ${response.data}");
      //debugPrint("Response Headers: ${response.headers}");

      if (response.statusCode == 200 */
/*&& response.data['status'] == "200"*//*
) {
        var buData = response.data['BU'];
        BU bu = BU.fromJson(buData);
        //await insertBuWithStaffs(bu, pn);
        debugPrint("Data Fetched");
      } else {
        throw Exception("Failed to fetch BU data: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Dio Error: ${error.response?.data ?? 'No response data'}");
      debugPrint("Dio Error: ${error.message}");
      throw Exception("Error fetching BU data: ${error.message}");
    }
  }
}

class Staff {
  final int compId;
  final int userId;
  final String userHris;
  final String userName;
  final String searchName;
  final String displayName;

  Staff({
    required this.compId,
    required this.userId,
    required this.userHris,
    required this.userName,
    required this.searchName,
    required this.displayName,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      compId: json['COMP_ID'],
      userId: json['USER_ID'],
      userHris: json['USER_HRIS'],
      userName: json['USER_NAME'],
      searchName: json['SEARCH_NAME'],
      displayName: json['DISPLAY_NAME'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBConstant.compId: compId,
      DBConstant.userId: userId,
      DBConstant.userHris: userHris,
      DBConstant.userName: userName,
      DBConstant.searchName: searchName,
      DBConstant.displayName: displayName,
    };
  }

  // Convert Staff object to JSON
  Map<String, dynamic> toJson() {
    return {
      'COMP_ID': compId,
      'USER_ID': userId,
      'USER_HRIS': userHris,
      'USER_NAME': userName,
      'SEARCH_NAME': searchName,
      'DISPLAY_NAME': displayName,
    };
  }
}

class BU {
  final int id;
  final String name;
  final List<Staff> staffs;

  BU({
    required this.id,
    required this.name,
    required this.staffs,
  });

  factory BU.fromJson(Map<String, dynamic> json) {
    var staffList = (json['STAFFS'] as List)
        .map((staffJson) => Staff.fromJson(staffJson))
        .toList();
    return BU(
      id: json['ID'],
      name: json['NAME'],
      staffs: staffList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'NAME': name,
      'STAFFS': staffs.map((staff) => staff.toJson()).toList(),
    };
  }
}
*/
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:sqflite/sqflite.dart';
import 'package:tmbi/db/local_db.dart';
import 'package:tmbi/db/progress_notifier.dart';
import '../db_constant.dart';
import '../local_db_new.dart';

class StaffDaoNew {
  final LocalDBNew _localDB = LocalDBNew.instance;
  final Dio? dio;

  StaffDaoNew({required this.dio});


  /*Future<void> insertBuWithStaffs(BU bu, ProgressNotifier pn) async {
    Database db = await _localDB.db;

    // Start transaction for atomic operation
    await db.transaction((txn) async {
      // Insert BU data
      int buId = await txn.insert(
        DBConstant.tableBU,
        {
          DBConstant.buId: bu.id,
          DBConstant.buName: bu.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Track progress for staff insertion
      int processedItems = 0;
      pn.start(bu.staffs.length); // Start progress tracking

      // Batch size for each staff insert operation
      const int batchSize = 50;

      // Insert staff records in smaller batches to reduce locking
      for (int i = 0; i < bu.staffs.length; i += batchSize) {
        List<Map<String, dynamic>> staffBatch = [];

        // Prepare the current batch of staff records
        for (int j = i; j < i + batchSize && j < bu.staffs.length; j++) {
          Staff staff = bu.staffs[j];
          staffBatch.add(staff.toMap()..[DBConstant.buId] = buId);
        }

        // Start a new transaction for each batch to avoid database lock
        await db.transaction((txnBatch) async {
          // Insert each staff record inside the batch transaction
          for (var staffMap in staffBatch) {
            txnBatch.insert(
              DBConstant.tableStaff,
              staffMap,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
          }
        });

        // Update progress after each batch
        processedItems += staffBatch.length;
        pn.updateProgress(processedItems);
      }
    });

    pn.complete(); // Mark progress as complete
  }*/

  Future<void> insertBuWithStaffs(BU bu, ProgressNotifier pn) async {
    Database db = await _localDB.db;

    // Start a transaction for atomic operation
    await db.transaction((txn) async {
      // Insert BU data
      int buId = await txn.insert(
        DBConstant.tableBU,
        {
          DBConstant.buId: bu.id,
          DBConstant.buName: bu.name,
        },
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Track progress for staff insertion
      int processedItems = 0;
      pn.start(bu.staffs.length); // Start progress tracking

      // Batch size for each staff insert operation (reducing it to 20 or 10)
      const int batchSize = 20;

      // Insert staff records in smaller batches to reduce locking
      for (int i = 0; i < bu.staffs.length; i += batchSize) {
        List<Map<String, dynamic>> staffBatch = [];

        // Prepare the current batch of staff records
        for (int j = i; j < i + batchSize && j < bu.staffs.length; j++) {
          Staff staff = bu.staffs[j];
          staffBatch.add(staff.toMap()..[DBConstant.buId] = buId);
        }

        // Insert the current batch within the transaction
        for (var staffMap in staffBatch) {
          await txn.insert(
            DBConstant.tableStaff,
            staffMap,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        }

        // Update progress after each batch
        processedItems += staffBatch.length;
        pn.updateProgress(processedItems);
      }
    });

    pn.complete(); // Mark progress as complete
  }


  // Check if the staff table is empty
  Future<bool> isStaffTableEmpty() async {
    Database db = await _localDB.db;
    var result =
    await db.rawQuery("SELECT COUNT(*) FROM ${DBConstant.tableStaff}");
    int count = Sqflite.firstIntValue(result)!;
    return count == 0;
  }

  Future<void> getBUFromApiAndSaveToDb2(String staffId, ProgressNotifier pn) async {
    try {
      final headers = {
        "vm": "BUALL",
        "va": "0",  // Example va value
        "vb": staffId,  // Staff ID to be passed
        "vc": "0",  // Example vc value
        "vd": "BU"  // Example vd value
      };

      final dio = Dio();  // Create your Dio instance
      final response = await dio.get(
        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/getall",  // Replace with your actual endpoint
        options: Options(headers: headers),
      );

      debugPrint("RESPONSE#${response.data}");

      // Check if the response is successful
      if (response.statusCode == 200) {
        var buData = response.data['BU'];  // This should be a list of BU objects

        if (buData is List) {
          // The 'BU' data comes from the API, so you can parse it to a List of Maps
          List<Map<String, dynamic>> parsedData = [];

          // Loop through BU and convert it into a Map format that can be passed to saveDataToDB
          for (var buJson in buData) {
            Map<String, dynamic> buMap = {
              'ID': buJson['ID'].toString(),
              'NAME': buJson['NAME'].toString(),
              'STAFFS': buJson['STAFFS']  // Keeping STAFFS as it is to insert later
            };

            parsedData.add(buMap);
          }

          // Now that we have the parsed data, call saveDataToDB
          await saveDataToDB(parsedData);

          print('Data saved to DB successfully!');
        } else {
          debugPrint("Invalid format: 'BU' is not a list");
        }
      } else {
        debugPrint("Failed to fetch BU data: ${response.data['message']}");
        throw Exception("Failed to fetch BU data: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Dio Error: ${error.response?.data ?? 'No response data'}");
      debugPrint("Dio Error: ${error.message}");
      throw Exception("Error fetching BU data: ${error.message}");
    }
  }

  Future<void> getBUFromApiAndSaveToDb(String staffId, ProgressNotifier pn) async {
    try {
      final headers = {
        "vm": "BUALL",
        "va": "0",  // Example va value
        "vb": staffId,  // Staff ID to be passed
        "vc": "0",  // Example vc value
        "vd": "BU"  // Example vd value
      };

      final dio = Dio();  // Create your Dio instance
      final response = await dio.get(
        "https://ego.rflgroupbd.com:8077/ords/rpro/kickall/getall",  // Replace with your actual endpoint
        options: Options(headers: headers),
      );

      debugPrint("RESPONSE#${response.data}");

      // Check if the response is successful
      if (response.statusCode == 200) {
        var buData = response.data['BU'];  // This should be a list of BU objects

        if (buData is List) {
          // Prepare a new map to pass to saveStaffDataToDB
          Map<String, dynamic> staffDataMap = {
            'BU': []  // Initialize an empty list to hold BU data
          };

          // Loop through BU data and prepare the staff data
          for (var buJson in buData) {
            // Check if STAFFS is available and is a list
            if (buJson['STAFFS'] is List) {
              // Extract the staff data for each BU
              for (var staffJson in buJson['STAFFS']) {
                // Create a map for each staff member
                Map<String, dynamic> staffData = {
                  'COMP_ID': staffJson['COMP_ID'],
                  'USER_ID': staffJson['USER_ID'],
                  'USER_HRIS': staffJson['USER_HRIS'],
                  'USER_NAME': staffJson['USER_NAME'],
                  'SEARCH_NAME': staffJson['SEARCH_NAME'],
                  'DISPLAY_NAME': staffJson['DISPLAY_NAME'],
                };

                // Add staff data to the BU list
                staffDataMap['BU'].add(staffData);
              }
            }
          }

          // Now, call saveStaffDataToDB with the staffDataMap
          await saveStaffDataToDB(staffDataMap);

          debugPrint('Staff data saved to DB successfully!');
        } else {
          debugPrint("Invalid format: 'BU' is not a list");
        }
      } else {
        debugPrint("Failed to fetch BU data: ${response.data['message']}");
        throw Exception("Failed to fetch BU data: ${response.data['message']}");
      }
    } on DioException catch (error) {
      debugPrint("Dio Error: ${error.response?.data ?? 'No response data'}");
      debugPrint("Dio Error: ${error.message}");
      throw Exception("Error fetching BU data: ${error.message}");
    }
  }

  // TEST
  Future<void> saveDataToDB(List<Map<String, dynamic>> jsonData) async {
    final dbHelper = DatabaseHelper();

    // Batch insert for BU and Staff data
    Batch batch = await dbHelper.database.then((db) => db.batch());

    // Loop through BU and insert them first
    for (var bu in jsonData) {
      // Check if the BU already exists
      var existingBu = await dbHelper.database.then((db) => db.query(
        'bu',
        where: 'id = ?',
        whereArgs: [bu['ID']],
      ));

      if (existingBu.isEmpty) {
        // If the BU does not exist, insert it
        Map<String, dynamic> buData = {
          'bu_id': bu['ID'],  // ID as string
          'name': bu['NAME'],
        };

        // Add insert statement for BU in the batch
        batch.insert('bu', buData);
      } else {
        // If the BU exists, you can choose to skip or update the existing record
        print('BU with ID ${bu['ID']} already exists, skipping insert.');
      }
    }

    // Loop through BU to insert associated STAFF data
    for (var bu in jsonData) {
      for (var staff in bu['STAFFS']) {
        Map<String, dynamic> staffData = {
          'comp_id': staff['COMP_ID'],   // COMP_ID as string
          'user_id': staff['USER_ID'],   // USER_ID as string
          'user_hris': staff['USER_HRIS'],
          'user_name': staff['USER_NAME'],
          'search_name': staff['SEARCH_NAME'],
          'display_name': staff['DISPLAY_NAME'],
          'bu_id': bu['ID'],  // Link staff to the BU via BU ID
        };

        // Add insert statement for staff in the batch
        batch.insert('staff', staffData);
      }
    }

    // Commit the batch insert
    await batch.commit(noResult: true);

    print('Data saved successfully!');
  }

  Future<void> saveStaffDataToDB(Map<String, dynamic> jsonData) async {
    final dbHelper = DatabaseHelper();

    // Make sure 'BU' is a list
    if (jsonData['BU'] is List) {
      List<dynamic> buList = jsonData['BU']; // This will now be the list of BUs

      // Batch insert for staff data
      Batch batch = await dbHelper.database.then((db) => db.batch());

      // Loop through the BU list to save staff information
      for (var bu in buList) {
        if (bu is Map<String, dynamic>) {
          // Extract staff data
          Map<String, dynamic> staffData = {
            'comp_id': bu['COMP_ID'],  // COMP_ID of the staff member (related to BU)
            'user_id': bu['USER_ID'],  // USER_ID as string
            'user_hris': bu['USER_HRIS'],
            'user_name': bu['USER_NAME'],
            'search_name': bu['SEARCH_NAME'],
            'display_name': bu['DISPLAY_NAME'],
          };

          // Add insert statement for staff data in the batch
          batch.insert('staff', staffData);
        } else {
          print('Invalid BU data format, skipping...');
        }
      }

      // Commit the batch insert
      await batch.commit(noResult: true);

      print('Staff data saved successfully!');
    } else {
      print('Invalid format for BU data. Expected a list.');
    }
  }

  Future<List<Staff>> getAllStaff() async {
    final dbHelper = DatabaseHelper();

    try {
      final db = await dbHelper.database;

      // Query to fetch all staff data from the database
      List<Map<String, dynamic>> staffListMap = await db.query('staff');

      debugPrint("Fetched raw data: $staffListMap");

      // Convert each map into a Staff object
      List<Staff> staffList = staffListMap.map((staffMap) => Staff.fromJson(staffMap)).toList();

      debugPrint("Fetched ${staffList.length} staff records.");
      return staffList;
    } catch (e) {
      debugPrint('Error fetching staff data: $e');
      return [];
    }
  }

}

class Staff {
  final String compId; // Company ID as String
  final String userId; // User ID as String
  final String userHris; // HRIS (Human Resource Information System) ID as String
  final String userName; // Name of the user as String
  final String searchName; // Search name as String
  final String displayName; // Display name as String

  Staff({
    required this.compId,
    required this.userId,
    required this.userHris,
    required this.userName,
    required this.searchName,
    required this.displayName,
  });

  factory Staff.fromJson(Map<String, dynamic> json) {
    return Staff(
      compId: json['COMP_ID'].toString(),  // Convert to String
      userId: json['USER_ID'].toString(),  // Convert to String
      userHris: json['USER_HRIS'].toString(), // Convert to String
      userName: json['USER_NAME'].toString(), // Convert to String
      searchName: json['SEARCH_NAME'].toString(), // Convert to String
      displayName: json['DISPLAY_NAME'].toString(), // Convert to String
    );
  }

  Map<String, dynamic> toMap() {
    return {
      DBConstant.compId: compId,
      DBConstant.userId: userId,
      DBConstant.userHris: userHris,
      DBConstant.userName: userName,
      DBConstant.searchName: searchName,
      DBConstant.displayName: displayName,
    };
  }

  // Convert Staff object to JSON
  Map<String, dynamic> toJson() {
    return {
      'COMP_ID': compId,
      'USER_ID': userId,
      'USER_HRIS': userHris,
      'USER_NAME': userName,
      'SEARCH_NAME': searchName,
      'DISPLAY_NAME': displayName,
    };
  }
}

class BU {
  final String id; // ID as String
  final String name; // Name as String
  final List<Staff> staffs;

  BU({
    required this.id,
    required this.name,
    required this.staffs,
  });

  factory BU.fromJson(Map<String, dynamic> json) {
    var staffList = (json['STAFFS'] as List)
        .map((staffJson) => Staff.fromJson(staffJson))
        .toList();
    return BU(
      id: json['ID'].toString(), // Convert ID to String
      name: json['NAME'].toString(), // Convert Name to String
      staffs: staffList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ID': id,
      'NAME': name,
      'STAFFS': staffs.map((staff) => staff.toJson()).toList(),
    };
  }
}


