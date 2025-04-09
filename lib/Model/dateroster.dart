// To parse this JSON data, do
//
//     final dateRoster = dateRosterFromJson(jsonString);

import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class DateRoster {
  DateRoster({
    required this.date,
  });

  List<DateRosterM> date;

  factory DateRoster.fromJson(Map<String, dynamic> json) => DateRoster(
        date: List<DateRosterM>.from(json["date"].map((x) => DateRosterM.fromJson(x))),
  );
  
    
     Map<String, dynamic> toJson() => {
        "date": List<dynamic>.from(date.map((x) => x.toJson())),
    };
}

class DateRosterM {
  DateRosterM({
    required this.end,
    required this.start,
    required this.isActive,
  });

  Timestamp end;
  Timestamp start;
  bool isActive;

  factory DateRosterM.fromJson(Map<String, dynamic> json) => DateRosterM(
        end: json["end"],
        start: json["start"],
        isActive:json['isActive'] ?? false,
  );
  Map<String, dynamic> toJson() => {
        'start': start,
        'end': end,
        'isActive': isActive,
      };
}
