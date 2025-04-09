import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vegas_roster/Model/day.dart';

import '../../model/user.dart';
import '../widget_roster/item_roster.dart';

generateDate(List<DayM> listDays) async {
    for (int i = 0; i < 13 + 1; i++) {
      listDays.add(DayM(i, DateTime(2022, 05, 16).add(Duration(days: i)), false,
          false, '', 'grey'));
    }
    for (var item in listDays) {
      if (stringFormat.formatDateOnlyDayText(item.day) == 'Sun' ||
          stringFormat.formatDateOnlyDayText(item.day) == 'Sat') {
        item.isWeekDay = true;
      } else {
        item.isWeekDay = false;
      }
    }
    return listDays;
  }

  addShiftNametoList({id,listDays}) {
    List<DayM> listDays = [
    DayM(1, DateTime(2000, 01, 01), false, false, '', 'grey')
  ];
    List<User> listUser = [];
    User? userModel;

    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("user")
        .where('id', isEqualTo: id)
        .snapshots()
        .asBroadcastStream();
    stream.forEach((event) {
      event.docs.asMap().forEach((key, value) {
        userModel = User.fromJson(value.data() as Map<String, dynamic>);
        listUser.add(userModel!);
      });
    });
    final shiftModel = userModel?.shift;

    shiftModel?.asMap().forEach((key, value) {
      for (final item in listDays) {
        if (stringFormat.formatDate(item.day) ==
            stringFormat.formatDate(shiftModel[key].date.toDate())) {
          item.text = shiftModel[key].shiftName;
          if (shiftModel[key].shiftName.toUpperCase().contains("A")) {
            item.color = 'blue';
          } else if (shiftModel[key].shiftName.toUpperCase().contains("B")) {
            item.color = 'green';
          } else if (shiftModel[key].shiftName.toUpperCase().contains("C")) {
            item.color = 'red';
          } else if (shiftModel[key].shiftName.toUpperCase().contains("OFF")) {
            item.color = 'yellow';
          } else {
            item.color = 'grey';
          }
        }
      }
    });

    return listUser;
  }