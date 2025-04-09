import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/editUser/editUserContainer.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/notification/item_notification.dart';
import 'package:vegas_roster/Screen/roster/roster_all.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

final stringFormat = StringFormat();
Widget itemDateChild({
  itemWidth,
  text,
  isItemShift = false,
  isManager = false,
  hasGroup = false,
  String textGroup = '',
  isToday = false,
  textStr,
  color = '0xFFE0E0E0',
}) {
  return Stack(
    children: [
      Container(
          alignment: Alignment.center,
          width: itemWidth,
          decoration: BoxDecoration(
              color: isItemShift
                  ? MyColor.white
                  : isToday == true
                      ? MyColor.orange
                      : (textStr == "Sat" || textStr == "Sun")
                          ? MyColor.black_text.withOpacity(0.25)
                          : MyColor.white,
              border: Border.all(color: Colors.grey, width: 0.5)),
          child: Text(
            text,
            style: TextStyle(
                fontSize: 10,
                fontWeight:
                    isManager == true ? FontWeight.bold : FontWeight.normal),
            textAlign: TextAlign.center,
          )),
      hasGroup == true
          ? Positioned(
                  left: 0,
                  child: Container(
                    width: 3.5,
                    height: 30,
                    decoration: BoxDecoration(
                      color: Color(int.parse(color))
                    ),
                  ),
                )
          // Positioned(
          //     left: 0,
          //     child: Container(
          //       width: 3.5,
          //       height: 30,
          //       decoration: BoxDecoration(
          //         color: textGroup.toLowerCase() == 'it technical'
          //             ? MyColor.blue
          //             : textGroup.toLowerCase() == 'security'
          //                 ? MyColor.green
          //                 : MyColor.white,
          //       ),
          //     ),
          //   )
          : Container()
    ],
  );
}

Widget itemDateChildWithDate({
  itemWidth,
  String? text,
  isItemShift = false,
  textStr,
  textDate,
}) {
  return Container(
      alignment: Alignment.center,
      width: itemWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: isItemShift
              ? MyColor.white
              : (textStr == "Sat" || textStr == "Sun")
                  ? MyColor.black_text.withOpacity(0.25)
                  : MyColor.white,
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            text!,
            style: TextStyle(
                color: text[0].toUpperCase() == "A"
                    ? MyColor.blue
                    : text[0].toUpperCase() == "B"
                        ? MyColor.green
                        : text[0].toUpperCase() == "C"
                            ? MyColor.red_accent
                            : text.toUpperCase() == "OFF"
                                ? MyColor.yellow
                                : MyColor.black_text,
                fontSize: 12,
                fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 5),
          Text(
            textDate,
            style: TextStyle(fontSize: 9.5, color: MyColor.black_text),
          )
        ],
      ));
}

Widget itemDateChildWithDateROW({
  itemWidth,
  String? text,
  isPassDay = false,
  isToday = false,
  textStr,
  textDate,
}) {
  return Container(
      padding: const EdgeInsets.all(5),
      alignment: Alignment.center,
      width: itemWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(2.5),
          color: isPassDay == false ? MyColor.white : MyColor.grey_tab,
          border: Border.all(
              color: isToday == true ? MyColor.red : Colors.grey,
              width: isToday == true ? 1 : 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: itemWidth / 4,
            alignment: Alignment.center,
            child: Text(
              text!,
              style: TextStyle(
                  color: text[0].toUpperCase() == "A"
                      ? MyColor.blue
                      : text[0].toUpperCase() == "B"
                          ? MyColor.green
                          : text[0].toUpperCase() == "C"
                              ? MyColor.red_accent
                              : text.toUpperCase() == "OFF"
                                  ? MyColor.yellow
                                  : MyColor.black_text,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 25),
          Expanded(
            child: Text(
              textDate,
              style: TextStyle(fontSize: 12, color: MyColor.black_text),
            ),
          )
        ],
      ));
}

