import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/instance_manager.dart';
import 'package:uuid/uuid.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/editUser/user_roster_dialog.dart';
import 'package:vegas_roster/Screen/widget_roster/mysnackbar.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/function_date_edit.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:vegas_roster/Widget/toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditUserRoster extends StatefulWidget {
  String? name, id, vietnameseName;
  EditUserRoster({this.name, this.id, this.vietnameseName});
  @override
  State<EditUserRoster> createState() => _EditUserRosterState();
}

class _EditUserRosterState extends State<EditUserRoster>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String? name, number, vietnameseName, group, id, role;
  final controller = Get.put(MyGetXController());
  final stringFormat = StringFormat();
  User? userModel;
  UserSave? user;
  List<Shift> listShift = [];

  List<DayM> listDays = [
    DayM(1, DateTime(2000, 01, 01), false, false, '', 'grey')
  ];

  @override
  void initState() {
    debugPrint('edit_user_rsoter');
    super.initState();
    _tabController = TabController(vsync: this, length: 2);
    getStartDateFromServer__(isPrevRoster: true).then((value) async {
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
          role = user?.role;
          number = user?.number;
          group = user?.group;
          vietnameseName = user?.vietnameseName;
          id = user?.id;
        });
      },
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: SafeArea(
      child: Container(
        color: MyColor.white,
        padding: const EdgeInsets.symmetric(
            vertical: DefaultValue.padding_8,
            horizontal:
                kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_16),
        width: width,
        height: height,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            SizedBox(
              width: width,
              child: Stack(
                children: [
                  Center(child: textCustom(MyString.label_request_roster, 18)),
                  Positioned(
                      left: 0,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: textCustomColor(
                              MyString.label_back, 16, Colors.blueAccent)))
                ],
              ),
            ),
            const SizedBox(height: DefaultValue.padding_8),
            textCustomColor(
                'All date from ${stringFormat.formatDateWithSplash(listDays.first.day)} to ${stringFormat.formatDateWithSplash(listDays.last.day)}',
                12,
                MyColor.grey),
            const SizedBox(
              height: DefaultValue.padding_8,
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('user/${widget.id}/${stringFormat.formatDate(listDays.first.day)}')
                    .snapshots()
                    .asBroadcastStream(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: myprogresscircular());
                  }
                  //this is important
                  addShiftNametoList_(widget.id,stringFormat.formatDate(listDays.first.day));
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
                        return GestureDetector(
                          onTap: () {
                            debugPrint(
                                'ontap item roster $index ${listDays[index].text}');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return EditRosterDialog(
                                  oldRoster: listDays[index].text,
                                  onPress: () {
                                    debugPrint(
                                        'onPress request 2 ${role} ${group}');
                                    getManagerOfGroup(
                                      groupName: group,
                                      role: MyString.user_role_manager,
                                    ).then((value) {
                                      if (listDays[index].text !=
                                              controller.shiftCode2.value &&
                                          controller
                                              .shiftCodeOld.value.isNotEmpty) {
                                        createNotificationItem(
                                                context: context,
                                                itemID: const Uuid().v1(),
                                                created: stringFormat.formatDateAndTime(DateTime.now()),
                                                body:'Request change from $name ($vietnameseName)\nDate ${stringFormat.formatDate(listDays[index].day)} from ${listDays[index].text} to ${controller.shiftCode2.value}',
                                                dateItem:
                                                    stringFormat.formatDate(
                                                        listDays[index].day),
                                                shiftNewItem:
                                                    controller.shiftCode2.value,
                                                shiftOldItem:
                                                    listDays[index].text,
                                                myID: value,
                                                userName: name,
                                                userID: id,
                                                from: MyString.user_role_user,
                                                to: MyString.user_role_manager,
                                                actionResult:
                                                    MyString.action_new,
                                                isAction: false,
                                                type: MyString.requestButton)
                                            .then((value) {
                                          // createNotificationItem(
                                          //     hasAlert: false,
                                          //     context: context,
                                          //     itemID: const Uuid().v1(),
                                          //     created: stringFormat
                                          //         .formatDateAndTime(
                                          //             DateTime.now()),
                                          //     body:'Your request is sent to manager \nDate ${stringFormat.formatDate(listDays[index].day)} -> ${listDays[index].text} to ${controller.shiftCode2.value}',
                                          //     dateItem: stringFormat.formatDate(
                                          //         listDays[index].day),
                                          //     shiftNewItem:
                                          //         controller.shiftCode2.value,
                                          //     shiftOldItem:
                                          //         listDays[index].text,
                                          //     myID: id,
                                          //     userName: name,
                                          //     userID: id,
                                          //     from: MyString.user_role_user,
                                          //     to: MyString.user_role_user,
                                          //     actionResult: MyString.action_new,
                                          //     isAction: false,
                                          //     type: MyString.responseButton);
                                          Navigator.of(context).pop();
                                        });
                                      } else {
                                        debugPrint(
                                            'can not create notification because the same shift');
                                        kIsWeb
                                            ? ScaffoldMessenger.of(context)
                                                .showSnackBar(mysnackBar(
                                                    MyString
                                                        .roster_no_itemshift))
                                            : showToastError(
                                                MyString.roster_no_itemshift);
                                        Navigator.of(context).pop();
                                      }
                                    });
                                  },
                                  date: stringFormat.formatDateWithSplash(
                                      listDays[index].day),
                                );
                              },
                            );
                          },
                          child: Card(
                              color: MyColor.grey_tab2,
                              shadowColor: Colors.grey,
                              elevation: 2.5,
                              child: ListTile(
                                  title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  textCustomColor(
                                      '${stringFormat.formatDateOnlyDayDDDate(listDays[index].day)}',
                                      13,
                                      MyColor.black_text),
                                  const SizedBox(height: 5),
                                  listDays[index].text == ''
                                      ? textCustomColor(
                                          MyString.pickAItem, 12, MyColor.grey)
                                      : Container(
                                          padding: const EdgeInsets.symmetric(vertical:2.5,horizontal:5),
                                          decoration: BoxDecoration(
                                            color: listDays[index].color ==
                                                    'blue'
                                                ? MyColor.blue.withOpacity(0.35)
                                                : listDays[index].color ==
                                                        'green'
                                                    ? MyColor.green
                                                        .withOpacity(0.35)
                                                    : listDays[index].color ==
                                                            'red'
                                                        ? MyColor.red
                                                            .withOpacity(0.35)
                                                        : listDays[index]
                                                                    .color ==
                                                                'yellow'
                                                            ? MyColor.yellow
                                                            : MyColor.grey_tab,
                                            // color: MyColor.grey_tab,
                                            borderRadius:
                                                BorderRadius.circular(2.5),
                                          ),
                                          child: textCustom(
                                              '${listDays[index].text.toUpperCase()}',
                                              14),
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
      ),
    ));
  }

  Future addShiftNametoList_(id, subCollection,) async {
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
        if (stringFormat.formatDate(item.day) ==
            stringFormat.formatDate(listShift[key].date.toDate())) {
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
