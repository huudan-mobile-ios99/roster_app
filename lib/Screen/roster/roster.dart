import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/roster/item_group.dart';
import 'package:vegas_roster/Screen/roster/item_group_bottom.dart';
import 'package:vegas_roster/Screen/roster/roster_body.dart';
import 'package:vegas_roster/Screen/roster/roster_group.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/function_date_edit.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class Roster extends StatefulWidget {
  @override
  State<Roster> createState() => _RosterState();
}

class _RosterState extends State<Roster> {
  List<DateTime> listDate = [];
  List<DayM> listDays = [];
  final stringFormat = StringFormat();
  List<User>? userList = [];
  String searchKey = 'All';
  String? id;
  @override
  void initState() {
    debugPrint('initState roster.dart');
    super.initState();
    getStartDateFromServer__().then((value) {
      setState(() {
        listDate = generateDatewithstart(listDate, value);
      });
      saveListDate(castListDateToString(listDate));
    });
    getUserDataSave().then(
      (value) {
        UserSave user = value;
        setState(() {
          searchKey = user.group;
          id = user.id;
        });
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    userList!.clear();
    listDate.clear();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final itemWidth = width / 16;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: MyString.rosterview_button_tooltip,
								hoverColor: MyColor.violet,
        onPressed: () {
          debugPrint('click show bottom dialog'); 
          showModalBottomSheet(
              context: context,
              builder: (_) => ItemGroupBottom(
                    listDate: listDate,
                    isRosterPrev: false,
                  ));
        },
        child: const Icon(Icons.list),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            SizedBox(
              width: width,
              height: height,
              child: Column(
                children: [
                  const SizedBox(
                    height: 8,
                  ),
                  SizedBox(
                    width: width,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        textCustomColor('NEXT ROSTER', 18, Colors.blue),
                        Positioned(
                            left: DefaultValue.padding_8,
                            child: GestureDetector(
                                onTap: () {
                                  debugPrint('move prev page');
                                  Navigator.pop(context);
                                },
                                child: textCustomColor(
                                    'CURRENT', 16, Colors.blueAccent))),
                      ],
                    ),
                  ),
                  listDate.isNotEmpty
                      ? Center(
                          child: textCustomColor(
                              '${stringFormat.formatDateWithSplashFULL(listDate.first)} - ${stringFormat.formatDateWithSplashFULL(listDate.last)}',
                              12,
                              MyColor.black_text))
                      : Container(),
                  const SizedBox(height: 5),
                  buildDateRowFuture(itemWidth, stringFormat, width, '', false,
                      () {
                    debugPrint('click rostser refresh');
                  }),
                  Expanded(
                      child: listDate.isNotEmpty
                          ? RosterBody(
                              isSearch: true,
                              listDate: listDate,
                              startDateRoster: stringFormat.formatDate(listDate.first),
                              searchKey: searchKey)
                          : Center(child: myprogresscircularSmall())),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
