import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';

class CatogoryService {
  String tableName = 'categories';

  Future<int> insertTask(Category category) async {
    Database database = await DatabaseHelper().database;
    return await database.insert(tableName, category.toMap());
  }

  Future<List<Category>> getAllTasks() async {
    Database database = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps =
        await database.query(tableName, orderBy: 'created_at DESC');
    // print(maps);
    return List.generate(maps.length, (i) {
      return Category(
        id: maps[i]['id'],
        name: maps[i]['name'],
      );
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
