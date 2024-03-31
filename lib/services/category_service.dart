import 'package:flutter/material.dart';
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

  Future<int> deleteTask(int id, BuildContext context) async {
    Database database = await DatabaseHelper().database;
    try {
      return await database.delete(
        tableName,
        where: 'id = ?',
        whereArgs: [id],
      );
    } catch (e) {
      toast("Remove Task assoiciated to this category ", context,
          isError: true);

      return 0;
    }
  }

  Future<bool> defaultcategories() async {
    try {
      Database database = await DatabaseHelper().database;
      Category cat = Category(
          name: "Study",
          created_at: DateTime.now(),
          updated_at: DateTime.now());
      await database.insert(tableName, cat.toMap());

      cat = Category(
          name: "Exercise",
          created_at: DateTime.now(),
          updated_at: DateTime.now());
      await database.insert(tableName, cat.toMap());

      cat = Category(
          name: "Sleep",
          created_at: DateTime.now(),
          updated_at: DateTime.now());
      await database.insert(tableName, cat.toMap());
      return true;
    } catch (e) {
      return false;
    }
  }
}
