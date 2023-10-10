// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class DataModel {
  int y;
  String x;
  String? z;
  DataModel({
    required this.y,
    required this.x,
    this.z,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'y': y,
      'x': x,
      'z': z,
    };
  }

  factory DataModel.fromMap(Map<String, dynamic> map) {
    return DataModel(
      y: map['y'] as int,
      x: map['x'] as String,
      z: map['z'] != null ? map['z'] as String : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory DataModel.fromJson(String source) =>
      DataModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'DataModel(y: $y, x: $x, z: $z)';
}
