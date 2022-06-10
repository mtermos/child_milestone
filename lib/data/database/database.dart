import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

const childrenTABLE = 'Children';
const notificationsTABLE = 'Notifications';
const milestonesTABLE = 'Milestones';
const tipsTABLE = 'Tips';

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

  void deleteDatabase() async {
    String path = join(await getDatabasesPath(), 'child_vaccine_tracker.db');
    databaseFactory.deleteDatabase(path);
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $childrenTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "name TEXT, "
        "gender TEXT, "
        "child_id TEXT UNIQUE, "
        "image_path TEXT, "
        "date_of_birth INTEGER, "
        "pregnancy_duration REAL "
        ")");

    await database.execute("CREATE TABLE $notificationsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "opened INTEGER, "
        "issued_time INTEGER "
        ")");

    await database.execute("CREATE TABLE $milestonesTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "description TEXT, "
        "imagePath TEXT, "
        "videoPath TEXT, "
        "startingWeek INTEGER, "
        "endingWeek INTEGER, "
        "category INTEGER "
        ")");

    await database.execute("CREATE TABLE $tipsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "title TEXT, "
        "body TEXT, "
        "starting_week INTEGER, "
        "ending_week INTEGER "
        ")");
  }
}