Widget itemDateChildColor({itemWidth, text, color, hasChild = false}) {
  return Container(
      alignment: Alignment.center,
      width: itemWidth,
      decoration: BoxDecoration(
          color: color, border: Border.all(color: Colors.grey, width: 0.5)),
      child: Text(
        text,
        style: const TextStyle(fontSize: 9.5),
        textAlign: TextAlign.center,
      ));
}

Widget buildShiftRowByStream(width, height, itemWidth, userList) {
  return StreamBuilder<QuerySnapshot>(
    // stream: stream,
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: myprogresscircular());
      } else if (snapshot.connectionState == ConnectionState.done) {
        debugPrint('reload data');
      }

      return SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          itemCount: userList.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  child: itemDateChild(
                      itemWidth: itemWidth * 2,
                      text: userList[index].name,
                      isItemShift: true),
                ),
                Expanded(
                  child: Container(
                    height: 25,
                    color: MyColor.grey_tab,
                    width: itemWidth * 14,
                    child: ListView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.all(0),
                      scrollDirection: Axis.horizontal,
                      itemCount: userList[index].shift.length < 14
                          ? 14
                          : userList[index].shift[index].shiftName.length,
                      itemBuilder: (context, index) {
                        return itemDateChild(
                            itemWidth: itemWidth, isItemShift: true, text: '');
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget buildShiftRow(
  width,
  height,
  itemWidth,
  List<User> userList,
  listDate,
) {
  return StreamBuilder<QuerySnapshot>(
    stream: FirebaseFirestore.instance
        .collection('user')
        .snapshots()
        .asBroadcastStream(),
    builder: (context, snapshot) {
      Stream<QuerySnapshot> stream =
          FirebaseFirestore.instance.collection('user').snapshots();
      stream.forEach((event) {
        event.docs.asMap().forEach((key, value) {
          // debugPrint('${value.data()}');
          User userModel = User.fromJson(value.data() as Map<String, dynamic>);
          userList.add(userModel);
        });
      });

      if (!snapshot.hasData) {
        return Center(child: myprogresscircular());
      }
      return SizedBox(
        height: height,
        width: width,
        child: ListView.builder(
          shrinkWrap: true,
          padding: const EdgeInsets.all(0),
          scrollDirection: Axis.vertical,
          itemCount: userList.length,
          itemBuilder: (context, index) {
            final myShift = userList[index].shift;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 25,
                  child: itemDateChild(
                      itemWidth: itemWidth * 2,
                      text: '${userList[index].name}',
                      isItemShift: true),
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                        color: MyColor.grey_tab,
                        border: Border.all(width: 0.25, color: MyColor.grey)),
                    height: 25,
                    width: itemWidth * 14,
                    child: Stack(
                      children: [
                        ...myShift.map((e) {
                          int differentInDays =
                              e.date.toDate().difference(listDate.first).inDays;
                          debugPrint(
                              'days different: ${differentInDays.toString()}');
                          if (differentInDays >= 0) {
                            return Positioned(
                              left: itemWidth * differentInDays,
                              top: 0,
                              bottom: 0,
                              child: itemDateChildColor(
                                itemWidth: itemWidth,
                                // color:e.shiftName.toUpperCase()=='OFF' ? MyColor.yellow : MyColor.white,
                                color: e.shiftName == 'OFF'
                                    ? MyColor.yellow
                                    : e.shiftName[0].toUpperCase() == "A"
                                        ? MyColor.blue.withOpacity(0.35)
                                        : e.shiftName[0].toUpperCase() == 'B'
                                            ? MyColor.green.withOpacity(0.35)
                                            : e.shiftName[0].toUpperCase() ==
                                                    'C'
                                                ? MyColor.red.withOpacity(0.35)
                                                : MyColor.white,
                                text: e.shiftName,
                              ),
                            );
                          }
                          return const SizedBox();
                        })
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      );
    },
  );
}

Widget buildShiftRowFuture(
    width,
    height,
    itemWidth,
    onPress,
    List<DateTime> listDate,
    String? searchKey,
    clickableDialog,
    bool? isSearch,
    Function onPressButton,
    startDateRoster) {
  late String? userRoleFromSave = '';
  late String? userGroupFromSave = '';

  return FutureBuilder(
    future: isSearch == false ? addDataToList() : getSearchGroup(searchKey),
    builder: (context, snapshot) {
      late final userList = snapshot.data as List<User>;
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(child: myprogresscircular());
      }
      if (!snapshot.hasData) {
        return Center(child: myprogresscircular());
      }
      return userList.isEmpty
          ? Expanded(
              child: Center(
                  child: textWithColorBox(
                      textCustom(MyString.roster_nostaff, 12))))
          : SizedBox(
              height: height,
              width: width,
              child: ListView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                itemCount: userList.length,
                itemBuilder: (context, index) {
                  final myShift = userList[index].shift;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          debugPrint('click detail: ${userList[index].name}');
                          getUserDataSave().then(
                            (value) {
                              final UserSave userSave = value;
                              userRoleFromSave = userSave.role;
                              userGroupFromSave = userSave.group;
                            },
                          );
                          debugPrint('click detaiil save: ${userRoleFromSave} $userGroupFromSave ${userList[index].id}');
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return dialogAlertBody(
                                  hasRequestBtn: true,
                                  textButton2: MyString.viewAllBtn,
                                  functionRequest: () {
                                    debugPrint('click view all ');
                                    debugPrint(
                                        'item view all id : ${userList[index].id} ');
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (_) => RosterAll(
                                                id: userList[index].id)));
                                  },
                                  context: context,
                                  height: height + 250,
                                  width: width,
                                  onPress: () {},
                                  isTitleWidget: true,
                                  widgetTitle: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      const Text('Detail work shift'),
                                      (userRoleFromSave!.toLowerCase() ==
                                                  'manager' &&
                                              userGroupFromSave!
                                                      .toLowerCase() ==
                                                  userList[index]
                                                      .group
                                                      .toLowerCase())
                                          ? TextButton(
                                              onPressed: () {
                                                debugPrint(
                                                    'click edit work shift detail infor 2');
                                                debugPrint(
                                                    '${userList[index].name} ${userList[index].vietnameseName} ${userList[index].group} ${userList[index].number}');
                                                Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                  builder: (context) =>
                                                      EditUserContainer(
                                                    initIndex: 1,
                                                    name: userList[index].name,
                                                    vietnameseName:
                                                        userList[index]
                                                            .vietnameseName,
                                                    number:
                                                        userList[index].number,
                                                    id: userList[index].id,
                                                    group:
                                                        userList[index].group,
                                                  ),
                                                ));
                                              },
                                              child: const Text('EDIT'))
                                          : const SizedBox(),
                                    ],
                                  ),
                                  widget: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: width,
                                        child: Wrap(
                                          crossAxisAlignment:
                                              WrapCrossAlignment.center,
                                          children: [
                                            Container(
                                                padding:
                                                    const EdgeInsets.all(2.5),
                                                color: MyColor.grey_tab,
                                                child: textCustom(
                                                    '${userList[index].number}',
                                                    11)),
                                            const SizedBox(width: 5),
                                            textCustom(
                                                '${userList[index].name}', 11),
                                            const SizedBox(width: 5),
                                            textCustomColor(
                                                '(${userList[index].vietnameseName})',
                                                12,
                                                MyColor.grey),
                                            const SizedBox(width: 5),
                                            textCustomColor(
                                                '(${userList[index].group})',
                                                12,
                                                MyColor.grey),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 2.5),
                                      Expanded(
                                          child: FutureBuilder(
                                        future: getRosterDateFromByDate(
                                            id: userList[index].id,
                                            date: startDateRoster),
                                        builder: (context, snapshot) {
                                          late final item =
                                              snapshot.data as List<Shift>;
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child: myprogresscircular());
                                          }
                                          if (!snapshot.hasData ||
                                              snapshot.hasError) {
                                            return Center(
                                                child: textWithColorBox(
                                                    textCustom(
                                                        MyString
                                                            .rosterviewall_error,
                                                        12)));
                                          }
                                          return item.isNotEmpty
                                              ? ListView.builder(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  itemCount: item.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    return GestureDetector(
                                                      onTap: () {
                                                        debugPrint(
                                                            'view detail');
                                                      },
                                                      child: itemNotification(
                                                        isToday: stringFormat
                                                                    .formatDate(item[
                                                                            index]
                                                                        .date
                                                                        .toDate()) ==
                                                                stringFormat
                                                                    .formatDate(
                                                                        DateTime
                                                                            .now())
                                                            ? true
                                                            : false,
                                                        isPassDay: false,
                                                        // isPassDay: item[index].date.toDate().difference(DateTime.now()).inDays.abs() > 0  ? true : false,
                                                        verticalPadding: 10.0,
                                                        index: (index + 1)
                                                            .toString(),
                                                        isEnable: false,
                                                        isSeen: false,
                                                        itemWidth: width,
                                                        onPress: () {
                                                          debugPrint(
                                                              'onpress something');
                                                        },
                                                        item: const Icon(Icons
                                                            .arrow_forward_ios),
                                                        text:
                                                            '${item[index].shiftName}   --   ${stringFormat.formatDateWithSplashFULL(item[index].date.toDate())}',
                                                        textDate: "",
                                                      ),
                                                    );
                                                  },
                                                )
                                              : Center(
                                                  child: textWithColorBox(
                                                      textCustom(
                                                          MyString
                                                              .viewall_roster_nodate,
                                                          14)));
                                        },
                                      )

                                          // ListView.builder(
                                          //   itemCount: myShift.length,
                                          //   itemBuilder: (context, index) {
                                          //     return Padding(
                                          //         padding:
                                          //             const EdgeInsets.all(1.25),
                                          //         child: myShift[index]
                                          //                         .shiftName ==
                                          //                     "" ||
                                          //                 myShift[index]
                                          //                         .date
                                          //                         .toDate()
                                          //                         .difference(
                                          //                             DateTime
                                          //                                 .now())
                                          //                         .inDays
                                          //                         .abs() >=
                                          //                     14
                                          //             ? const SizedBox(
                                          //                 height: 0, width: 0)
                                          //             : itemDateChildWithDateROW(
                                          //                 isToday: stringFormat
                                          //                             .formatDate(myShift[
                                          //                                     index]
                                          //                                 .date
                                          //                                 .toDate()) ==
                                          //                         stringFormat
                                          //                             .formatDate(
                                          //                                 DateTime
                                          //                                     .now())
                                          //                     ? true
                                          //                     : false,
                                          //                 isPassDay: myShift[
                                          //                                 index]
                                          //                             .date
                                          //                             .toDate()
                                          //                             .difference(
                                          //                                 DateTime
                                          //                                     .now())
                                          //                             .inDays <
                                          //                         0
                                          //                     ? true
                                          //                     : false,
                                          //                 textDate:
                                          //                     '${stringFormat.formatDateWithSplashFULL(myShift[index].date.toDate())}',
                                          //                 itemWidth: width,
                                          //                 text: myShift[index]
                                          //                     .shiftName,
                                          //               ));
                                          //   },
                                          // ),
                                          )
                                    ],
                                  ));
                            },
                          );
                        },
                        child: SizedBox(
                          height: 25,
                          child: itemDateChild(
                              textGroup: userList[index].group,
                              hasGroup: true,
                              itemWidth: itemWidth * 2,
                              isManager: userList[index].role.toLowerCase() ==
                                      'manager'
                                  ? true
                                  : false,
                              text: '${userList[index].name}',
                              isItemShift: true),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 25,
                          decoration: BoxDecoration(
                              color: MyColor.white,
                              border: Border.all(
                                  width: 0.25, color: MyColor.grey_tab)),
                          width: itemWidth * 14,
                          child: Stack(
                            children: [
                              ...myShift.map((e) {
                                int differentInDays = e.date
                                    .toDate()
                                    .difference(listDate.first)
                                    .inDays;
                                if (myShift.isNotEmpty) {
                                  if (differentInDays >= 0) {
                                    return Positioned(
                                      left: (itemWidth * differentInDays),
                                      top: 0,
                                      bottom: 0,
                                      child: itemDateChildColor(
                                        itemWidth: itemWidth,
                                        color: e.shiftName == 'OFF'
                                            ? MyColor.yellow
                                            : e.shiftName[0].toUpperCase() ==
                                                    "A"
                                                ? MyColor.blue.withOpacity(0.35)
                                                : e.shiftName[0]
                                                            .toUpperCase() ==
                                                        'B'
                                                    ? MyColor.green
                                                        .withOpacity(0.35)
                                                    : e.shiftName[0]
                                                                .toUpperCase() ==
                                                            'C'
                                                        ? MyColor.red
                                                            .withOpacity(0.35)
                                                        : MyColor.white,
                                        text: e.shiftName.toUpperCase(),
                                      ),
                                    );
                                  }
                                }
                                return const SizedBox();
                              })
                            ],
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            );
    },
  );
}

