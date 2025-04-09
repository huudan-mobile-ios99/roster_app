import 'package:cloud_firestore/cloud_firestore.dart';

class User2 {
  String id;
  final String name;
  final Timestamp birthday;
  final String vietnameseName;
  final String gender;
  final String group;
  final String role;
  final String number;
  final String password;
  final String status;
  final String? image;
  final String? shiftName;
  User2(
      {this.id = '',
      required this.status,
      required this.name,
      required this.vietnameseName,
      required this.gender,
      required this.group,
      required this.number,
      required this.role,
      required this.password,
      this.image,this.shiftName,
      required this.birthday});

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'vietnameseName': vietnameseName,
        'number': number,
        'gender': gender,
        'birthday': birthday,
        'group': group,
        'image': image,
        'role': role,
        'password': password,
        'status': status,
        'shiftName':shiftName,
      };

  

  factory User2.fromJson(Map<String, dynamic> json) => User2(
      id: json["id"] ?? '',
      shiftName: json['shiftName'] ?? '',
      name: json['name'] ?? "",
      vietnameseName: json['vietnameseName'] ?? '',
      number: json['number'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? Timestamp.fromDate(DateTime(2000, 01, 01)),
      group: json['group'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? "",
      image: json['image'] ?? '',
      password: json['password'] ?? '');

  factory User2.fromDocument(DocumentSnapshot doc) {
    return User2(
        status: doc.get('status') ?? '',
        shiftName: doc.get('shiftName')??'',
        name: doc.get('name') ?? 'default_name',
        vietnameseName:doc.get('default_vietnameseName') ?? 'default_vietnameseName',
        gender: doc.get('gender') ?? 'default_gender',
        group: doc.get('group') ?? 'default_group',
        number: doc.get('number') ?? 'default_number',
        image: doc.get('image') ?? '',
        role: doc.get('role') ?? 'default_role',
        password: doc.get('password') ?? 'default_password',
        birthday: doc.get('birthday') ?? 'default_birthday');
  }
}


