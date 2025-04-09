import 'package:cloud_firestore/cloud_firestore.dart';

class UserSave {
  String id;
  final String name;
  final String vietnameseName;
  final String group;
  final String role;
  final String number;
  UserSave({
      this.id = '',
      required this.name,
      required this.vietnameseName,
      required this.group,
      required this.number,
      required this.role,
      });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'vietnameseName': vietnameseName,
        'number': number,
        'group': group,
        'role': role,
  };
   factory UserSave.fromJson(Map<String, dynamic> json) => UserSave(
        id: json["id"] ?? '',
        name:json['name'],
        vietnameseName: json['vietnameseName'] ?? '',
        number: json['number'] ?? '',
        group: json['group'] ?? '',
        role:json['role'] ?? '',

    );

  factory UserSave.fromDocument(DocumentSnapshot doc) {
    return UserSave(
        id: doc.get('id') ?? '',
        name: doc.get('name') ?? 'default_name',
        vietnameseName: doc.get('default_vietnameseName') ?? 'default_vietnameseName',
        group: doc.get('group') ?? 'default_group',
        number: doc.get('number') ?? 'default_number',
        role: doc.get('role') ?? 'default_role',
        );
  }
}
