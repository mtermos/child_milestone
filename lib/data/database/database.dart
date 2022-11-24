import 'dart:async';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const childrenTABLE = 'Children';
const notificationsTABLE = 'Notifications';
const milestonesTABLE = 'Milestones';
const tipsTABLE = 'Tips';
const decisionsTABLE = 'Decisions';
const ratingsTABLE = 'Ratings';

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
        version: 3, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'child_vaccine_tracker.db');
    databaseFactory.deleteDatabase(path);
  }

  clearDatabase(List<String> tables) async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    for (var table in tables) {
      print(table);
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

    await database.execute("CREATE TABLE $notificationsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "route TEXT, "
        "childId INTEGER, "
        "milestoneId INTEGER, "
        "opened INTEGER, "
        "dismissed INTEGER, "
        "uploaded INTEGER, "
        "issuedAt INTEGER, "
        "period INTEGER, "
        "FOREIGN KEY (childId) REFERENCES $childrenTABLE (id), "
        "FOREIGN KEY (milestoneId) REFERENCES $milestonesTABLE (id) "
        ")");

    await database.execute("CREATE TABLE $tipsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "videoURL TEXT, "
        "documentURL TEXT, "
        "period INTEGER "
        ")");

    await database.execute("CREATE TABLE $decisionsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "childId INTEGER, "
        "milestoneId INTEGER, "
        "decision INTEGER, "
        "takenAt INTEGER, "
        "uploaded INTEGER, "
        "FOREIGN KEY (childId) REFERENCES $childrenTABLE (id), "
        "FOREIGN KEY (milestoneId) REFERENCES $milestonesTABLE (id) "
        ")");

    await database.execute("CREATE TABLE $ratingsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "ratingId INTEGER, "
        "rating REAL, "
        "takenAt INTEGER, "
        "uploaded INTEGER "
        ")");
  }
}
