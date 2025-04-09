// ignore_for_file: await_only_futures

import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegas_roster/Model/dateroster.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/eventlog.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Model/notificationM.dart';
import 'package:vegas_roster/Model/rosterDate.dart';
import 'package:vegas_roster/Model/shiftWithTime.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Model/shifttoday.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/onduty/compare_time.dart';
import 'package:vegas_roster/Screen/shift_time.dart';
import 'package:vegas_roster/Screen/widget_roster/mysnackbar.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/toast.dart';

final stringFormat = StringFormat();

String formatDateStandar(DateTime date) =>  DateFormat("yyyy-MM-dd").format(date);
Future<List<User>> addDataToList() async {
  final firestore = FirebaseFirestore.instance;
  List<User> userList = [];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .get();

  queryA.docs.forEach((element_) {
    User user = User.fromJson(element_.data() as Map<String, dynamic>);
    userList.add(user);
  });
  return userList;
}

Future<List<User>> searchFuntion(List<User> userListSearch, groupName) async {
  // final List<User> userList = [];
  final Stream<QuerySnapshot> stream = FirebaseFirestore.instance
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .snapshots();

  stream.forEach((event) {
    event.docs.asMap().forEach((key, value) {
      User userModel = User.fromJson(value.data() as Map<String, dynamic>);
      userListSearch.add(userModel);
    });
  });
  debugPrint('search to list: ${userListSearch.length}');
  return userListSearch.toSet().toList();
}

