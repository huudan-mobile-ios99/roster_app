import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../model/user.dart';
   List<String> listShift = [
    'A',
    'A1',
    'A2',
    'A3',
    'A4',
    'B',
    'B1',
    'C',
    'C1',
    'C2'
  ];
Future getData(userList) async {
    final firestore = FirebaseFirestore.instance;
    QuerySnapshot query = await firestore.collection('user').get();
    debugPrint('size: ${query.size.toString()}');
    query.docs.forEach((element) {
      User user = User.fromJson(element.data() as Map<String, dynamic>);
      userList?.add(user);
    });
    return userList;
  }

  Future getSearchResultData_() async {
    final List<User> userList = [];
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final today1 = DateTime(now.year, now.month, now.day);
    for (final element in listShift) {
      final QuerySnapshot queryA = await firestore.collection('user').where(
        'shift',
        arrayContains: {
          'date': today1,
          'shiftName': element,
        },
      ).get();
      // debugPrint('query size: ${queryA.size}');
      for (final element in queryA.docs) {
        User user = User.fromJson(element.data() as Map<String, dynamic>);
        userList.add(user);
      }
    }
    debugPrint('getSearchResultData_: ${userList.length}');
    userList.forEach((element) {
      debugPrint('item: ${element.name}');
    });
    return userList.toSet().toList() as List<User>;
  }

  Future getSearchResultDataFilter(keyword,userListFilter) async {
    final firestore = FirebaseFirestore.instance;
    final now = DateTime.now();
    final today1 = DateTime(now.year, now.month, now.day);
    for (final element in listShift) {
      final QuerySnapshot queryA = await firestore
          .collection('user')
          .where(
            'shift',
            arrayContains: {
              'date': today1,
              'shiftName': element,
            },
          )
          .orderBy('name')
          .get();
      for (final element in queryA.docs) {
        User user = User.fromJson(element.data() as Map<String, dynamic>);
        userListFilter?.add(user);
      }
    }

    return userListFilter?.toSet().toList();
  }