import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/roster/roster_body.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class RosterGroup extends StatefulWidget {
  String? group;
  List<DateTime>? listDate;
  bool? isRosterPrev;
  RosterGroup({
    Key? key,
    this.group,
    this.listDate,
    this.isRosterPrev,
  }) : super(key: key);
  @override
  State<RosterGroup> createState() => _RosterGroupState();
}

class _RosterGroupState extends State<RosterGroup> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String role = '';
  String? id;
  final today = DateTime.now();
  final stringFormat = StringFormat();
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    debugPrint('didChangeDependencies roster_group.dart');
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(widget);
  }

  @override
  void initState() {
    debugPrint('initState roster_Group.dart');
    debugPrint('group: ${widget.group} list: ${widget.listDate?.first.day}');
    getUserDataSave().then(
      (value) {
        UserSave user = value;
        setState(() {
          id = user.id;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final itemWidth = width / 16;
    return Scaffold(
      body: SafeArea(
        child: SizedBox(
          width: width,
          height: height,
          child: Column(
            children: [
														const SizedBox(height: 8,),
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textCustomColor('ROSTER ${widget.group?.toUpperCase()}',
                          18,
                          widget.isRosterPrev == false
                              ? Colors.blue
                              : MyColor.green),
                    ],
                  ),
                  Positioned(
                      left: 8,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: textCustomColor(
                              '< BACK',
                              18,
                              widget.isRosterPrev == false
                                  ? Colors.blueAccent
                                  : MyColor.green)))
                ],
              ),
              widget.listDate != null
                  ? Center(
                      child: textCustomColor(
                          '${stringFormat.formatDateWithSplashFULL(widget.listDate?.first)} - ${stringFormat.formatDateWithSplashFULL(widget.listDate?.last)}',
                          11,
                          MyColor.black_text.withOpacity(.75)))
                  : Container(),
              const SizedBox(height: 5),
              buildDateRowFuture(itemWidth, stringFormat, width, '',
                  widget.isRosterPrev == false ? false : true, () {}),
              Expanded(
                  child: widget.listDate != null
                      ? 
                      
                      // buildShiftRowFuture(width, height, itemWidth, () {},
                      //     widget.listDate!, widget.group, true, true, () {
                      //     debugPrint('click refresh detail');
                      //   }, stringFormat.formatDate(widget.listDate!.first))
                      RosterBody(isSearch: true, listDate: widget.listDate!, startDateRoster: stringFormat.formatDate(widget.listDate!.first), searchKey: widget.group!)
                      : 
                      Center(child: textCustom(MyString.no_data, 12))),
            ],
          ),
        ),
      ),
    );
  }

  addDataToList_(userList) async {
    final firestore = FirebaseFirestore.instance;
    List<User> userList = [];

    final QuerySnapshot query = await firestore.collection('user').get();
    query.docs.forEach((value) {
      User userModel = User.fromJson(value.data() as Map<String, dynamic>);
      userList.add(userModel);
    });

    debugPrint('addData to list: ${userList.length}');
    return userList.toSet().toList();
  }
}