generateDate(List<DayM> listDays) {
  final today = DateTime.now();
  final monthAgo = DateTime(today.year, today.month, today.day);
  final month = DateTime(today.year, today.month, 1);
  final monthAgoToday = DateTime(today.year, today.month + 1, 1);

  // Find the last day of the month.
  final lastDayDateTime = (today.month < 12)
      ? DateTime(today.year, today.month + 1, 0)
      : DateTime(today.year + 1, 1, 0);
  debugPrint('lastday ${lastDayDateTime.day} ${lastDayDateTime.month} ${lastDayDateTime.year}');
  // debugPrint('firstDay ${lastDayDateTime.day} ${lastDayDateTime.month} ${lastDayDateTime.year}');
  final firstDayNextMonth = DateTime(today.year, today.month + 1, 1);
  final endDayNextMonth = DateTime(today.year, today.month + 2, 0);
  int diffent_ind_day = (lastDayDateTime.difference(month).inDays + 1).abs();
  int diffent_ind_day_next_month =
      (endDayNextMonth.difference(firstDayNextMonth).inDays + 1).abs();
  debugPrint("diffent_ind_day $diffent_ind_day");

  for (int i = 0; i <= diffent_ind_day; i++) {
    listDays.add(
        DayM(i, monthAgo.add(Duration(days: i)), false, false, '', 'grey'));
  }
  final firstDayOfMonth = DateTime(today.year, today.month, 1);
  debugPrint(
      'first day of the month : ${stringFormat.formatDate(firstDayOfMonth)} ${stringFormat.formatDateOnlyDayText(firstDayOfMonth)}');

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

Future createMapData({id, shiftName, date}) async {
  List<Map<String, String>> myData = [
    {'date': '2022-01-12'},
    {'shfitName': 'A1'},
  ];

  var map = new Map<String, dynamic>();
  map['doOne'] = '.text';
  map['doTwo'] = '.text23';
  map["six"] = [
    {
      "nestedOne": 'asgag',
      "nestedTwo": 'asgga',
    },
  ];

  final yourObject = Map<String, dynamic>();
  yourObject["six"] = [
    {
      "nestedOne": '234',
      "nestedTwo": '12111232fs',
    },
  ];
  final encodedObject = jsonEncode(yourObject);

  FirebaseFirestore.instance.collection('user').doc(id).set({
    "shift": FieldValue.arrayUnion([
      {
        "shiftName": shiftName,
        "date": date,
      },
    ])
  }, SetOptions(merge: true)).then((value) {
    showToast('successfull register work shift');
  }).catchError((value) {
    debugPrint('error');
  });
}

Future createMapDataToCollection(
    {id, shiftName, date, subCollectionName}) async {
  final json =
      Shift(shiftName: shiftName, date: Timestamp.fromDate(date)).toJson();
  final firestore = FirebaseFirestore.instance;
  final myQuery = firestore.collection('user/$id/$subCollectionName').doc();
  await myQuery.set(json, SetOptions(merge: false)).then((value) {
    debugPrint('update newwork shift ');
  }).catchError((e) {
    debugPrint('error update new work shift group $e');
  });
}

Future removeMapDataFromCollection(
    {id, shiftName,DateTime? date, subCollectionName}) async {
  final firestore = FirebaseFirestore.instance;
  // await getIDFromListUser(name, number).then((value) => myID = value);
  final querySub = await firestore
      .collection('/user/$id/$subCollectionName')
      .where('date', isEqualTo:date)
      .get();
  querySub.docs.forEach((element) {
    element.reference.delete().then((value) => debugPrint('shift item was deleted in subcollection: $subCollectionName'));
  });
}
Future removeMapDataFromCollectionID(
    {id, shiftName, subCollectionName}) async {
  final firestore = FirebaseFirestore.instance;
  // await getIDFromListUser(name, number).then((value) => myID = value);
  final querySub = await firestore
      .collection('/user/$id/$subCollectionName')
      .where('id', isEqualTo:id)
      .get();
  querySub.docs.forEach((element) {
    element.reference.delete().then((value) => debugPrint('shift item was deleted in subcollection: $subCollectionName'));
  });
}

Future removeDate({id, User? user, date, shiftName}) async {
  final myx = FirebaseFirestore.instance.collection('user').doc(id).get();
  myx.then((value) {
    User user = User.fromJson(value.data() as Map<String, dynamic>);
    final myvalue = user.shift[0].date;
    final collection = FirebaseFirestore.instance.collection('user');
    collection.doc(id).update({
      'shift': FieldValue.arrayRemove([
        {
          "shiftName": shiftName,
          "date": date,
        },
      ])
    });
  });
}

Future getAllUserByGroup(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .get();

  queryA.docs.forEach((element_) {
    User user = User.fromJson(element_.data() as Map<String, dynamic>);
    // final dateForUser = DateTime(now.year, now.month, now.day,now.hour,now.minute);
    userList.add(User(
        status: user.status,
        id: user.id,
        name: user.name,
        vietnameseName: user.vietnameseName,
        gender: user.gender,
        group: user.group,
        number: user.number,
        role: user.role,
        password: user.password,
        birthday: user.birthday,
        image: user.image,
        shift: []));
  });
  return userList;
}

Future getSearchResultData(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];
  List<ShiftMWithTime> listShift = [
    ShiftMWithTime(1, 'A', 06, 14),
    ShiftMWithTime(1, 'A1', 06, 14),
    ShiftMWithTime(1, 'A2', 12, 20),
    ShiftMWithTime(1, 'A3', 08, 16),
    ShiftMWithTime(1, 'A4', 09, 17),
    ShiftMWithTime(1, 'B', 14, 22),
    ShiftMWithTime(1, 'B1', 16, 24),
    ShiftMWithTime(1, 'C', 22, 6),
    ShiftMWithTime(1, 'C1', 20, 4),
    ShiftMWithTime(1, 'C2', 18, 2),
  ];

  for (final element in listShift) {
    final QuerySnapshot queryA = await firestore
        .collection('user')
        .orderBy('name', descending: false)
        .where('group', isEqualTo: groupName)
        .where(
      'shift',
      arrayContains: {
        'date': today1,
        'shiftName': element.shiftName,
      },
    ).get();

    queryA.docs.forEach((element_) {
      User user = User.fromJson(element_.data() as Map<String, dynamic>);
      // final dateForUser = DateTime(now.year, now.month, now.day,now.hour,now.minute);
      userList.add(User(
          status: user.status,
          name: user.name,
          vietnameseName: user.vietnameseName,
          gender: user.gender,
          group: user.group,
          number: user.number,
          role: user.role,
          password: user.password,
          birthday: user.birthday,
          image: user.image,
          shift: [
            Shift(
                shiftName: element.shiftName,
                date: Timestamp.fromDate(DateTime(
                  now.year,
                  now.month,
                  now.day,
                  element.start,
                ))),
            Shift(
                shiftName: element.shiftName,
                date: Timestamp.fromDate(DateTime(
                  now.year,
                  now.month,
                  now.day,
                  element.end,
                ))),
          ]));
    });
  }
  return userList;
}
Future createTodayShift({date,id,shiftName,dateCollectionName}) async {
  final json = ShiftToday(id:id,shiftName: shiftName, date: Timestamp.fromDate(date)).toJson();
  final firestore = FirebaseFirestore.instance;
  final myQuery = firestore.collection('$dateCollectionName').doc();
  await myQuery.set({
      'date': date,
      'shiftName': shiftName,
      'id': id,
  },SetOptions(merge:false,)).then((value) {
    debugPrint('create work shift for today collection');
  }).catchError((e) {
    debugPrint('error create new work for today collection');
  });
}
Future removeTodayShift(
    {id,date,dateCollectionName}) async {
  final firestore = FirebaseFirestore.instance;
  final querySub = await firestore
      .collection('$dateCollectionName')
      .where('date', isEqualTo: date)
      .where('id',isEqualTo: id)
      .get();
  querySub.docs.forEach((element) {
    element.reference.delete().then((value) => debugPrint('shift item was deleted in today subcollection: $dateCollectionName'));
  });
}

