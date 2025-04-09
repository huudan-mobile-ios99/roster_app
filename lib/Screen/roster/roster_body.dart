import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/editUser/editUserContainer.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/notification/item_notification.dart';
import 'package:vegas_roster/Screen/roster/roster_all.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class RosterBody extends StatefulWidget {
  RosterBody(
      {Key? key,
      required this.isSearch,
      required this.listDate,
      required this.startDateRoster,
      required this.searchKey})
      : super(key: key);

  List<DateTime> listDate;
  bool isSearch;
  String startDateRoster;
  String searchKey;

  @override
  State<RosterBody> createState() => _RosterBodyState();
}

class _RosterBodyState extends State<RosterBody> {
  String userRoleFromSave = '';
  String userGroupFromSave = '';
  final stringFormat = StringFormat();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.width;
    final itemWidth = width / 16;
    return FutureBuilder(
      future: widget.isSearch == false
          ? addDataToList()
          : getSearchGroup(widget.searchKey),
      builder: (context, snapshot) {
        late final userList = snapshot.data as List<User>;
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: myprogresscircularSmall());
        }
        if (!snapshot.hasData) {
          return Center(child: myprogresscircularSmall());
        }
        return userList.isEmpty
            ? Expanded(
                child: Center(
                    child: textWithColorBox(
                        textCustom(MyString.roster_nostaff, 12))))
            : SizedBox(
                height: height * 2,
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
                        GestureDetector(
                          onTap: () {
                            debugPrint('click detail ttt: ${userList[index].name}');
                            getUserDataSave().then(
                              (value) {
                                final UserSave userSave = value;
                                userRoleFromSave = userSave.role;
                                userGroupFromSave = userSave.group;
                              },
                            );
                            debugPrint(
                                'click detaiil save: ${userRoleFromSave} $userGroupFromSave ${userList[index].id}');
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return dialogAlertBody(
                                    hasRequestBtn: true,
                                    textButton2: MyString.viewAllBtn,
                                    functionRequest: () {
                                      debugPrint('click view all ');
                                      debugPrint('item view all id : ${userList[index].id} ');
                                      Navigator.of(context).push( MaterialPageRoute(builder: (_) => RosterAll(id: userList[index].id)));
                                    },
                                    context: context,
                                    height: height,
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
                                        (userRoleFromSave.toLowerCase() ==
                                                    'manager' &&
                                                userGroupFromSave
                                                        .toLowerCase() ==
                                                    userList[index]
                                                        .group
                                                        .toLowerCase())
                                            ? TextButton(
                                                onPressed: () {
                                                  debugPrint(
                                                      'click edit work shift detail infor 1');
                                                  debugPrint(
                                                      '${userList[index].name} ${userList[index].vietnameseName} ${userList[index].group} ${userList[index].number}');
                                                  Navigator.of(context)
                                                      .push(MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditUserContainer(
                                                      initIndex: 0,
                                                      name:
                                                          userList[index].name,
                                                      vietnameseName:
                                                          userList[index]
                                                              .vietnameseName,
                                                      number: userList[index]
                                                          .number,
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
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
                                                  '${userList[index].name}',
                                                  11),
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
                                        Expanded(child: FutureBuilder(
                                          future: getRosterDateFromByDate(
                                              id: userList[index].id,
                                              date: widget.startDateRoster),
                                          builder: (context, snapshot) {
                                            late final item =
                                                snapshot.data as List<Shift>;
                                            if (snapshot.connectionState == ConnectionState.waiting) {
                                              return  const SizedBox(
                                                  height: 25,
                                                  width: 25,
																																														);
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
                                                    padding:const EdgeInsets.all(0),
                                                    itemCount: item.length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return GestureDetector(
                                                        onTap: () {
                                                          debugPrint(
                                                              'view detail');
                                                        },
                                                        child: itemNotification(
                                                          isPassDay: item[index]
                                                                      .date
                                                                      .toDate()
                                                                      .difference(
                                                                          DateTime
                                                                              .now())
                                                                      .inDays >=
                                                                  0
                                                              ? false
                                                              : true,
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
                                        ))
                                      ],
                                    ));
                              },
                            );
                          },
                          child: SizedBox(
                            height: 25,
                            child: itemDateChild(
                                color:
                                    userList[index].color.toString().isNotEmpty
                                        ? userList[index].color.toString()
                                        : '0xFFE0E0E0',
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
                                child: FutureBuilder(
                                  future: getRosterDateFromByDate(
                                      id: userList[index].id,
                                      date: widget.startDateRoster),
                                  builder: (context, snapshot) {
                                    late final item =
                                        snapshot.data as List<Shift>;
                                    if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: myprogresscircularSmall());
                                    }
                                    if (!snapshot.hasData ||
                                        snapshot.hasError) {
                                      return Container();
                                    }
                                    return item.isNotEmpty
                                        ? Stack(
                                            children: [
                                              ...item.map((e) {
                                                int differentInDays = e.date
                                                    .toDate()
                                                    .difference(
                                                        widget.listDate.first)
                                                    .inDays;
                                                if (item.isNotEmpty) {
                                                  if (differentInDays >= 0) {
                                                    return Positioned(
                                                      left: (itemWidth *
                                                          differentInDays),
                                                      top: 0,
                                                      bottom: 0,
                                                      child: itemDateChildColor(
                                                        itemWidth: itemWidth,
                                                        color: e.shiftName ==
                                                                'OFF'
                                                            ? MyColor.yellow
                                                            : e.shiftName[0]
                                                                        .toUpperCase() ==
                                                                    "A"
                                                                ? MyColor.blue
                                                                    .withOpacity(
                                                                        0.35)
                                                                : e.shiftName[0]
                                                                            .toUpperCase() ==
                                                                        'B'
                                                                    ? MyColor
                                                                        .green
                                                                        .withOpacity(
                                                                            0.35)
                                                                    : e.shiftName[0].toUpperCase() ==
                                                                            'C'
                                                                        ? MyColor
                                                                            .red
                                                                            .withOpacity(
                                                                                0.35)
                                                                        : MyColor
                                                                            .white,
                                                        text: e.shiftName
                                                            .toUpperCase(),
                                                      ),
                                                    );
                                                  }
                                                }
                                                return const SizedBox();
                                              })
                                            ],
                                          )
                                        : Center(
                                            child: textCustomColor(
                                                MyString.roster_setupworkshift,
                                                10,
                                                MyColor.grey.withOpacity(.65)),
                                          );
                                  },
                                ))),
                      ],
                    );
                  },
                ),
              );
      },
    );
  }
}
