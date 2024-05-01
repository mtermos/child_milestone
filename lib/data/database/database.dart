import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const childrenTABLE = 'Children';
const notificationsTABLE = 'Notifications';
const milestonesTABLE = 'Milestones';
const vaccinesTABLE = 'vaccines';
const tipsTABLE = 'Tips';
const decisionsTABLE = 'Decisions';
const ratingsTABLE = 'Ratings';
const logsTABLE = 'Logs';

class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    String path = join(await getDatabasesPath(), 'child_vaccine_tracker.db');
    WidgetsFlutterBinding.ensureInitialized();

    var database = await openDatabase(path,
        version: 12, onCreate: initDB, onUpgrade: onUpgrade);
    // print("printing tables");

    _updateTableTipsV3toV4(database);
    _addLogsTable(database);
    _addMultipleRatingsToRatings(database);
    _addAdditionalTextToRatings(database);

    // var columns = await database.rawQuery('PRAGMA table_info($ratingsTABLE);');
    // for (var element in columns) {
    //   print('COLUMNS: ${element["name"]}');
    // }
    // (await database.query('sqlite_master', columns: ['type', 'name']))
    //     .forEach((row) {
    //   print(row.values);
    // });
    var tables = await database
        .rawQuery('SELECT * FROM sqlite_master WHERE name="$logsTABLE";');
    // print('VERSION: ${await database.getVersion()}');
    if (tables.isEmpty) {
      _addLogsTable(database);
    }
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    // print('OLDVERSION: ${oldVersion}');
    if (_database != null) {
      // _updateTableTipsV3toV4(database);
      // _addLogsTable(database);
      // _addMultipleRatingsToRatings(database);
      // _addAdditionalTextToRatings(database);
      if (oldVersion == 3) _updateTableTipsV3toV4(database);
      if (oldVersion < 9) _addLogsTable(database);
      if (oldVersion < 13) {
        _addMultipleRatingsToRatings(database);
        _addAdditionalTextToRatings(database);
      }
      // if (newVersion > oldVersion) {}
    }
  }

  deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'child_vaccine_tracker.db');
    databaseFactory.deleteDatabase(path);
  }

  clearDatabase(List<String> tables) async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    for (var table in tables) {
      await _database!.delete(table);
    }
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $childrenTABLE ("
        "id INTEGER PRIMARY KEY NOT NULL, "
        "name TEXT NOT NULL, "
        "gender TEXT NOT NULL, "
        "imagePath TEXT NOT NULL, "
        "dateOfBirth INTEGER NOT NULL, "
        "uploaded INTEGER, "
        "idBackend TEXT, "
        "pregnancyDuration INTEGER NOT NULL "
        ")");

    await database.execute("CREATE TABLE $milestonesTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "description TEXT, "
        "imagePath TEXT, "
        "videoPath TEXT, "
        "period INTEGER, "
        "startingAge INTEGER, "
        "endingAge INTEGER, "
        "category INTEGER "
        ")");

    await database.execute("CREATE TABLE $vaccinesTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "name TEXT, "
        "description TEXT, "
        "imagePath TEXT, "
        "videoPath TEXT, "
        "period INTEGER, "
        "startingAge INTEGER, "
        "endingAge INTEGER, "
        "category INTEGER "
        ")");

    await database.execute("CREATE TABLE $notificationsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "route TEXT, "
        "childId INTEGER, "
        "milestoneId INTEGER, "
        "vaccineId INTEGER, "
        "opened INTEGER, "
        "dismissed INTEGER, "
        "uploaded INTEGER, "
        "issuedAt INTEGER, "
        "period INTEGER, "
        "FOREIGN KEY (childId) REFERENCES $childrenTABLE (id), "
        "FOREIGN KEY (milestoneId) REFERENCES $milestonesTABLE (id), "
        "FOREIGN KEY (vaccineId) REFERENCES $vaccinesTABLE (id) "
        ")");

    await database.execute("CREATE TABLE $tipsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "videoURL TEXT, "
        "documentURL TEXT, "
        "webURL TEXT, "
        "period INTEGER "
        ")");

    await database.execute("CREATE TABLE $decisionsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "childId INTEGER, "
        "milestoneId INTEGER, "
        "vaccineId INTEGER, "
        "decision INTEGER, "
        "takenAt INTEGER, "
        "uploaded INTEGER, "
        "FOREIGN KEY (childId) REFERENCES $childrenTABLE (id), "
        "FOREIGN KEY (milestoneId) REFERENCES $milestonesTABLE (id), "
        "FOREIGN KEY (vaccineId) REFERENCES $vaccinesTABLE (id) "
        ")");

    await database.execute("CREATE TABLE $ratingsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "ratingId INTEGER, "
        "rating REAL, "
        "multipleRatings TEXT, "
        "additionalText TEXT, "
        "takenAt INTEGER, "
        "uploaded INTEGER "
        ")");

    await database.execute("CREATE TABLE $logsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "action TEXT, "
        "description TEXT, "
        "takenAt INTEGER, "
        "uploaded INTEGER "
        ")");
  }

  void _updateTableTipsV3toV4(Database database) async {
    try {
      await database.execute('ALTER TABLE $tipsTABLE ADD webURL TEXT');
    } catch (e) {
      // print('E_updateTableTipsV3toV4: ${e}');
    }
  }

  void _addLogsTable(Database database) async {
    try {
      await database.execute("CREATE TABLE $logsTABLE ("
          "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
          "action TEXT, "
          "description TEXT, "
          "takenAt INTEGER, "
          "uploaded INTEGER "
          ")");
    } catch (e) {
      // print('E_addLogsTable: ${e}');
    }
  }

  void _addMultipleRatingsToRatings(Database database) async {
    try {
      await database
          .execute('ALTER TABLE $ratingsTABLE ADD multipleRatings TEXT;');
    } catch (e) {
      // print('E_addMultipleRatingsToRatings: ${e}');
    }
  }

  void _addAdditionalTextToRatings(Database database) async {
    try {
      await database
          .execute('ALTER TABLE $ratingsTABLE ADD additionalText TEXT;');
    } catch (e) {
      // print('E_addAdditionalTextToRatings: ${e}');
    }
  }
}
