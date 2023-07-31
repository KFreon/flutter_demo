import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class CoolDude {
  int id;
  String name;
  bool areTheyACoolDude;

  CoolDude(
      {required this.id, required this.name, required this.areTheyACoolDude});

  // While recommended, I'm not a fan.
  // Dynamic, no type safety, etc
  Map<String, dynamic> toMap() {
    final suchCool = areTheyACoolDude ? 1 : 0;
    return {'id': id, 'name': name, 'areTheyACoolDude': suchCool};
  }
}

// Muchly from: https://docs.flutter.dev/cookbook/persistence/sqlite
class DataService {
  late Future<Database> _database;

  static const String _coolDudesTableName = 'coolDudes';

  Future<void> initialiseDatabase() async {
    _database = openDatabase(join(await getDatabasesPath(), 'cool_dudes.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE $_coolDudesTableName(id INTEGER PRIMARY KEY, name TEXT, areTheyACoolDude BOOLEAN)');
    }, version: 1);
  }

  Future<void> addADude(CoolDude dude) async {
    var db = await _database;
    await db.insert(_coolDudesTableName, dude.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<CoolDude>> getCoolDudes() => _getSomeCoolDudes(true);
  Future<List<CoolDude>> getUncoolDudes() => _getSomeCoolDudes(false);

  Future<List<CoolDude>> _getSomeCoolDudes(bool doWeWantCool) async {
    final suchCool = doWeWantCool ? 1 : 0;
    List<Map<String, dynamic>> coolDudesMap = await (await _database).query(
        _coolDudesTableName,
        where: 'areTheyACoolDude = ?',
        whereArgs: [suchCool]);

    // Hmm this is the recommended approach, but I'm not a fan.
    // No type safety, etc
    return List.generate(coolDudesMap.length, (i) {
      final coolDudeNumber = coolDudesMap[i]['areTheyACoolDude'];
      return CoolDude(
          id: coolDudesMap[i]['id'],
          name: coolDudesMap[i]['name'],
          areTheyACoolDude: coolDudeNumber == 1 ? true : false);
    });
  }

  Future<void> updateADude(CoolDude dude) async {
    final db = await _database;
    await db.update(_coolDudesTableName, dude.toMap(),
        where: "id = ?", whereArgs: [dude.id]);
  }

  Future<void> deleteADude(CoolDude dude) async {
    final db = await _database;
    await db.delete(_coolDudesTableName, where: "id = ?", whereArgs: [dude.id]);
  }
}