Future getSearchResultData2(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];
  List<ShiftMWithTime> listShift = [
    ShiftMWithTime(1, 'A', 06, 14),
    ShiftMWithTime(1, 'A1', 06, 14),
    ShiftMWithTime(1, 'A2', 12, 20),
    ShiftMWithTime(1, 'A3', 08, 16),
    ShiftMWithTime(1, 'A4', 09, 17),
    ShiftMWithTime(1, 'B', 14, 22),
    ShiftMWithTime(1, 'B1', 16, 24),
    ShiftMWithTime(1, 'C', 22, 6),
    ShiftMWithTime(1, 'C1', 20, 4),
    ShiftMWithTime(1, 'C2', 18, 2),
  ];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .get();

  final QuerySnapshot queryGet = await firestore.collection('${stringFormat.formatDate(DateTime.now())}').get();

  queryGet.docs.forEach((e) {
    ShiftToday shift = ShiftToday.fromJson(e.data() as Map<String, dynamic>);
    queryA.docs.forEach((element) {
      User user = User.fromJson(element.data() as Map<String, dynamic>);
      if (shift.id == user.id) {
        // debugPrint('ok');
        listShift.forEach((x) {
          if(x.shiftName==shift.shiftName){
userList.add(User(
            id: user.id,
            status: user.status,
            name: user.name,
            vietnameseName: user.vietnameseName,
            gender: user.gender,
            group: user.group,
            number: user.number,
            role: user.role,
            password: user.password,
            birthday: user.birthday,
            image: user.image,
            shift: [
              Shift(
                  shiftName: shift.shiftName,
                  date: Timestamp.fromDate(DateTime(
                    now.year,
                    now.month,
                    now.day,
                    x.start,
                  ))),
              Shift(
                  shiftName: shift.shiftName,
                  date: Timestamp.fromDate(DateTime(
                    now.year,
                    now.month,
                    now.day,
                    x.end,
                  ))),
            ]));
          }
          
        });
      } else {
        // debugPrint('notok');
      }
    });
  });

  return userList;
}

Future getSearchGroup(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .get();

  queryA.docs.forEach((element_) {
    User user = User.fromJson(element_.data() as Map<String, dynamic>);
    userList.add(user);
  });
  return userList;
}

