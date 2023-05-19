import 'dart:async';

import 'package:child_milestone/data/database/database.dart';
import 'package:child_milestone/data/models/vaccine.dart';
import 'package:sqflite/sql.dart';

class VaccineDao {
  final dbProvider = DatabaseProvider.dbProvider;

  //Adds new Vaccine record
  Future<int> createVaccine(Vaccine vaccine) async {
    final db = await dbProvider.database;
    var result = db.insert(vaccinesTABLE, vaccine.toMap(),
        conflictAlgorithm: ConflictAlgorithm.ignore);
    return result;
  }

  Future<List<Map<String, dynamic>>> getAllVaccines() async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db.query(vaccinesTABLE);
    return result;
  }

  Future<Map<String, dynamic>?> getVaccineByID(int vaccineId) async {
    final db = await dbProvider.database;

    List<Map<String, dynamic>> result = [];
    result =
        await db.query(vaccinesTABLE, where: 'id = ?', whereArgs: [vaccineId]);

    if (result.isNotEmpty) return result[0];
  }

  Future<List<Map<String, dynamic>>?> getVaccinesByAge(int period) async {
    final db = await dbProvider.database;

    return db.query(vaccinesTABLE, where: 'period = ?', whereArgs: [period]);
  }

  //Update Vaccine record
  Future<int> updateVaccine(Vaccine vaccine) async {
    final db = await dbProvider.database;

    var result = await db.update(vaccinesTABLE, vaccine.toMap(),
        where: "id = ?", whereArgs: [vaccine.id]);

    return result;
  }

  //Delete Vaccine records
  Future<int> deleteVaccine(int id) async {
    final db = await dbProvider.database;
    var result =
        await db.delete(vaccinesTABLE, where: 'id = ?', whereArgs: [id]);

    return result;
  }

  //We are not going to use this in the demo
  Future deleteAllVaccines() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      vaccinesTABLE,
    );

    return result;
  }

  Future<List<Map<String, dynamic>>> getVaccinesUntilPeriod(int period) async {
    final db = await dbProvider.database;
    List<Map<String, dynamic>> result = await db
        .query(vaccinesTABLE, where: 'period < ?', whereArgs: [period + 1]);
    return result;
  }
}