// Widget buildShiftRowFutureSearch(width, height, itemWidth,
//     List<User> userListSearch, List<DateTime> listDate, searchKey) {
//   return FutureBuilder(
//     future: searchFuntion(userListSearch,searchKey),
//     builder: (context, snapshot) {
//       if (snapshot.connectionState == ConnectionState.waiting) {
//         return Center(child: myprogresscircular());
//       }
//       if (!snapshot.hasData) {
//         return Center(child: textCustom(MyString.roster_nostaff, 12));
//       }
//       return SizedBox(
//         height: height,
//         width: width,
//         child: ListView.builder(
//           shrinkWrap: true,
//           padding: const EdgeInsets.all(0),
//           scrollDirection: Axis.vertical,
//           itemCount: userListSearch.length,
//           itemBuilder: (context, index) {
//             final myShift = userListSearch[index].shift;
//             return Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     debugPrint('click detaiil2: ${userListSearch[index].name}');
//                     showDialog(
//                       context: context,
//                       builder: (BuildContext context) {
//                         return dialogAlertBody(
//                             context: context,
//                             height: height,
//                             width: width,
//                             onPress: () {},
//                             isTitleWidget: true,
//                             title: "Detail work shift",
//                             widget: Column(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               crossAxisAlignment: CrossAxisAlignment.center,
//                               children: [
//                                 SizedBox(
//                                   width: width,
//                                   child: Wrap(
//                                     children: [
//                                       Container(
//                                           padding: const EdgeInsets.all(2.5),
//                                           color: MyColor.grey_tab,
//                                           child: textCustom(
//                                               '${userListSearch[index].number}',
//                                               11)),
//                                       const SizedBox(width: 5),
//                                       textCustom(
//                                           '${userListSearch[index].name}', 14),
//                                       const SizedBox(width: 5),
//                                       textCustomColor(
//                                           '(${userListSearch[index].vietnameseName})',
//                                           12,
//                                           MyColor.grey),
//                                       const SizedBox(width: 5),
//                                       textCustomColor(
//                                           '(${userListSearch[index].group})',
//                                           12,
//                                           MyColor.grey),
//                                     ],
//                                   ),
//                                 ),
//                                 const SizedBox(height: 7.5),
//                                 GridView.builder(
//                                     shrinkWrap: true,
//                                     itemCount: myShift.length,
//                                     gridDelegate:
//                                         const SliverGridDelegateWithFixedCrossAxisCount(
//                                       crossAxisCount: 5,
//                                       childAspectRatio: 1,
//                                     ),
//                                     itemBuilder: (context, index) {
//                                       return Padding(
//                                         padding: const EdgeInsets.all(1.25),
//                                         child: itemDateChildWithDate(
//                                           isItemShift: true,
//                                           textDate:
//                                               '${stringFormat.formatDateWithSplash(myShift[index].date.toDate())}',
//                                           itemWidth: itemWidth,
//                                           text: myShift[index].shiftName,
//                                         ),
//                                       );
//                                     })
//                               ],
//                             ));
//                       },
//                     );
//                   },
//                   child: SizedBox(
//                     height: 25,
//                     child: itemDateChild(
//                         itemWidth: itemWidth * 2,
//                         text: '${userListSearch[index].name}',
//                         isItemShift: true),
//                   ),
//                 ),
//                 Expanded(
//                   child: Container(
//                     height: 25,
//                     decoration: BoxDecoration(
//                         color: MyColor.white,
//                         border:
//                             Border.all(width: 0.25, color: MyColor.grey_tab)),
//                     width: itemWidth * 14,
//                     child: Stack(
//                       children: [
//                         ...myShift.map((e) {
//                           int differentInDays = e.date
//                               .toDate()
//                               .difference(DateTime(2022, 05, 16))
//                               .inDays;
//                           if (myShift.isNotEmpty) {
//                             if (differentInDays >= 0) {
//                               return Positioned(
//                                 left: (itemWidth * differentInDays),
//                                 top: 0,
//                                 bottom: 0,
//                                 child: GestureDetector(
//                                   onTap: () {},
//                                   child: itemDateChildColor(
//                                     itemWidth: itemWidth,
//                                     color: e.shiftName == 'OFF'
//                                         ? MyColor.yellow
//                                         : e.shiftName[0].toUpperCase() == "A"
//                                             ? MyColor.blue.withOpacity(0.35)
//                                             : e.shiftName[0].toUpperCase() ==
//                                                     'B'
//                                                 ? MyColor.green
//                                                     .withOpacity(0.35)
//                                                 : e.shiftName[0]
//                                                             .toUpperCase() ==
//                                                         'C'
//                                                     ? MyColor.red
//                                                         .withOpacity(0.35)
//                                                     : MyColor.white,
//                                     text: e.shiftName.toUpperCase(),
//                                   ),
//                                 ),
//                               );
//                             }
//                           }
//                           return const SizedBox();
//                         })
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       );
//     },
//   );
// }