Future getSearchResultDataActive(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];
  List<ShiftMWithTime> listShift = [
    ShiftMWithTime(1, 'A', 06, 14),
    ShiftMWithTime(1, 'A1', 06, 14),
    ShiftMWithTime(1, 'A2', 12, 20),
    ShiftMWithTime(1, 'A3', 08, 16),
    ShiftMWithTime(1, 'A4', 09, 17),
    ShiftMWithTime(1, 'B', 14, 22),
    ShiftMWithTime(1, 'B1', 16, 24),
    ShiftMWithTime(1, 'C', 22, 6),
    ShiftMWithTime(1, 'C1', 20, 4),
    ShiftMWithTime(1, 'C2', 18, 2),
  ];
  for (final element in listShift) {
    final QuerySnapshot queryA = await firestore
        .collection('user')
        .orderBy('name', descending: false)
        .where('group', isEqualTo: groupName)
        .where(
      'shift',
      arrayContains: {
        'date': today1,
        'shiftName': element.shiftName,
      },
    ).get();
    queryA.docs.asMap().forEach((key, value) {
      User user = User.fromJson(value.data() as Map<String, dynamic>);
      userList.add(User(
          status: user.status,
          name: user.name,
          vietnameseName: user.vietnameseName,
          gender: user.gender,
          group: user.group,
          number: user.number,
          role: user.role,
          password: user.password,
          birthday: user.birthday,
          image: user.image,
          shift: [
            Shift(
                shiftName: element.shiftName,
                date: Timestamp.fromDate(DateTime(
                  now.year,
                  now.month,
                  now.day,
                  element.start,
                ))),
            Shift(
                shiftName: element.shiftName,
                date: Timestamp.fromDate(DateTime(
                  now.year,
                  now.month,
                  now.day,
                  element.end,
                ))),
          ]));
    });
  }

  for (int i = 0; i < userList.length; i++) {
    userList[i].id = i.toString();
  }
  // print('total length before: ${userList.length} ${userList.first.id} ${userList[1].id} ${userList[2].id} ${userList[3].id} ${userList[4].id}');
  // for (int index = 0; index < userList.length; index++) {
  //   if (getTime(
  //           today: today1,
  //           startTime: userList[index].shift.first.date.toDate(),
  //           endTime: userList[index].shift.last.date.toDate()) ==
  //       false) {
  //     debugPrint('remove item ${userList[index].id}');
  //     // userList.removeAt(int.parse(userList[index].id));
  //     userList.removeWhere((item) => item.id == index.toString());
  //   }
  // }

  print('total length after: ${userList.length}');
  return userList;
}

Future getListShiftCode() async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<ShiftList> shiftList = [];

  final QuerySnapshot query = await firestore.collection('listShift').get();
  query.docs.forEach((value) {
    // debugPrint('shiftList Value: ${value.data()}');
    ShiftList item = ShiftList.fromJson(value.data() as Map<String, dynamic>);
    // print(item);
    shiftList.add(item);
  });
  // print('item shiftLsit first: ${shiftList.first.shiftItem.first.shiftCode}');
  return shiftList;
}

List<DateTime> getDaysInBetween(DateTime startDate, DateTime endDate) {
  List<DateTime> days = [];
  for (int i = 0; i <= endDate.difference(startDate).inDays; i++) {
    days.add(startDate.add(Duration(days: i)));
  }
  return days;
}

List<DateTime> getDaysInBetweenAuto() {
  final today = DateTime.now();
  List<DateTime> days = [];
  for (int i = 0; i <= 14; i++) {
    days.add(today.add(Duration(days: i)));
  }
  return days;
}

Future getDaysInBetweenFromServer() async {
  print('run getDaysInBetweenFromServer');
  final today = DateTime.now();
  List<DateTime> days = [];
  final db = FirebaseFirestore.instance.collection('rosterDate').get();
  DateTime startDate = today;
  int differentInDays = 0;
  await db.then((value) {
    value.docs.forEach((element) {
      DateRoster myDate = DateRoster.fromJson(element.data());
      for (final item in myDate.date) {
        final isBefore = item.start.toDate().isBefore(today);
        final isAfter = item.end.toDate().isAfter(today);
        if (isBefore == true && isAfter == true) {
          differentInDays =
              item.end.toDate().difference(item.start.toDate()).inDays;
          startDate = item.start.toDate();
        }
      }

      for (int i = 0; i < differentInDays + 1; i++) {
        days.add(startDate.add(Duration(days: i)));
        // debugPrint('date: ${days[i].toIso8601String()}');
      }
    });
  });
  return days;
}

Future getDataFireStore(List<User> userList) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();

  final QuerySnapshot queryA = await firestore.collection('user').get();
  queryA.docs.forEach((element) {
    User user = User.fromJson(element.data() as Map<String, dynamic>);
    userList.add(user);
  });
  return userList;
}

//get list group
Future<List<ListGroup>> getListGroup() async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<ListGroup> list = [];
  final QuerySnapshot queryA = await firestore.collection('listGroup').get();
  queryA.docs.forEach((element) {
    ListGroup listGroup =
        ListGroup.fromJson(element.data() as Map<String, dynamic>);
    list.add(listGroup);
  });
  return list;
}

//get list group
Future getListGroupNameColor(groupName) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  Group? model;
  final QuerySnapshot queryA = await firestore
      .collection('listGroup')
      .where('name', isEqualTo: groupName)
      .where('id', isEqualTo: '1')
      .get();
  debugPrint('get this');
  queryA.docs.forEach((element) {
    model = Group.fromJson(element.data() as Map<String, dynamic>);
    debugPrint('color group: ${model!.name}');
  });
  return model;
}

