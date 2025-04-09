class EventList {
  List<EventItem> shiftItem;
  String? body, time;
  EventList({
    this.shiftItem = const [],
    this.body,
    this.time,
  });

  factory EventList.fromJson(Map<String, dynamic> json) => EventList(
        shiftItem: List<EventItem>.from(
          json["listLog"].map((x) => EventItem.fromJson(x)),
        ),
      );
  Map<String, dynamic> toJson() => {
        'listLog': _shiftList([EventItem(body: body!, time: time!)]),
      };

  List<Map<String, dynamic>>? _shiftList(List<EventItem>? list) {
    if (list == null) {
      return null;
    }
    final itemMap = <Map<String, dynamic>>[];
    list.forEach((item) {
      itemMap.add(item.toJson());
    });
    return itemMap;
  }
}

class EventItem {
  final String body;
  final String time;
  EventItem({
    required this.body,
    required this.time,
  });
  factory EventItem.fromJson(Map<String, dynamic> json) => EventItem(
        body: json['body'] ?? "",
        time: json['time'] ?? "",
      );

  Map<String, dynamic> toJson() => {
        'time': time,
        'body': body,
      };
}
