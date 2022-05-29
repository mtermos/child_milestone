import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

final childsTABLE = 'Childs';

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
        version: 2, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $childsTABLE ("
        "id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, "
        "name TEXT, "
        "gender TEXT, "
        "child_id TEXT, "
        "image_path TEXT, "
        "date_of_birth INTEGER, "
        "pregnancy_duration REAL "
        ")");
  }
}