//get manager of group
Future getManagerOfGroup({groupName, role}) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .where('role', isEqualTo: role)
      .get();

  queryA.docs.forEach((element_) {
    User user = User.fromJson(element_.data() as Map<String, dynamic>);
    userList.add(user);
  });
  return userList.first.id.toString();
}

Future<User> getManagerOfGroupModel({groupName, role}) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  final now = DateTime.now();
  final today1 = DateTime(now.year, now.month, now.day);
  List<User> userList = [];

  final QuerySnapshot queryA = await firestore
      .collection('user')
      .orderBy('name', descending: false)
      .where('group', isEqualTo: groupName)
      .where('role', isEqualTo: role)
      .get();

  queryA.docs.forEach((element_) {
    User user = User.fromJson(element_.data() as Map<String, dynamic>);
    userList.add(user);
  });
  return userList.first;
}

generateListDate() {
  final List<DateTime> listDate = [];
  final today = DateTime.now();
  final stringFormat = StringFormat();
  final firstDay = DateTime(today.year, today.month, 1);
  final lastDay =
      DateTime(today.year, today.month + 1).subtract(const Duration(days: 1));
  final lastDayMonthAgo =
      DateTime(today.year, today.month).subtract(const Duration(days: 1));
  int diffent_ind_day = (lastDay.difference(firstDay).inDays + 1).abs();
  debugPrint(
      'firstday & lastday: ${firstDay.toIso8601String()} ${lastDay.toIso8601String()}');
  final lastDayMonthAgoDayName =
      stringFormat.formatDateOnlyDayDD(lastDayMonthAgo);

  debugPrint(
      'lastday monthAgo:  ${lastDayMonthAgo.toIso8601String()} ${lastDayMonthAgoDayName}');
  debugPrint('different in day: $diffent_ind_day');

  final thisMonthNum = today.month;
  final int maxNumberList = 14;

  // List<int> listIndexMonday = [];
  // for (int i = 0; i < listDate.length; i++) {
  //   if (stringFormat.formatDateOnlyDayDD(listDate[i]) == 'Mon') {
  //     debugPrint('firstMonday index: $i');
  //     listIndexMonday.add(i);

  //   }
  // }
  final todayDayNumber = int.parse(stringFormat.formatDateOnlyDay(today));
  debugPrint('today day number: $todayDayNumber');
  if (int.parse(stringFormat.formatDateOnlyDay(today)) <= maxNumberList) {
    //first part
    for (int i = 0; i <= maxNumberList - 1; i++) {
      listDate.add(firstDay.add(Duration(days: i)));
    }
  } else {
    //second part
    final baseOnTodayDay =
        DateTime(today.year, today.month, diffent_ind_day - 2 - maxNumberList);
    for (int i = 0; i <= maxNumberList - 1; i++) {
      listDate.add(baseOnTodayDay.add(Duration(days: i)));
    }
  }
  return listDate;
}

getUserData(UserSave user) async {
  // debugPrint('init getUserData');
  SharedPreferences pref = await SharedPreferences.getInstance();
  final json = jsonDecode(pref.getString("userData") ?? "");
  final user = UserSave.fromJson(json);
  debugPrint(user.name.toString());
}

createNewUser(
    {name,
    vietnameseName,
    age,
    number,
    gender,
    color,
    role,
    group,
    birthday,
    password,
    context,
    collectionName}) async {
  log('create user');
  final docs = FirebaseFirestore.instance.collection('user').doc();
  final myMap = <Map<String, dynamic>>[
    {"shiftName": '', 'date': Timestamp.fromDate(DateTime(2020, 01, 01))}
  ];
  final user = User(
      shift: [
        Shift(shiftName: "", date: Timestamp.fromDate(DateTime(2020, 01, 01)))
      ],
      status: 'active',
      id: docs.id,
      name: name,
      color: color ?? "0xFFE0E0E0",
      birthday: Timestamp.fromDate(birthday),
      vietnameseName: vietnameseName,
      gender: gender,
      group: group,
      number: number,
      password: password,
      role: role);
  final json = user.toJson();
  await docs.set(json).then((value) {
    showToast('create user successfully');
    Navigator.of(context).pop();
  }).catchError((e) {
    debugPrint('error create user: $e');
    showToastError('can not create user successfully');
  });
}

