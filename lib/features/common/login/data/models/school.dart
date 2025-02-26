import 'dart:convert';

import 'package:equatable/equatable.dart';

class School extends Equatable {
  final String? name;
  final String? id;

  const School({this.name, this.id});

  factory School.fromMap(Map<String, dynamic> data) =>
      School(name: data['name'] as String?, id: data['id'] as String?);

  Map<String, dynamic> toMap() => {'name': name, 'id': id};

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [School].
  factory School.fromJson(String data) {
    return School.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [School] to a JSON string.
  String toJson() => json.encode(toMap());

  School copyWith({String? name, String? id}) {
    return School(name: name ?? this.name, id: id ?? this.id);
  }

  @override
  List<Object?> get props => [name, id];
}
