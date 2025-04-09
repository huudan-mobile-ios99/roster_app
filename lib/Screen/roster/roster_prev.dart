import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/groupM.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/roster/item_group.dart';
import 'package:vegas_roster/Screen/roster/item_group_bottom.dart';
import 'package:vegas_roster/Screen/roster/roster_body.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class RosterPrev extends StatefulWidget {
  @override
  State<RosterPrev> createState() => _RosterPrevState();
}

class _RosterPrevState extends State<RosterPrev> {
  List<DateTime> listDate = [];
  List<User> userList = [];
  List<User> userListSearch = [];
  String role = '';
  final today = DateTime.now();
  final stringFormat = StringFormat();
  String searchKey = '';
  String? id;
  Stream<QuerySnapshot> stream =FirebaseFirestore.instance.collection('user').snapshots();

  @override
  void dispose() {
    super.dispose();
    userList.clear();
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies roster_prev.dart');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(widget);
  }

  @override
  void initState() {
    debugPrint('initState roster_prev.dart');
    super.initState();
    getUserDataSave().then(
      (value) {
        UserSave user = value;
        setState(() {
          searchKey = user.group;
          id = user.id;
        });
      },
    );
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
    final itemWidth = width / 16;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: MyString.rosterview_button_tooltip,
								hoverColor: MyColor.violet,
        onPressed: () {
          debugPrint('click show bottom dialog prev ');
          showModalBottomSheet(context: context, builder:(_)=> ItemGroupBottom(
                    listDate: listDate,
                    isRosterPrev: true,
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
                  Stack(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          textCustomColor('CURRENT ROSTER', 16, MyColor.green),
                        ],
                      ),
                      Positioned(
                          right: DefaultValue.padding_8,
                          child: GestureDetector(
                              onTap: () {
																																Navigator.pushNamed(context, '/roster');
                              },
                              child: textCustomColor(
                                  'NEXT', 16, MyColor.green)))
                    ],
                  ),
                  listDate.isNotEmpty
                      ? Center(
                          child: textCustomColor(
                              '${stringFormat.formatDateWithSplashFULL(listDate.first)} - ${stringFormat.formatDateWithSplashFULL(listDate.last)}',
                              12,
                              MyColor.black_text))
                      : Container(),
                  const SizedBox(height: 5),
                  buildDateRowFuture(
                      itemWidth, stringFormat, width, searchKey, true, () {}),
                  listDate.isNotEmpty
                      ? Expanded(
                          child: RosterBody(
                              isSearch: true,
                              listDate: listDate,
                              startDateRoster:stringFormat.formatDate(listDate.first),
                              searchKey: searchKey))
                      :  Center(child: myprogresscircularSmall())
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