Widget buildDateRowFuture(itemWidth, StringFormat stringFormat, width,
    textGroup, isPrevRoster, onPressButton) {
  return SizedBox(
    height: 32.5,
    width: width,
    child: Row(
      children: [
        itemDateChildColor(itemWidth: itemWidth * 2, text: textGroup, color: MyColor.grey_tab),
        FutureBuilder(
          future: isPrevRoster == false ? getListDate() : getListDatePrev(),
          builder: (context, snapshot) {
            late final listDate = snapshot.data as List<DateTime>;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox(
															width:25,height:25,
															child: myprogresscircularSmall());
            } else if (snapshot.hasError) {
              return Expanded( child: Center(child: textCustom(MyString.roster_error, 11)));
            }
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: listDate.length > 14 ? 14 : listDate.length,
              itemBuilder: (context, index) {
                return itemDateChild(
                    isToday: stringFormat.formatDate(listDate[index]) ==
                            stringFormat.formatDate(DateTime.now())
                        ? true
                        : false,
                    textStr: stringFormat.formatDateOnlyDayDD(listDate[index]),
                    itemWidth: itemWidth,
                    text:
                        '${stringFormat.formatDateOnlyDayText2(listDate[index])} ${stringFormat.formatDateOnlyDay(listDate[index])}');
              },
            );
          },
        )
      ],
    ),
  );
}

Widget buildDateRow(
    itemWidth, listDate, StringFormat stringFormat, width, textGroup) {
  return SizedBox(
    height: 35,
    width: width,
    child: Row(
      children: [
        itemDateChildColor(
            itemWidth: itemWidth * 2, text: textGroup, color: MyColor.grey_tab),
        // Container(width:itemWidth*2),
        FutureBuilder(
          future: getDaysInBetweenFromServer(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                  width: 15,
                  height: 15,
                  alignment: Alignment.center,
                  child: myprogresscircular());
            } else if (snapshot.hasError) {
              return SizedBox(
                  width: 15,
                  height: 15,
                  child: Center(child: textCustom('an error orcur', 11)));
            }
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: listDate.length > 14 ? 14 : listDate.length,
              itemBuilder: (context, index) {
                return itemDateChild(
                    textStr: stringFormat.formatDateOnlyDayDD(listDate[index]),
                    itemWidth: itemWidth,
                    text:
                        '${stringFormat.formatDateOnlyDayText2(listDate[index])} ${stringFormat.formatDateOnlyDay(listDate[index])}');
              },
            );
          },
        )
      ],
    ),
  );
}
