import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:sqflite/sqflite.dart';
import 'package:time_tracker/helper/datebase.dart';
import 'package:time_tracker/models/category.dart';
import 'package:time_tracker/models/datamodel.dart';
import 'package:time_tracker/models/tasks.dart';
import 'package:time_tracker/util/constant.dart';
import 'package:time_tracker/util/toast.dart';

class ReportService {
  String tableName = 'tasks';

  Future<List<DataModel>> getMonthlyReport() async {
    Logger log = Logger();
    Database database = await DatabaseHelper().database;
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(now);
    // log.i(formattedDate);
    //   final List maps = await database.rawQuery('''
    //   SELECT time,category_id,date, SUM(
    //            strftime('%H', time) * 60 +
    //            strftime('%M', time) * 1 +
    //            strftime('%S', time) /60
    //          ) AS total_seconds
    //   FROM tasks
    //   where date = $formattedDate
    //   GROUP BY category_id
    // ''');
    //   log.i(maps);
    final List maps = await database.query(
      'tasks',
      columns: [
        '''SUM(strftime('%H', time) * 60 + 
             strftime('%M', time) * 1 + 
             strftime('%S', time) /60
           ) AS total_seconds''',
        'category_id'
      ],
      groupBy: 'category_id',
      where: 'date = ?',
      whereArgs: [formattedDate],
    );
    // log.i(maps);
    return List.generate(maps.length, (i) {
      // log.i(maps[i]);
      return DataModel(
        x: AppConstants.categories
            .firstWhere((element) => element.id == maps[i]["category_id"])
            .name!,
        y: maps[i]["total_seconds"],
      );
    });
  }

  Future<List<List<DataModel>>> getWeeklyReport() async {
    Logger log = Logger();
    Database database = await DatabaseHelper().database;
    DateTime now = DateTime.now();
    List<List<DataModel>> weekly = [];
    List<Category> categories = AppConstants.categories;

    for (var j = 0; j < categories.length; j++) {
      List<DataModel> catrec = [];
      for (var i = 0; i < 7; i++) {
        String formattedDate =
            DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));
        final List maps = await database.query(
          'tasks',
          columns: [
            '''SUM(strftime('%H', time) * 60 +
             strftime('%M', time) * 1 +
             strftime('%S', time) /60
           ) AS total_seconds''',
            'category_id',
            'date'
          ],
          groupBy: 'category_id',
          where: 'date = ? And category_id = ?',
          whereArgs: [formattedDate, categories[j].id],
        );
        if (maps.isNotEmpty) {
          // log.i([categories[j].id, maps.isNotEmpty]);
          catrec.add(DataModel(
            y: maps[0]['total_seconds'],
            x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
            z: categories[j].name,
          ));
        } else {
          // log.i([categories[j].id, maps.isNotEmpty]);

          catrec.add(DataModel(
            y: 0,
            x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
            z: categories[j].name,
          ));
        }
      }
      weekly.add(catrec);
    }
    // for (var i = 0; i < 7; i++) {
    //   List<DataModel> dayrec = [];
    //   String formattedDate =
    //       DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));

    //   for (var j = 0; j < categories.length; j++) {
    //     final List maps = await database.query(
    //       'tasks',
    //       columns: [
    //         '''SUM(strftime('%H', time) * 60 +
    //          strftime('%M', time) * 1 +
    //          strftime('%S', time) /60
    //        ) AS total_seconds''',
    //         'category_id',
    //         'date'
    //       ],
    //       groupBy: 'category_id',
    //       where: 'date = ? And category_id = ?',
    //       whereArgs: [formattedDate, categories[j].id],
    //     );

    //     if (maps.isNotEmpty) {
    //       // log.i([categories[j].id, maps.isNotEmpty]);
    //       dayrec.add(DataModel(
    //         y: maps[0]['total_seconds'],
    //         x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
    //         z: categories[j].name,
    //       ));
    //     } else {
    //       // log.i([categories[j].id, maps.isNotEmpty]);

    //       dayrec.add(DataModel(
    //         y: 0,
    //         x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
    //         z: categories[j].name,
    //       ));
    //     }
    //   }
    //  await AppConstants.categories.forEach((element) async {

    //     // log.i(maps);
    //   });
    // log.i(dayrec);

    // weekly.add(dayrec);
    // }
    // log.i(weekly[1]);
    // AppConstants.categories.forEach((element) async {
    //   List<DataModel> cate = [];
    //   int time = 0;
    //   for (var i = 0; i < 7; i++) {
    //     String formattedDate =
    //         DateFormat('yyyy-MM-dd').format(now.subtract(Duration(days: i)));

    //     final List maps = await database.query(
    //       'tasks',
    //       columns: [
    //         '''SUM(strftime('%H', time) * 60 +
    //          strftime('%M', time) * 1 +
    //          strftime('%S', time) /60
    //        ) AS total_seconds''',
    //         'category_id',
    //         'date'
    //       ],
    //       groupBy: 'category_id',
    //       where: 'date = ? And category_id = ?',
    //       whereArgs: [formattedDate, element.id],
    //     );
    //     if (maps.isEmpty) {
    //       time = 0;
    //       log.i(maps);
    //       cate.add(
    //         DataModel(
    //             x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
    //             y: 0,
    //             z: 'Remaing'),
    //       );
    //     } else {
    //       time = time + (maps[0]['total_seconds'] as int);
    //       log.i(maps);
    //       cate.add(
    //         DataModel(
    //             x: DateFormat('EEEE').format(now.subtract(Duration(days: i))),
    //             y: maps[0]["total_seconds"],
    //             z: AppConstants.categories
    //                 .firstWhere(
    //                     (element) => element.id == maps[0]["category_id"])
    //                 .name!),
    //       );
    //     }
    //   }
    //   weekly.add(cate);
    // });

    return weekly;
  }
}
