import 'package:cloud_firestore/cloud_firestore.dart';

class ListGroup {
  List<Group> listGroup;
  ListGroup({
    this.listGroup = const [],
  });

  factory ListGroup.fromJson(Map<String, dynamic> json) => ListGroup(
          listGroup: List<Group>.from(
        json["listGroup"].map((x) => Group.fromJson(x)) ?? "",
      ));
}

class Group {
  final String id;
  final String name;
  final String color;
  Group({
    required this.id,
    required this.name,
    required this.color,
  });
  factory Group.fromJson(Map<String, dynamic> json) => Group(
        id: json['iod'] ?? '',
        name: json['name'] ?? "",
        color:json['color'] ?? '0xFF0082be',
      );
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'color': color,
      };
}