createNewDateForShift({start, end, isactive, context}) async {
  log('create new date');
  final docs = FirebaseFirestore.instance.collection('rosterDate').doc();

  final model = DateRoster(
    date: [
      DateRosterM(
        isActive: isactive,
        start: start,
        end: end,
      )
    ],
  );

  final json = model.toJson();
  await docs.set(json, SetOptions(merge: true)).then((value) {
    showToast('create new date successfully');
    // Navigator.of(context).pop();
  }).catchError((e) {
    debugPrint('error create user: $e');
    showToastError('can not create date successfully');
  });
}

deleteDateForShift({start, end, isactive, context}) async {
  log('create new date');
  final docs = FirebaseFirestore.instance.collection('rosterDate').doc();
  final model = DateRoster(
    date: [
      DateRosterM(
        isActive: isactive,
        start: start,
        end: end,
      )
    ],
  );

  final json = model.toJson();
  await docs.set(
      {
        'date': FieldValue.arrayRemove([
          {
            "start": start,
            "end": end,
            'isActive': isactive,
          },
        ])
      },
      SetOptions(
        merge: true,
      )).then((value) {
    showToast('delete date successfully');
    Navigator.of(context).pop();
  }).catchError((e) {
    debugPrint('error create user: $e');
    showToastError('can not delete date');
  });
}

deleteDateForShift2({start, end, isactive, context, id}) async {
  final myx = FirebaseFirestore.instance.collection('user').doc(id).get();
  await myx.then((value) {
    final collection = FirebaseFirestore.instance.collection('user');
    collection.doc(id).set({
      'date': FieldValue.arrayRemove([
        {
          "start": start,
          "end": end,
          "isActive": isactive,
        },
      ])
    }).then((value) {
      showToast('delete date successfully');
      Navigator.of(context).pop();
    }).catchError((e) {
      debugPrint('error create user: $e');
      showToastError('can not delete date');
    });
  });
}

updateNewUser(
    {name,
    vietnameseName,
    age,
    number,
    gender,
    role,
    group,
    birthday,
    password,
    context,
    collectionName}) async {
  log('create user');
  final docs = FirebaseFirestore.instance.collection('user').doc();
  final myMap = <Map<String, dynamic>>[
    {"shiftName": '', 'date': Timestamp.fromDate(DateTime(2020, 01, 01))}
  ];
  final user = User(
      shift: [
        // Shift(shiftName: "", date: Timestamp.fromDate(DateTime(2020, 01, 01)))
      ],
      status: 'active',
      id: docs.id,
      name: name,
      birthday: Timestamp.fromDate(birthday),
      vietnameseName: vietnameseName,
      gender: gender,
      group: group,
      number: number,
      password: password,
      role: role);
  final json = user.toJson();
  await docs.set(json).then((value) {
    showToast('update user successfully');

    Navigator.of(context).pop();
  }).catchError((e) {
    debugPrint('error updaete user: $e');
    showToastError('can not update user ');
  });
}

///EVENT LOG
Future removeEventLog({name, number, body, date, time}) async {
  final firestore = FirebaseFirestore.instance;
  late final String? myID;
  await getIDFromListEventLog(name, number).then((value) => myID = value);
  final querySub = await firestore.collection('/eventLog/$myID/$date').doc();
  final model = EventList(
    shiftItem: [EventItem(body: body, time: time)],
    body: body,
    time: time,
  );
  final json = model.toJson();
  await querySub.update({
    "listLog": FieldValue.arrayRemove([
      {"body": body, "time": time}
    ])
  }).then((value) {
    debugPrint('deleted  event log');
  }).catchError((e) {
    debugPrint('error delete event log: $e');
  });
}

Future createEventLog({name, number, body, date, time}) async {
  final firestore = FirebaseFirestore.instance;
  late final String? myID;
  await getIDFromListEventLog(name, number).then((value) => myID = value);
  final querySub = await firestore.collection('/eventLog/$myID/$date').doc();
  final model = EventItem(
    body: body,
    time: time,
  );
  final json = model.toJson();
  await querySub.set(json).then((value) {
    debugPrint('created new event log');
  }).catchError((e) {
    debugPrint('error create event log: $e');
  });
}

