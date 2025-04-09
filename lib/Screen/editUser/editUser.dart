// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:vegas_roster/APIs/service_apis.dart';
// import 'package:vegas_roster/Model/day.dart';
// import 'package:vegas_roster/Model/shift.dart';
// import 'package:vegas_roster/Model/user.dart';
// import 'package:vegas_roster/Screen/home.dart';
// import 'package:vegas_roster/Screen/roster.dart';
// import 'package:vegas_roster/Util/color.dart';
// import 'package:vegas_roster/Util/function_date_edit.dart';
// import 'package:vegas_roster/Util/string_date_format.dart';
// import 'package:vegas_roster/Widget/dialog.dart';
// import 'package:vegas_roster/Widget/progresscircular.dart';
// import 'package:vegas_roster/Widget/text.dart';

// class EditUserShift extends StatefulWidget {
//   String? name, number, vietnameseName, group, id;
//   EditUserShift(
//       {this.name, this.number, this.vietnameseName, this.group, this.id});
//   @override
//   State<EditUserShift> createState() => _EditUserShiftState();
// }

// class _EditUserShiftState extends State<EditUserShift> {
//   List<DayM> listDays = [
//     DayM(1, DateTime(2000, 01, 01), false, false, '', 'grey')
//   ];
//   final List<ShiftM> listWorkShift = [
//     ShiftM(1, 'A', '6:00-14:00', 'A', false),
//     ShiftM(2, 'A1', '10:00-18:00', 'A', false),
//     ShiftM(3, 'A2', '12:00-20:00', 'A', false),
//     ShiftM(4, 'A3', '8:00-16:00', 'A', false),
//     ShiftM(5, 'A4', '9:00-17:00', 'A', false),
//     ShiftM(6, 'B', '14:00-22:00', 'B', false),
//     ShiftM(7, 'B1', '16:00-24:00', 'B', false),
//     ShiftM(8, 'C', '22:00-6:00', 'C', false),
//     ShiftM(9, 'C1', '20:00-4:00', 'C', false),
//     ShiftM(10, 'C2', '18:00-2:00', 'C', false),
//     ShiftM(11, 'OFF', '', 'OFF', false),
//     ShiftM(12, 'Si', 'sick leave', '', false),
//     ShiftM(13, 'An', 'annual leave', '', false),
//     ShiftM(14, 'PH', 'public holiday', '', false),
//     ShiftM(15, 'Bi', 'birthday', '', false),
//     // ShiftM(15, 'RESET', '', '', false),
//   ];
//   final stringFormat = StringFormat();
//   User? userModel;
//   @override
//   void initState() {
//     super.initState();
//     getStartDateFromServer().then((value) {
//       generateDateWITHSTART(listDays, value);
//       setState(() {
//         listDays = listDays.toSet().toList();
//       });
//       listDays.removeAt(0);
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SafeArea(
//         maintainBottomViewPadding: true,
//         left: true,
//         bottom: false,
//         right: true,
//         top: true,
//         child: Padding(
//           padding: const EdgeInsets.symmetric(horizontal: 16),
//           child: Column(
//             children: [
//               SizedBox(
//                 width: width,
//                 child: Card(
//                   child: Row(
//                     children: [
//                       IconButton(
//                           onPressed: () {
//                             Navigator.of(context).push(MaterialPageRoute(
//                                 builder: (context) => const HomePage()));
//                           },
//                           icon: const Icon(Icons.arrow_back_ios,
//                               color: Colors.black)),
//                       Wrap(
//                         crossAxisAlignment: WrapCrossAlignment.center,
//                         children: [
//                           Container(
//                               padding: const EdgeInsets.all(2.5),
//                               color: MyColor.grey_tab,
//                               child: textCustom('${widget.number}', 11)),
//                           const SizedBox(width: 5),
//                           textCustom('${widget.name}', 11),
//                           const SizedBox(width: 5),
//                           textCustomColor(
//                               '(${widget.vietnameseName})', 12, MyColor.grey),
//                           const SizedBox(width: 5),
//                           textCustomColor(
//                               '(${widget.group})', 12, MyColor.grey),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 10),
//                 child: Align(
//                     alignment: Alignment.centerLeft,
//                     child: textCustomColor(
//                         'all date from ${stringFormat.formatDateWithSplash(listDays.first.day)} to ${stringFormat.formatDateWithSplash(listDays.last.day)}',
//                         12,
//                         MyColor.black_text)),
//               ),
//               const SizedBox(
//                 height: 5,
//               ),
//               Expanded(
//                 child: StreamBuilder<QuerySnapshot>(
//                   stream: FirebaseFirestore.instance
//                       .collection('user')
//                       .snapshots()
//                       .asBroadcastStream(),
//                   builder: (context, snapshot) {
//                     if (!snapshot.hasData) {
//                       return Center(child: myprogresscircular());
//                     }
//                     //this is important
//                     addShiftNametoList(widget.id);

//                     return SizedBox(
//                       child: GridView.builder(
//                         itemCount: listDays.length,
//                         gridDelegate:
//                             const SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 3,
//                           childAspectRatio: 1,
//                           crossAxisSpacing: 5,
//                           mainAxisSpacing: 5,
//                         ),
//                         itemBuilder: (context, index) {
//                           return GestureDetector(
//                             onTap: () {
//                               debugPrint('ontap $index');
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) {
//                                   return textCustom('text', 12);
//                                 },
//                               );
//                             },
//                             child: Card(
//                                 shadowColor: listDays[index].isWeekDay == true
//                                     ? Colors.blueAccent
//                                     : Colors.grey,
//                                 elevation: 2.5,
//                                 child: ListTile(
//                                     title: Column(
//                                   mainAxisAlignment: MainAxisAlignment.center,
//                                   crossAxisAlignment: CrossAxisAlignment.center,
//                                   children: [
//                                     textCustomColor(
//                                         '${stringFormat.formatDateOnlyDayDDDate(listDays[index].day)}',
//                                         11,
//                                         MyColor.black_text),
//                                     const SizedBox(height: 5),
//                                     listDays[index].text == ''
//                                         ? textCustom('', 16)
//                                         : Container(
//                                             padding: const EdgeInsets.all(7.5),
//                                             decoration: BoxDecoration(
//                                               color: listDays[index].color ==
//                                                       'blue'
//                                                   ? MyColor.blue
//                                                       .withOpacity(0.35)
//                                                   : listDays[index].color ==
//                                                           'green'
//                                                       ? MyColor.green
//                                                           .withOpacity(0.35)
//                                                       : listDays[index].color ==
//                                                               'red'
//                                                           ? MyColor.red
//                                                               .withOpacity(0.35)
//                                                           : listDays[index]
//                                                                       .color ==
//                                                                   'yellow'
//                                                               ? MyColor.yellow
//                                                               : MyColor
//                                                                   .grey_tab,
//                                               // color: MyColor.grey_tab,
//                                               borderRadius:
//                                                   BorderRadius.circular(2.5),
//                                             ),
//                                             child: textCustom(
//                                                 '${listDays[index].text.toUpperCase()}',
//                                                 16),
//                                           )
//                                   ],
//                                 ))),
//                           );
//                         },
//                       ),
//                     );
//                   },
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget dialogDetailBody(width, height, index, dateFromList, shiftName) {
//     return dialogAlertBody(
//         context: context,
//         width: width,
//         height: height,
//         widget: SizedBox(
//           width: width,
//           height: height,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             mainAxisAlignment: MainAxisAlignment.start,
//             children: [
//               textCustom('Choose work shift for this date', 12),
//               Expanded(
//                   flex: 1,
//                   child: GridView.builder(
//                       itemCount: listWorkShift.length,
//                       gridDelegate:
//                           const SliverGridDelegateWithFixedCrossAxisCount(
//                         crossAxisCount: 5,
//                         childAspectRatio: 1,
//                         mainAxisSpacing: 5,
//                       ),
//                       itemBuilder: (context, index) {
//                         return GestureDetector(
//                           onTap: () {
//                             removeDate(
//                                     id: widget.id,
//                                     shiftName: shiftName,
//                                     date: dateFromList)
//                                 .then((value) {
//                               createMapData(
//                                   id: widget.id,
//                                   shiftName: listWorkShift[index].shift,
//                                   date: dateFromList);
//                             });
//                             Navigator.of(context).pop();
//                           },
//                           child: Card(
//                             elevation: 1,
//                             color: listWorkShift[index].type == 'OFF'
//                                 ? MyColor.yellow
//                                 : MyColor.white,
//                             shadowColor: listWorkShift[index].type == "A"
//                                 ? MyColor.blue
//                                 : listWorkShift[index].type == "B"
//                                     ? MyColor.green
//                                     : listWorkShift[index].type == "C"
//                                         ? MyColor.red
//                                         : MyColor.grey,
//                             child: Center(
//                               child: textCustom(
//                                   '${listWorkShift[index].shift}', 16),
//                             ),
//                           ),
//                         );
//                       }))
//             ],
//           ),
//         ),
//         title: '${stringFormat.formatDateWithSplash(listDays[index].day)}');
//   }

//   generateDate(List<DayM> listDays) async {
//     for (int i = 0; i < 13 + 1; i++) {
//       listDays.add(DayM(i, DateTime(2022, 05, 16).add(Duration(days: i)), false,
//           false, '', 'grey'));
//     }
//     for (var item in listDays) {
//       if (stringFormat.formatDateOnlyDayText(item.day) == 'Sun' ||
//           stringFormat.formatDateOnlyDayText(item.day) == 'Sat') {
//         item.isWeekDay = true;
//       } else {
//         item.isWeekDay = false;
//       }
//     }
//     return listDays;
//   }

//   addShiftNametoList(id) {
//     List<User> listUser = [];
//     Stream<QuerySnapshot> stream = FirebaseFirestore.instance
//         .collection("user")
//         .where('id', isEqualTo: id)
//         .snapshots()
//         .asBroadcastStream();
//     stream.forEach((event) {
//       event.docs.asMap().forEach((key, value) {
//         userModel = User.fromJson(value.data() as Map<String, dynamic>);
//         listUser.add(userModel!);
//       });
//     });
//     final shiftModel = userModel?.shift;

//     shiftModel?.asMap().forEach((key, value) {
//       for (final item in listDays) {
//         if (stringFormat.formatDate(item.day) ==
//             stringFormat.formatDate(shiftModel[key].date.toDate())) {
//           item.text = shiftModel[key].shiftName;
//           if (shiftModel[key].shiftName.toUpperCase().contains("A")) {
//             item.color = 'blue';
//           } else if (shiftModel[key].shiftName.toUpperCase().contains("B")) {
//             item.color = 'green';
//           } else if (shiftModel[key].shiftName.toUpperCase().contains("C")) {
//             item.color = 'red';
//           } else if (shiftModel[key].shiftName.toUpperCase().contains("OFF")) {
//             item.color = 'yellow';
//           } else {
//             item.color = 'grey';
//           }
//         }
//       }
//     });

//     return listUser;
//   }
// }
