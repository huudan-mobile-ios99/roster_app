import 'package:cloud_firestore/cloud_firestore.dart';

class ShiftToday {
  final String shiftName;
  final Timestamp date;
  final String id;
  ShiftToday({
    required this.date,
    required this.shiftName,
    required this.id,
  });
  factory ShiftToday.fromJson(Map<String, dynamic> json) => ShiftToday(
        shiftName: json['shiftName'] ?? "",
        id: json['id'] ?? "",
        date:json['date'] ?? Timestamp.fromDate(DateTime.now())
      );

  Map<String, dynamic> toJson() => {
        'shiftName': shiftName,
        'id': id,
        'date': date
      };
}
