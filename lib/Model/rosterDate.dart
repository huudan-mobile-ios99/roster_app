import 'package:cloud_firestore/cloud_firestore.dart';

class RosterDate {
  List<RosterDateItem> rosterDateItem;
  RosterDate({
    this.rosterDateItem = const [],
  });
  
  factory RosterDate.fromJson(Map<String, dynamic> json) => RosterDate(
       rosterDateItem: List<RosterDateItem>.from(
      json["date"].map((x) => RosterDateItem.fromJson(x)),
      ),
      );
}

class RosterDateItem {
  
  final Timestamp end;
  final Timestamp start;
  final bool isActive;
  RosterDateItem(
      {required this.start,
      required this.end,
      required this.isActive,
      });
  factory RosterDateItem.fromJson(Map<String, dynamic> json) => RosterDateItem(
      start: json['start'] ?? Timestamp.fromDate(DateTime(2000,01,01)),
      end: json['end'] ?? Timestamp.fromDate(DateTime(2000,01,01)),
      isActive: json['isActive'] ?? false,
      );

  Map<String, dynamic> toJson() => {
        'end': end,
        'start': start,
        'isActive': isActive,
      };
}
