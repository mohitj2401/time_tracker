import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/models/tasks.dart';

class TaskService {
  String tableName = 'tasks';

  Future<int> insertTask(Tasks tasks) async {
    Database database = await DatabaseHelper().database;
    return await database.insert(tableName, tasks.toMap());
  }

  Future<List<Tasks>> getAllTask() async {
    Database database = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps =
        await database.query(tableName, orderBy: 'created_at DESC');
    // print(maps);
    return List.generate(maps.length, (i) {
      return Tasks.fromMap(maps[i]);
    });
  }

  Future<int> updateTask(Category category) async {
    Database database = await DatabaseHelper().database;

    return await database.update(
      tableName,
      category.toMap(),
      where: 'id = ?',
      whereArgs: [category.id],
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