Future getIDFromListEventLog(name, number) async {
  late final String? myID;
  final firestore = FirebaseFirestore.instance;
  final QuerySnapshot queryMain = await firestore.collection('/eventLog').get();
  queryMain.docs.forEach((value) {
    if (value.get('number') == number && value.get('name') == name) {
      myID = value.id.toString();
    }
  });
  return myID;
}

Future getIDFromListUser(name, number) async {
  late final String? myID;
  final firestore = FirebaseFirestore.instance;
  final QuerySnapshot queryMain = await firestore.collection('/user').get();
  queryMain.docs.forEach((value) {
    if (value.get('number') == number && value.get('name') == name) {
      myID = value.id.toString();
    }
  });
  return myID;
}

Future getListEventLogbyDate(name, number, date) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<EventItem> eventLogList = [];
  late final String? myId;
  await getIDFromListEventLog(name, number).then((value) => myId = value);
  // print('myid: $myId');
  final QuerySnapshot querySub = await firestore
      .collection('/eventLog/$myId/$date')
      .orderBy('time', descending: false)
      // .collection('/eventLog/$myId/2022-06-08')
      .get();
  querySub.docs.forEach((value) {
    EventItem item = EventItem.fromJson(value.data() as Map<String, dynamic>);
    eventLogList.add(item);
    // print(value.data());
  });
  return eventLogList;
}

Future getListEventLogbyDateALLUSER(date, group, role) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<EventItem> eventLogList = [];
  late final String? myId;
  // await getIDFromListEventLog(name, number).then((value) => myId = value);
  await getManagerOfGroup(groupName: group, role: role)
      .then((value) => myId = value);
  print('myid: $myId');
  final QuerySnapshot querySub = await firestore
      .collection('/eventLog/$myId/$date')
      .orderBy('time', descending: false)
      // .collection('/eventLog/$myId/2022-06-08')
      .get();
  querySub.docs.forEach((value) {
    EventItem item = EventItem.fromJson(value.data() as Map<String, dynamic>);
    eventLogList.add(item);
    // print(value.data());
  });
  return eventLogList;
}

Future getListNotification({name, id}) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<NotificationItem> notifList = [];
  final QuerySnapshot querySub = await firestore
      .collection('/user/$id/notification')
      .orderBy('created', descending: false)
      .get();
  querySub.docs.forEach((value) {
    NotificationItem item =
        NotificationItem.fromJson(value.data() as Map<String, dynamic>);
    notifList.add(item);
  });
  return notifList;
}

Future getAllRoster({id}) async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<String> notifList = [];
  final QuerySnapshot querySub =
      await firestore.collection('/user/$id/roster').get();
  querySub.docs.forEach((value) {});
  return notifList;
}

Future createNotificationItem({
		hasAlert = true, 
		context,
  myID,
  body,
  created,
  userID,
  type,
  from,
  to,
  actionResult,
  isAction = false,
  dateItem,
  shiftNewItem,
  userName,
  shiftOldItem,
  itemID,
}) async {
  final firestore = FirebaseFirestore.instance;
  final querySub = await firestore.collection('/user/$myID/notification').doc();
  final model = NotificationItem(
      itemID: itemID,
      userName: userName,
      userID: userID,
      body: NotificationItemBody(
          body: body,
          date: dateItem,
          shiftNew: shiftNewItem,
          shiftOld: shiftOldItem),
      created: created,
      type: type,
      from: from,
      to: to,
      actionResult: actionResult,
      isAction: isAction);
  final json = model.toJson();
  await querySub.set(json).then((value) {
    debugPrint('created new notification ');
    if(hasAlert == true){
					kIsWeb ? ScaffoldMessenger.of(context).showSnackBar(mysnackBar(MyString.notification_create_successfull)) :  showToast(MyString.notification_create_successfull);
				}
  }).catchError((e) {
    // showToastError(MyString.notification_create_unsuccessfull);
  });
}

