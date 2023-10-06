import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/util/toast.dart';

class CategoryService {
  String tableName = 'categories';

  Future<int> insertTask(Category category) async {
    Database database = await DatabaseHelper().database;
    return await database.insert(tableName, category.toMap());
  }

  Future<List<Category>> getAllCategory() async {
    Database database = await DatabaseHelper().database;

    final List<Map<String, dynamic>> maps =
        await database.query(tableName, orderBy: 'created_at DESC');
    // print(maps);
    return List.generate(maps.length, (i) {
      return Category.fromMap(maps[i]);
    });
  }

  Future<int> updateCategory(Category category) async {
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
    try {
      return await database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      showToast("Remove Task assoiciated to this category ", isError: true);

      return 0;
    }
  }
}
