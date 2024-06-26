import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/tasks.dart';

class TaskService {
  String tableName = 'tasks';
  Logger logger = Logger();
  Future<int> insertTask(Tasks tasks) async {
    Database database = await DatabaseHelper().database;
    return await database.insert(tableName, tasks.toMap());
  }

  Future<List<Tasks>> getAllTask() async {
    Database database = await DatabaseHelper().database;

    final List maps = await database.query(
      tableName,
      orderBy: 'created_at DESC',
    );

    return List.generate(maps.length, (i) {
      return Tasks.fromMap(maps[i]);
    });
  }

  Future<List<Tasks>> getTodayTask() async {
    Database database = await DatabaseHelper().database;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // print(formattedDate);
    final List<Map<String, dynamic>> maps = await database.query(tableName,
        orderBy: 'created_at DESC',
        where: 'date = ?',
        whereArgs: [formattedDate]);
    // final List<Map<String, dynamic>> maps = await database.query(
    //   tableName,
    //   orderBy: 'created_at DESC',
    // );
    // print(maps);
    return List.generate(maps.length, (i) {
      return Tasks.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Tasks tasks) async {
    Database database = await DatabaseHelper().database;

    return await database.update(
      tableName,
      tasks.toMap(),
      where: 'id = ?',
      whereArgs: [tasks.id],
    );
  }

  Future<int> deleteTask(int id) async {
    Database database = await DatabaseHelper().database;

    return await database.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
