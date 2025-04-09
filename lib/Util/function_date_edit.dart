import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/Model/dateroster.dart';
import 'package:vegas_roster/Model/day.dart';

import '../Screen/widget_roster/item_roster.dart';

Future getStartDateFromServerTOLIST() async {
  final db = FirebaseFirestore.instance.collection('rosterDate').get();
  DateRoster myDate;
  List<DateRosterM> listDate = [];
  await db.then((value) {
    value.docs.forEach((element) {
      myDate = DateRoster.fromJson(element.data());

      for (final item in myDate.date) {
        listDate.add(DateRosterM(
            end: item.end, start: item.start, isActive: item.isActive));
      }
    });
  });
  return listDate;
}

Future getStartDateFromServer() async {
  DateTime today = DateTime.now();
  DateTime startDate = today;
  int differentInDays = 0;
  final db = FirebaseFirestore.instance.collection('rosterDate').get();

  await db.then((value) {
    value.docs.forEach((element) {
      DateRoster myDate = DateRoster.fromJson(element.data());
      // debugPrint('date length: ${myDate.date.length}');
      for (final item in myDate.date) {
        // debugPrint('date from server: ${item.isActive} ${item.start.toDate()}');
        final isBefore = item.start.toDate().isBefore(today);
        final isAfter = item.end.toDate().isAfter(today);
        if (isBefore == true && isAfter == true) {
          differentInDays =
              item.end.toDate().difference(item.start.toDate()).inDays;
          startDate = item.start.toDate();
          // debugPrint('different in days: ${differentInDays.toString()}');
          // debugPrint('start day: ${startDate.toIso8601String().toString()}');
        }
      }
    });
  });
  return startDate;
}

Future getStartDateFromServer__({isPrevRoster = false}) async {
  DateTime today = DateTime.now();
  DateTime startDate = today;
  int differentInDays = 0;
  final db = FirebaseFirestore.instance.collection('rosterDate').get();
  List<DateTime> listAllStarDate = [];
  await db.then((value) {
    value.docs.forEach((element) {
      DateRoster myDate = DateRoster.fromJson(element.data());
      // debugPrint('date length: ${myDate.date.length}');
      for (final item in myDate.date) {
        // debugPrint('date from server: ${item.isActive} ${item.start.toDate()}');
        listAllStarDate.add(item.start.toDate());
        // if (item.isActive == true) {
        //   mydateResult = item.start.toDate();
        // } else {
        //   listAllStarDate.add(item.start.toDate());
        // }
      }
    });
  });
  // print(listAllStarDate);
  return isPrevRoster == true
      ? listAllStarDate[(listAllStarDate.length - 2)]
      : listAllStarDate.last;
}

generateDateWITHSTART(List<DayM> listDays, DateTime startDate) {
  for (int i = 0; i < 13 + 1; i++) {
    listDays.add(
        DayM(i, startDate.add(Duration(days: i)), false, false, '', 'grey'));
  }
  return listDays;
}

generateDatewithstart(List<DateTime> listDays, DateTime startDate) {
  for (int i = 0; i < 13 + 1; i++) {
    listDays.add(startDate.add(Duration(days: i)));
  }
  return listDays;
}


// Future getDaysInBetweenFromServer(listDays) async {
//   getStartDateFromServer().then((value) {
//     for (int i = 0; i < 13 + 1; i++) {
//       listDays
//           .add(DayM(i, value.add(Duration(days: i)), false, false, '', 'grey'));
//     }
//   });
//   return listDays;
// }