///uopdate notification
Future updateNotificationItem({
  body,
  created,
  type,
  from,
  to,
  actionResult,
  isAction = false,
  dateItem,
  shiftNewItem,
  shiftOldItem,
  myID,
  userName,
  itemID,
  // name,number
}) async {
  final firestore = FirebaseFirestore.instance;
  // await getIDFromListUser(name, number).then((value) => myID = value);
  final querySub = await firestore.collection('/user/$myID/notification').doc();
  // final querySub = await firestore.collection('/user/jOPH95QJqev5Pqow2Nrs/notification').doc();
  final model = NotificationItem(
      itemID: itemID,
      userName: userName,
      body: NotificationItemBody(
          body: body,
          date: dateItem,
          shiftNew: shiftNewItem,
          shiftOld: shiftOldItem),
      created: created,
      type: type,
      from: from,
      userID: myID,
      to: to,
      actionResult: actionResult,
      isAction: isAction);
  final json = model.toJson();
  await querySub
      .set(
    json,
    // SetOptions(merge: true)
  ).then((value) {
    debugPrint('request was sent successully');
    // showToast(MyString.request_sent_success);
  }).catchError((e) {
    // showToastError(MyString.request_sent_unsuccess);
  });
}

///uopdate notification
// Future removeNotification(){

// }

Future declineNotificationRequest(
    {body,
    created,
    type,
    itemID,
    from,
    to,
    actionResult,
    isAction = false,
    dateItem,
    shiftNewItem,
    shiftOldItem,
    myID,
    userName
    // name,number
    }) async {
  final firestore = FirebaseFirestore.instance;
  // await getIDFromListUser(name, number).then((value) => myID = value);
  final querySub = await firestore.collection('/user/$myID/notification').doc();
  // final querySub = await firestore.collection('/user/jOPH95QJqev5Pqow2Nrs/notification').doc();
  final model = NotificationItem(
      itemID: itemID,
      userName: userName,
      body: NotificationItemBody(
          body: body,
          date: dateItem,
          shiftNew: shiftNewItem,
          shiftOld: shiftOldItem),
      created: created,
      type: type,
      from: from,
      userID: myID,
      to: to,
      actionResult: actionResult,
      isAction: isAction);
  final json = model.toJson();
  await querySub.set(json, SetOptions(merge: true)).then((value) {
    debugPrint('request was sent successully');
    // showToast(MyString.request_sent_success_Decline);
  }).catchError((e) {
    // showToastError(MyString.request_sent_unsuccess);
  });
}

Future removeNotification({id, myID}) async {
  debugPrint('run delete noti with this id: $id');
  final firestore = FirebaseFirestore.instance;
  // await getIDFromListUser(name, number).then((value) => myID = value);
  final querySub = await firestore
      .collection('/user/$myID/notification')
      .where('itemID', isEqualTo: id)
      .get();
  querySub.docs.forEach((element) {
    element.reference
        .delete()
        .then((value) => debugPrint('request was deleted '));
  });
}

Future removeNotificationUser({myID}) async {
  final firestore = FirebaseFirestore.instance;
  final querySub = await firestore
      .collection('/user/$myID/notification')
      .where('userID', isEqualTo: myID)
      .get();
  querySub.docs.forEach((element) {
    element.reference
        .delete()
        .then((value) => debugPrint('request was deleted '));
  });
}

//ROSTER TIME DATE
Future getAllRosterDate() async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<RosterDateItem> rosterDate = [];
  final QuerySnapshot queryMain =
      await firestore.collection('rosterDateTime').get();
  queryMain.docs.forEach((value) {
    RosterDateItem item =
        RosterDateItem.fromJson(value.data() as Map<String, dynamic>);
    rosterDate.add(item);
  });
  return rosterDate;
}

//ROSTER TIME DATE
Future getAllRosterDate_() async {
  final firestore = FirebaseFirestore.instance;
  final stringFormat = StringFormat();
  List<RosterDate> rosterDate = [];
  final QuerySnapshot queryMain = await firestore
      .collection('rosterDate')
      .orderBy('date', descending: false)
      .get();
  queryMain.docs.forEach((value) {
    print(value.data());
    RosterDate item = RosterDate.fromJson(value.data() as Map<String, dynamic>);
    rosterDate.add(item);
  });
  return rosterDate;
}

//GET ROSTER DATE FROM DATE
Future getRosterDateFromByDate({id, date}) async {
  // debugPrint('go to detail view roster date');
  final firestore = FirebaseFirestore.instance;
  List<Shift> rosterDate = [];
  final QuerySnapshot queryMain = await firestore
      .collection('/user/$id/$date')
      .orderBy('date', descending: false)
      .get();
  queryMain.docs.forEach((value) {
    Shift item = Shift.fromJson(value.data() as Map<String, dynamic>);
    rosterDate.add(item);
  });
  return rosterDate;
}
