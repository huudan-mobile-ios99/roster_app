import 'package:cloud_firestore/cloud_firestore.dart';

class User {
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
  String? color = '0xFF31C7F5';
  List<Shift> shift;
  User(
      {this.id = '',
      required this.status,
      required this.name,
      required this.vietnameseName,
      required this.gender,
      required this.group,
      required this.number,
      required this.role,
      this.color,
      this.shift = const [],
      required this.password,
      this.image,
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
        'color':color,
        'role': role,
        'password': password,
        'status': status,
        'shift': _shiftList([
          Shift(shiftName: '', date: Timestamp.fromDate(DateTime(2022, 01, 01)))
        ]),
      };

  List<Map<String, dynamic>>? _shiftList(List<Shift>? vaccinations) {
    if (vaccinations == null) {
      return null;
    }
    final vaccinationMap = <Map<String, dynamic>>[];
    vaccinations.forEach((vaccination) {
      vaccinationMap.add(vaccination.toJson());
    });
    return vaccinationMap;
  }

  factory User.fromJson(Map<String, dynamic> json) => User(
      id: json["id"] ?? '',
      shift: List<Shift>.from(
        json["shift"].map((x) => Shift.fromJson(x)) ?? "",
      ),
      name: json['name'] ?? "",
      vietnameseName: json['vietnameseName'] ?? '',
      number: json['number'] ?? '',
      gender: json['gender'] ?? '',
      birthday: json['birthday'] ?? Timestamp.fromDate(DateTime(2000, 01, 01)),
      group: json['group'] ?? '',
      role: json['role'] ?? '',
      status: json['status'] ?? "",
      color: json['color'] ?? "",
      image: json['image'] ?? '',
      password: json['password'] ?? '');

  factory User.fromDocument(DocumentSnapshot doc) {
    return User(
        status: doc.get('status') ?? '',
        shift: doc.get('shift') ?? 'default shift',
        name: doc.get('name') ?? 'default_name',
        color: doc.get('color') ?? "0xFF31C7F5",
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

class Shift {
  String shiftName;
  final Timestamp date;
  Shift({
    required this.shiftName,
    required this.date,
  });
  factory Shift.fromJson(Map<String, dynamic> json) =>
      Shift(shiftName: json['shiftName'] ?? '', date: json['date'] ?? "");
  				Map<String, dynamic> toJson() => {
        'shiftName': shiftName,
        'date': date,
      };
}
