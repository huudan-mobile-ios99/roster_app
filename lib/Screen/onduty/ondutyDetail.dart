import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Screen/onduty/activeonduty.dart';
import 'package:vegas_roster/Screen/onduty/allonduty.dart';
import 'package:vegas_roster/Screen/onduty/item_onduty.dart';
import 'package:vegas_roster/Screen/onduty/unactiveonduty.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class OnDutyDetail extends StatefulWidget {
  final String? group, color;
  OnDutyDetail({Key? key, this.group, this.color}) : super(key: key);

  @override
  State<OnDutyDetail> createState() => _OnDutyDetailState();
}

class _OnDutyDetailState extends State<OnDutyDetail>
    with TickerProviderStateMixin {
  int? totalPeople = 0;
  final controllerGetX = Get.put(MyGetXController());
  late TabController _tabController;
  final  List<Tab> myTabs = <Tab>[
    const Tab(text: 'All', height: 25),
    const Tab(
      text: 'Active',
      height: 25,
    ),
    const Tab(
      text: 'Unactive',
      height: 25,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
    userList!.clear();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  final today = DateTime.now();
  late User userChild;
  QuerySnapshot<Map<String, dynamic>>? dataList;
  List<User>? userList = [];
  List<User>? userListFilter = [];
  final stringFormat = StringFormat();
  String mySearchValue = '';
  final mySearchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical:DefaultValue.padding_8,horizontal: kIsWeb ?  DefaultValue.padding_64 : DefaultValue.padding_16),
              child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Positioned(
                              left: 0,
                              top: 0,
                              child: GestureDetector(
                                  onTap: () => Navigator.of(context).pop(),
                                  child:textCustomColor('< BACK', 14, Colors.blue)),
                            ),
                            textCustom('${widget.group!.toUpperCase()}', 16),
                            const SizedBox(width: 5),
                            // textCustomColor('(${stringFormat.formatDateWithSplash(today)})',12,
                            //         MyColor.grey),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(color:MyColor.grey_tab,
                          width: width,
                          child: tabViewEqual(width:width-32,myTabs:  myTabs,tabController:  _tabController,context:context,color:  widget.color,hasColorFromParen:  true)),
                      const SizedBox(height: 10),
                      Expanded(
                        flex: 1,
                        child: 
                        TabBarView(
                          controller: _tabController,
                          children: [
                            AllOnDuty(
                              groupName: widget.group,
                              color: widget.color,
                            ),
                            ActiveOnduty(
                               groupName: widget.group,
                               color: widget.color,
                            ),
                            UnActiveOnduty(
                               groupName: widget.group,
                              color: widget.color,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )))),
    );
  }
}
