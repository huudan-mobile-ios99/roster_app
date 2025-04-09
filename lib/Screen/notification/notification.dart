import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:uuid/uuid.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/notificationM.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/notification/item_notification.dart';
import 'package:vegas_roster/Screen/widget_roster/mysnackbar.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/global.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  final stringFormat = StringFormat();
  DateTime datePicker = DateTime.now();
  List<DateTime> listDate = [];

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? name, id, number, group;
  final controller = Get.put(MyGetXController());
  @override
  void initState() {
    super.initState();

    getUserDataSave().then((value) {
      final UserSave user = value;
      setState(() {
        name = user.name;
        id = user.id;
        number = user.number;
        group = user.group;
      });
    });
    getDaysInBetweenFromServer().then((value) {
      setState(() {
        listDate = value;
      });
      saveListDatePrev(castListDateToString(value));
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: kIsWeb
                      ? DefaultValue.padding_64
                      : DefaultValue.padding_16),
              child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width,
                        child: Stack(
                          children: [
                            Center(
                                child: textCustom(
                                    MyString.label_notificationrequest, 18)),
                            // Positioned(
                            //     left: 0,
                            //     child: GestureDetector(
                            //         onTap: () {
                            //           Navigator.of(context).pop();
                            //         },
                            //         child: textCustomColor(
                            //             '< BACK', 16, Colors.blueAccent)))
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      textCustomColor(
                          'All notifications', 12, MyColor.grey),
                      const SizedBox(height: 5),
                      Expanded(
                          flex: 1,
                          child: FutureBuilder(
                            future: getListNotification(name: name, id: id),
                            builder: (context, snapshot) {
                              late List<NotificationItem> list =
                                  snapshot.data as List<NotificationItem>;
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: myprogresscircular());
                              }
                              if (!snapshot.hasData) {
                                return Center(
                                    child: textWithColorBox(
                                        textCustom(MyString.noti_error, 12)));
                              }
                              if (snapshot.hasData) {
                                controller.saveNotification(list.length.obs);
                                debugPrint(
                                    'total notification: ${controller.totalNotification.value}');
                              }

                              return list.isNotEmpty
                                  ? RefreshIndicator(
                                      key: _refreshIndicatorKey,
                                      onRefresh: () {
                                        return Future(() {
                                          setState(() {});
                                        });
                                      },
                                      child: ListView.builder(
                                          itemCount: list.length,
                                          itemBuilder: (context, index) =>
                                              itemNotification(
                                                isSeen: list[index].isAction,
                                                // item: list[index],
                                                hasDateText: true,
                                                onPressApprove: () {
                                                  debugPrint(
                                                      'approve item $name $number $id');
                                                  debugPrint(
                                                      'update item for thomas number 1 not manager');

                                                  //IF UPDATE DONE -> REMOVE NOTIFICATION AND CREATE A LOG
                                                  updateNotificationItem(
                                                          itemID: const Uuid()
                                                              .v1(),
                                                          userName: name,
                                                          myID: list[index]
                                                              .userID,
                                                          actionResult: MyString
                                                              .action_approve,
                                                          dateItem: stringFormat
                                                              .formatDateAndTime(
                                                                  DateTime
                                                                      .now()),
                                                          shiftNewItem:
                                                              list[index]
                                                                  .body
                                                                  .shiftNew,
                                                          shiftOldItem:
                                                              list[index]
                                                                  .body
                                                                  .shiftOld,
                                                          body:
                                                              '${MyString.request_approve} date: ${list[index].body.date} from: ${list[index].body.shiftOld} to: ${list[index].body.shiftNew}',
                                                          created: stringFormat
                                                              .formatDateAndTime(
                                                                  DateTime
                                                                      .now()),
                                                          isAction: true,
                                                          type: MyString
                                                              .responseButton,
                                                          from: MyString
                                                              .user_role_manager,
                                                          to: MyString
                                                              .user_role_user)
                                                      .then((value) {
                                                    //make the change

                                                    if (list[index]
                                                            .body
                                                            .shiftNew
                                                            .isNotEmpty &&
                                                        list[index]
                                                            .body
                                                            .shiftOld
                                                            .isNotEmpty) {
                                                      final dateFormat =
                                                          DateTime.parse(
                                                              list[index]
                                                                  .body
                                                                  .date);
                                                      debugPrint('RUN THUISvalue after update: ${list[index].body.date} ${stringFormat.formatDate(listDate.first)}  ${list[index].userID} ${list[index].body.shiftOld} ${list[index].body.shiftNew} ');

                                                      removeMapDataFromCollectionID(
                                                              subCollectionName:stringFormat.formatDate(listDate.first),
                                                              id: list[index].userID,
                                                              shiftName:list[index].body.shiftOld,
                                                      								// itemID:'1',
                                                      								)
                                                          .then((value) {
                                                      			debugPrint("DATe format: ${DateTime(dateFormat.year,dateFormat.month,dateFormat.day)} ${listDate.first} ${(listDate.first)} ${(DateTime(
                                                                dateFormat.year,
                                                                dateFormat.month,
                                                                dateFormat.day))}");
                                                        // createMapDataToCollection(
                                                        //     subCollectionName:stringFormat.formatDate(listDate.first),
                                                        //     id: list[index].userID,
                                                        //     shiftName:list[index].body.shiftNew,
                                                        //     // date: DateTime(2022,08,15)
                                                        //     date: (DateTime(
                                                        //         dateFormat.year,
                                                        //         dateFormat.month,
                                                        //         dateFormat.day))
                                                      		// 				).then((value){
                                                      		// 													ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(mysnackBar('${MyString.roster_setupworkshift_successful} ${list[index].body.shiftNew}'))  ;
                                                      		// 												});
                                                      });
                                                    }

                                                    //remove noti in manager collection
                                                    getManagerOfGroup(
                                                            groupName: group,
                                                            role: MyString
                                                                .user_role_manager)
                                                        .then((value) {
                                                      removeNotification(
                                                              myID: value,
                                                              id: list[index]
                                                                  .itemID)
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    });
                                                    //create new log
                                                    createEventLog(
                                                      time: stringFormat
                                                          .FormatTime(
                                                              DateTime.now()),
                                                      date: stringFormat
                                                          .formatDate(
                                                              DateTime.now()),
                                                      body: "APPROVE REQUEST from ${list[index].userName} date: ${list[index].body.date} from: ${list[index].body.shiftOld} to: ${list[index].body.shiftNew}",
                                                      name: name,
                                                      number: number,
                                                    );
                                                    // removeNotification();
                                                  });
                                                },

                                                onPressDecline: () {
                                                  debugPrint('decline item');
                                                  declineNotificationRequest(
                                                          itemID: const Uuid()
                                                              .v1(),
                                                          userName: name,
                                                          myID: list[index]
                                                              .userID,
                                                          actionResult: MyString
                                                              .action_approve,
                                                          dateItem: stringFormat
                                                              .formatDateAndTime(
                                                                  DateTime
                                                                      .now()),
                                                          shiftNewItem:
                                                              list[index]
                                                                  .body
                                                                  .shiftOld,
                                                          shiftOldItem:
                                                              list[index]
                                                                  .body
                                                                  .shiftOld,
                                                          body:
                                                              '${MyString.request_decline} date: ${list[index].body.date} from: ${list[index].body.shiftOld} to: ${list[index].body.shiftNew}',
                                                          created: stringFormat
                                                              .formatDateAndTime(
                                                                  DateTime
                                                                      .now()),
                                                          isAction: true,
                                                          type: MyString
                                                              .responseButton_decline,
                                                          from: MyString
                                                              .user_role_manager,
                                                          to: MyString
                                                              .user_role_user)
                                                      .then((value) {
                                                    //after decline func -> remove noti from manager collection & create log
                                                    getManagerOfGroup(
                                                            groupName: group,
                                                            role: MyString
                                                                .user_role_manager)
                                                        .then((value) {
                                                      removeNotification(
                                                              myID: value,
                                                              id: list[index]
                                                                  .itemID)
                                                          .then((value) {
                                                        setState(() {});
                                                      });
                                                    });
                                                    createEventLog(
                                                      time: stringFormat
                                                          .FormatTime(
                                                              DateTime.now()),
                                                      date: stringFormat
                                                          .formatDate(
                                                              DateTime.now()),
                                                      body:
                                                          "DECLINE REQUEST from ${list[index].userName} date: ${list[index].body.date} from: ${list[index].body.shiftOld} to: ${list[index].body.shiftNew}",
                                                      name: name,
                                                      number: number,
                                                    );
                                                  });
                                                },
                                                onPressRemove: () {
                                                  debugPrint(
                                                      'remove notification ${list[index].userID} hh ${list[index].itemID}');
                                                  removeNotification(
                                                    id: list[index].itemID,
                                                    myID: list[index].userID,
                                                  ).then((value) {
                                                    setState(() {});
                                                  });
                                                },
                                                isUser: list[index].from ==
                                                            MyString
                                                                .user_role_user &&
                                                        list[index].to ==
                                                            MyString
                                                                .user_role_manager
                                                    ? false
                                                    : true,
                                                isEnable: true,
                                                itemWidth: width +
                                                    DefaultValue.padding_16,
                                                onPress: () {
                                                  debugPrint(
                                                      'click notification $name $id');
                                                },
                                                index: '${index + 1}',
                                                text: list[index].body.body,
                                                textDate: list[index].created,
                                              )))
                                  : Center(
                                      child: textWithColorBox(
                                          textCustom(MyString.noti_noitem, 12)),
                                    );
                            },
                          )),
                    ],
                  )))),
    );
  }
}
