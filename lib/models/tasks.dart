// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:time_tracker/models/category.dart';

class Tasks {
  int? id;
  int category_id;
  String? description;
  String date;
  String time;
  String name;
  DateTime? created_at;
  DateTime? updated_at;
  Tasks({
    this.id,
    required this.category_id,
    this.description,
    required this.date,
    required this.time,
    required this.name,
    this.created_at,
    this.updated_at,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': category_id,
      'description': description,
      'date': date,
      'time': time,
      'name': name,
      'created_at': created_at!.millisecondsSinceEpoch,
      'updated_at': updated_at!.millisecondsSinceEpoch,
    };
  }

  factory Tasks.fromMap(Map<String, dynamic> map) {
    return Tasks(
      id: map['id'] != null ? map['id'] as int : null,
      category_id: map['category_id'] as int,
      description:
          map['description'] != null ? map['description'] as String : null,
      date: map['date'],
      time: map['time'] as String,
      name: map['name'] as String,
      created_at: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
      updated_at: DateTime.fromMillisecondsSinceEpoch(map['updated_at'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory Tasks.fromJson(String source) =>
      Tasks.fromMap(json.decode(source) as Map<String, dynamic>);
}
