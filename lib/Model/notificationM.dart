class NotificationM {
  List<NotificationItem> notificationItem;
  String? created,
      type,
      from,
      to,
      actionResult,
      actionType,
      userID,
      userName,
      itemID;
  NotificationItemBody? body;
  NotificationM({
    this.notificationItem = const [],
    this.body,
    this.created,
    this.type,
    this.from,
    this.to,
    this.actionResult,
    this.userID,
    this.userName,
    this.itemID,
  });

  factory NotificationM.fromJson(Map<String, dynamic> json) => NotificationM(
        notificationItem: List<NotificationItem>.from(
          json["notification"].map((x) => NotificationItem.fromJson(x)),
        ),
      );
  Map<String, dynamic> toJson() => {
        'notification': _shiftList([
          NotificationItem(
            itemID: itemID,
            userID: userID!,
            userName: userName!,
            actionResult: actionResult!,
            isAction: false,
            body: body!,
            created: created!,
            type: type!,
            from: from!,
            to: to!,
          )
        ]),
      };

  List<Map<String, dynamic>>? _shiftList(List<NotificationItem>? list) {
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

class NotificationItem {
  final NotificationItemBody body;
  final String created;
  final String userName;
  final String type;
  final String userID;
  final String from;
  late String? itemID;
  final String to;
  bool isAction = false;
  final String actionResult;
  NotificationItem({
    required this.userID,
    this.itemID,
    required this.userName,
    required this.body,
    required this.created,
    required this.type,
    required this.from,
    required this.to,
    required this.isAction,
    required this.actionResult,
  });
  factory NotificationItem.fromJson(Map<String, dynamic> json) =>
      NotificationItem(
          
          userID: json['userID'] ?? "",
          itemID: json['itemID'] ?? "",
          userName: json['userName'] ?? "",
          body: NotificationItemBody.fromJson(json["body"]),
          // body: json['body'] ?? "",
          created: json['created'] ?? "",
          type: json['type'] ?? "",
          from: json['from'] ?? "",
          to: json['to'] ?? "",
          actionResult: json['actionResult'] ?? 'request',
          isAction: json['isAction'] ?? false);

  Map<String, dynamic> toJson() => {
        'created': created,
        "itemID":itemID,
        'userID': userID,
        'userName': userName,
        'body': body.toJson(),
        'type': type,
        'from': from,
        'to': to,
        'isAction': isAction,
        'actionResult': actionResult,
      };
}

class NotificationItemBody {
  final String date;
  final String shiftNew;
  final String shiftOld;
  final String body;
  NotificationItemBody({
    required this.date,
    required this.shiftNew,
    required this.shiftOld,
    required this.body,
  });

  factory NotificationItemBody.fromJson(Map<String, dynamic> json) =>
      NotificationItemBody(
          date: json['date'] ?? "",
          shiftNew: json['shiftNew'] ?? "",
          shiftOld: json['shiftOld'] ?? "",
          body: json['body'] ?? "");

  Map<String, dynamic> toJson() =>
      {'date': date, 'shiftNew': shiftNew, 'shiftOld': shiftOld, 'body': body};
}
