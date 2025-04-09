import 'dart:convert';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/model/user.dart';
// import 'package:get/get.dart';

class MyFunction {}

// final controller = Get.put(MyGetXController());
final stringFormat = StringFormat();
turnOffKeyBoard(context) {
  FocusScopeNode currentFocus = FocusScope.of(context);
  currentFocus.unfocus();
}

// Future createNewUser(
//     {collectionName,
//     name,
//     vietnameseName,
//     number,
//     password,
//     gender,
//     birthday,
//     role,
//     group}) async {
//   log('create user');
//   final docs = FirebaseFirestore.instance.collection(collectionName).doc();
//   final user = User(
//     id: docs.id,
//     name: name,
//     vietnameseName: vietnameseName,
//     number: number,
//     gender: gender,
//     birthday: birthday,
//     group: group,
//     role: role,
//     password: password,

//   );
//   final json = user.toJson();
//   await docs.set(json).then((value) {
//     debugPrint('successfull');
//     // controller.addSuccess();
//   }).catchError((error) {
//     debugPrint('un--successfull');
//   });
// }

castListDateToString(List<DateTime> listDate) {
  final List<String> myListString = [];
  for (final element in listDate) {
    myListString.add(element.toString());
  }
  return myListString;
}

castListStringToDate(List<String> listString) {
  final List<DateTime> myListDate = [];
  for (final element in listString) {
    myListDate.add(DateTime.parse(element));
    // debugPrint(stringFormat.formatDate(DateTime.parse(element)));
  }
  return myListDate;
}

saveListDate(List<String> listDate) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList('listDate', listDate);
}
saveListDatePrev(List<String> listDate) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setStringList('listDatePrev', listDate);
}

Future getListDate() async {
  debugPrint('init getListDate');
  SharedPreferences pref = await SharedPreferences.getInstance();
  final result = pref.getStringList('listDate');
  final List<DateTime> myListDate = castListStringToDate(result!);
  return myListDate;
}
Future getListDatePrev() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  final result = pref.getStringList('listDatePrev');
  final List<DateTime> myListDate = castListStringToDate(result!);
  return myListDate;
}

Future getUserDataSave() async {
  // debugPrint('init getUserData');
  SharedPreferences pref = await SharedPreferences.getInstance();
  final json = jsonDecode(pref.getString("userData") ?? "");
  final UserSave user = UserSave.fromJson(json);
  // debugPrint(user.name.toString());
  return user;
}
Future getCheckBoxSave() async {
  // debugPrint('init checkboxSave');
  SharedPreferences pref = await SharedPreferences.getInstance();
  final result = (pref.getBool("checkBox") ?? false);
  // debugPrint('result checkbox: $result');
  return result;
}
  saveCheckBoxForAuthentication(checkBoxValue) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.setBool('checkBox', checkBoxValue);
  }

  clearCheckBoxForAuthentication() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('checkBox');
  }
  clearUserSave() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    pref.remove('userData');
  }