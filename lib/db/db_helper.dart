import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import '../models/task.dart';

class DbHelper {
  static Database? _db;
  static const int _version = 1;
  static const String _tableName = 'tasks';

  static Future<void> initDb() async {
    if (_db != null) {
      debugPrint('not null db');
      return;
    }
    try {
      String path = await getDatabasesPath() + 'tasks.db';
      _db = await openDatabase(
        path,
        version: _version,
        onCreate: (Database db, int version) async {
          debugPrint('creating new database');
          await db.execute(
            'CREATE TABLE $_tableName('
            'id INTEGER PRIMARY KEY AUTOINCREMENT, '
            'title TEXT, note TEXT, date TEXT, '
            'startTime TEXT, endTime TEXT, '
            'remind INTEGER, repeat TEXT, '
            'color INTEGER, isCompleted INTEGER)',
          );
        },
      );
      debugPrint('database created');
    } catch (e) {
      print(e);
    }
  }

  static Future<int> insert(Task task) async {
    debugPrint('inserting to database');
    return await _db!.insert(_tableName, task.toJson());
  }

  static Future<int> delete(int id) async {
    debugPrint('deleting a task from database');
    return await _db!.delete(_tableName, where: 'id = ?', whereArgs: [id]);
  }

  static Future<int> deleteAll() async {
    debugPrint('deleting all from database');
    return await _db!.delete(_tableName);
  }

  static Future<int> update(int id) async {
    debugPrint('updating database');
    return await _db!.rawUpdate('''
    UPDATE $_tableName
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    debugPrint('querying from database');
    return await _db!.query(_tableName);
  }
}
