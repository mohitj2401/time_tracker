// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

// import 'package:time_tracker/models/category.dart';

class TimeRec {
  int? id;
  int? categoryId;
  String? date;
  String? time;
  String? name;
  String? description;
  TimeRec({
    this.id,
    this.categoryId,
    this.date,
    this.time,
    this.name,
    this.description,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'category_id': categoryId,
      'date': date,
      'time': time,
      'name': name,
      'description': description,
    };
  }

  factory TimeRec.fromMap(Map<String, dynamic> map) {
    return TimeRec(
      id: map['id'] != null ? map['id'] as int : null,
      categoryId: map['category_id'] != null ? map['category_id'] as int : null,
      date: map['date'] != null ? map['date'] as String : null,
      time: map['time'] != null ? map['time'] as String : null,
      name: map['name'] != null ? map['name'] as String : null,
      description:
          map['description'] != null ? map['description'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory TimeRec.fromJson(String source) =>
      TimeRec.fromMap(json.decode(source) as Map<String, dynamic>);
}
