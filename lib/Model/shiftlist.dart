class ShiftList {
  List<ShiftItem> shiftItem;
  ShiftList({
    this.shiftItem = const [],
  });
  
  factory ShiftList.fromJson(Map<String, dynamic> json) => ShiftList(
      shiftItem: List<ShiftItem>.from(
        json["shiftTime"].map((x) => ShiftItem.fromJson(x)),
      ),
      );
}

class ShiftItem {
  final String isSelected;
  final String shiftCode;
  final String type;
  final String shiftTime;
  final String id;
  ShiftItem(
      {required this.shiftCode,
      required this.shiftTime,
      required this.type,
      required this.id,
      required this.isSelected});
  factory ShiftItem.fromJson(Map<String, dynamic> json) => ShiftItem(
      shiftCode: json['shiftCode'] ?? "",
      shiftTime: json['shiftTime'] ?? "",
      type: json['type'] ?? "",
      id: json['id'] ?? "",
      isSelected: json['isSelected'] ?? "false");

  Map<String, dynamic> toJson() => {
        'shiftCode': shiftCode,
        'shifttime': shiftTime,
        'isSelected': isSelected,
        'id': id,
        'type': type,
      };
}
