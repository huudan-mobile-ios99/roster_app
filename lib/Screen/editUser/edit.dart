import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/drawer.dart';
import 'package:vegas_roster/Screen/editUser/edit_user_roster.dart';
import 'package:vegas_roster/Screen/editUser/item_edituser.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/function_date_edit.dart';
import 'package:vegas_roster/Util/global.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class Edit extends StatefulWidget {
  @override
  State<Edit> createState() => _EditState();
}

class _EditState extends State<Edit> {
  List<Shift> listShift = [];

  String? name, role, group, number, vietnamese, id;
  DateTime? today = DateTime.now();
  final controller = Get.put(MyGetXController());
  StringFormat? stringFormat = StringFormat();
  final GlobalKey<ScaffoldState> _key = GlobalKey(); // Create a key
  UserSave? user;
  User? userModel;
  List<User>? listUser = [];
  List<DayM> listDays = [
    DayM(1, DateTime(2000, 01, 01), false, false, '', 'grey')
  ];
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didchangedependencies edit.dart');
  }


  @override
  void initState() {
    debugPrint('initstate edit.dart');
    getStartDateFromServer__().then((value) async {
      await generateDateWITHSTART(listDays, value);
      setState(() {
        listDays = listDays.toSet().toList();
      });
      listDays.removeAt(0);
    });
    getUserDataSave().then(
      (value) {
        user = value;
        setState(() {
          name = user?.name;
          group = user?.group;
          role = user?.role;
          number = user?.number;
          vietnamese = user?.vietnameseName;
          id = user?.id;
        });
      },
    );
    // getStartDateFromServer().then((value) {
    //   generateDateWITHSTART(listDays, value);
    //   setState(() {
    //     listDays = listDays.toSet().toList();
    //   });
    //   listDays.removeAt(0);
    // });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      drawer: const MyDrawer(),
      // key: _key,
						key: myGlobals.scaffoldKey,
      body: SafeArea(
          child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: DefaultValue.padding_8,
            horizontal:
                kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_16),
        width: width,
        height: height,
        child: Column(
          children: [
            const SizedBox(
              height: 8,
            ),
            Card(
              child: ListTile(
                  visualDensity: VisualDensity.compact,
                  leading: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: MyColor.grey_tab,
                          borderRadius: BorderRadius.circular(2.5)),
                      child: textCustom('$number', 13)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          onPressed: () {
                            debugPrint('click menu');
                            _key.currentState?.openDrawer();
                          },
                          icon: const Icon(Icons.menu, size: 24)),
                      IconButton(
                          onPressed: () {
                            showDialog(
                              context: myGlobals.scaffoldKey.currentContext!,
                              builder: (BuildContext context) {
                                return dialogAlertBodyYN(
                                  context: context,
                                  height: height / 4,
                                  width: width,
                                  onPress: () {
                                    clearCheckBoxForAuthentication();
                                    clearUserSave();
                                    Navigator.of(context).pushNamed('/login');
                                  },
                                  title: "Do you want to log out?",
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Icons.logout_rounded,
                            size: 24,
                          )),
                      // user?.role.toLowerCase() == "admin" ||
                      //         user?.role.toLowerCase() == 'manager'
                      //     ? Container()
                      //     : 
																										IconButton(
                              onPressed: () {
                                debugPrint('click request');
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (_) => EditUserRoster(
                                          id: id,
                                          name: name,
                                          vietnameseName: vietnamese,
                                        )));
                              },
                              icon: const Icon(
                                  Icons.auto_awesome_mosaic_rounded,
                                  size: 24)),
                    ],
                  ),
                  dense: true,
                  title: textCustomColor('$name', 16, MyColor.black_text)),
            ),
            const SizedBox(
              height: 5,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Align(
                  alignment: Alignment.centerLeft,
                  child: listDays.length > 1
                      ? textCustomColor(
                          'All dates from ${stringFormat?.formatDateWithSplash(listDays.first.day)} to ${stringFormat?.formatDateWithSplash(listDays.last.day)}',
                          14,
                          MyColor.black_text)
                      : Container()),
            ),
            const SizedBox(
              height: 5,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection(
                        'user/$id/${stringFormat!.formatDate(listDays.first.day)}')
                    .snapshots()
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: myprogresscircular());
                  }
                  if (snapshot.hasError) {
                    return textCustom(MyString.onduty_error, 12);
                  }
                  addShiftNametoList_(id, stringFormat!.formatDate(listDays.first.day));

                  return SizedBox(
                    child: GridView.builder(
                      itemCount: listDays.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: kIsWeb ? 6 : 3,
                        childAspectRatio: 1,
                        crossAxisSpacing: kIsWeb
                            ? DefaultValue.padding_16
                            : DefaultValue.padding_8,
                        mainAxisSpacing: kIsWeb
                            ? DefaultValue.padding_16
                            : DefaultValue.padding_8,
                      ),
                      itemBuilder: (context, index) {
                        return stringFormat?.formatDate(listDays.first.day) ==
                                stringFormat?.formatDate(DateTime(2000, 01, 01))
                            ? Container()
                            : GestureDetector(
                                onTap: () {
                                  debugPrint('ontap s $index');
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return FutureBuilder(
                                        future: getListShiftCode(),
                                        builder: (context, snapshot) {
                                          late final listWorkShift =
                                              snapshot.data as List<ShiftList>;
                                          if (snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                            return Center(
                                                child: myprogresscircular());
                                          }
                                          if (!snapshot.hasData) {
                                            return Center(
                                                child: Container(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            15),
                                                    decoration: BoxDecoration(
                                                        color: MyColor.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(7.5)),
                                                    child: textCustom(
                                                        MyString.roster_no_itemshift,
                                                        12)));
                                          }
                                          return dialogDetailBody(
                                              width: width,
                                              height: height / 2,
                                              index: index,
                                              context: context,
                                              id: id,
                                              nameSave: name,
                                              userName: name,
                                              numberSave: number,
                                              listWorkShift:listWorkShift.first.shiftItem,
                                              dateFromList: listDays[index].day,
                                              shiftName: listDays[index].text,
                                              listDays: listDays);
                                        },
                                      );
                                    },
                                  );
                                },
                                child: Card(
                                    shadowColor: Colors.blueAccent,
                                    elevation: 2.5,
                                    child: ListTile(
                                        title: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        textCustomColor(
                                            '${stringFormat?.formatDateOnlyDayDDDate(listDays[index].day)}',
                                            12,
                                            MyColor.black_text),
                                        const SizedBox(height: 5),
                                        listDays[index].text == ''
                                            ? textCustomColor(
                                                MyString.pickAItem,
                                                12,
                                                MyColor.grey)
                                            : Container(
                                                padding: const EdgeInsets.symmetric(vertical:2.5,horizontal:5),
                                                decoration: BoxDecoration(
                                                  color: listDays[index].color ==
                                                          'blue'
                                                      ? MyColor.blue
                                                          .withOpacity(0.35)
                                                      : listDays[index].color ==
                                                              'green'
                                                          ? MyColor.green
                                                              .withOpacity(0.35)
                                                          : listDays[index]
                                                                      .color ==
                                                                  'red'
                                                              ? MyColor.red
                                                                  .withOpacity(
                                                                      0.35)
                                                              : listDays[index]
                                                                          .color ==
                                                                      'yellow'
                                                                  ? MyColor
                                                                      .yellow
                                                                  : MyColor
                                                                      .grey_tab,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          2.5),
                                                ),
                                                child: textCustom(
                                                    listDays[index]
                                                        .text
                                                        .toUpperCase(),
                                                    16),
                                              )
                                      ],
                                    ))),
                              );
                      },
                    ),
                  );
                },
              ),
            )
          ],
        ),
      )),
    );
  }

  // addShiftNametoList(id) {
  //   Stream<QuerySnapshot> stream = FirebaseFirestore.instance
  //       .collection("user")
  //       .where('id', isEqualTo: id)
  //       .snapshots()
  //       .asBroadcastStream();
  //   stream.forEach((event) {
  //     event.docs.asMap().forEach((key, value) {
  //       userModel = User.fromJson(value.data() as Map<String, dynamic>);
  //       // debugPrint('name user: ${userModel!.name.toString()}');
  //     });
  //   });
  //   final shiftModel = userModel?.shift;

  //   shiftModel?.asMap().forEach((key, value) {
  //     // debugPrint(shiftModel[key].shiftName);
  //     for (final item in listDays) {
  //       if (stringFormat?.formatDate(item.day) ==
  //           stringFormat?.formatDate(shiftModel[key].date.toDate())) {
  //         item.text = shiftModel[key].shiftName;
  //         if (shiftModel[key].shiftName.toUpperCase().contains("A")) {
  //           item.color = 'blue';
  //         } else if (shiftModel[key].shiftName.toUpperCase().contains("B")) {
  //           item.color = 'green';
  //         } else if (shiftModel[key].shiftName.toUpperCase().contains("C")) {
  //           item.color = 'red';
  //         } else if (shiftModel[key].shiftName.toUpperCase().contains("OFF")) {
  //           item.color = 'yellow';
  //         } else {
  //           item.color = 'grey';
  //         }
  //       }
  //     }
  //   });
  // }

  addShiftNametoList_(id, subCollection) {
    Stream<QuerySnapshot> stream = FirebaseFirestore.instance
        .collection("user/$id/$subCollection")
        .snapshots()
        .asBroadcastStream();
    stream.forEach((event) {
      event.docs.forEach((value) {
        final model = Shift.fromJson(value.data() as Map<String, dynamic>);
								// debugPrint('shiftName: ${model.shiftName} ${model.date}');
        listShift.add(model);
      });
    });

    listShift.asMap().forEach((key, value) {
      for (final item in listDays) {
        if (stringFormat?.formatDate(item.day) ==
            stringFormat?.formatDate(listShift[key].date.toDate())) {
          item.text = listShift[key].shiftName;
          if (listShift[key].shiftName.toUpperCase().contains("A")) {
            item.color = 'blue';
          } else if (listShift[key].shiftName.toUpperCase().contains("B")) {
            item.color = 'green';
          } else if (listShift[key].shiftName.toUpperCase().contains("C")) {
            item.color = 'red';
          } else if (listShift[key].shiftName.toUpperCase().contains("OFF")) {
            item.color = 'yellow';
          } else {
            item.color = 'grey';
          }
        }
      }
    });
  }
}
