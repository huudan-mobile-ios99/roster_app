import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Screen/onduty/function_onduty.dart';
import 'package:vegas_roster/Screen/onduty/item_listduty.dart';
import 'package:vegas_roster/Screen/onduty/item_onduty.dart';
import 'package:vegas_roster/Screen/onduty/ondutyDetail.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class OnDuty extends StatefulWidget {
  const OnDuty({Key? key}) : super(key: key);

  @override
  State<OnDuty> createState() => _OnDutyState();
}

class _OnDutyState extends State<OnDuty> with TickerProviderStateMixin {
  int? totalPeople = 0;
  final controllerGetX = Get.put(MyGetXController());
  List<bool> _isOpen = [false, false];

  late TabController _tabController;
  static const List<Tab> myTabs = <Tab>[
    Tab(text: 'LEFT'),
    Tab(text: 'RIGHT'),
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
  void didUpdateWidget(covariant OnDuty oldWidget) {
    super.didUpdateWidget(oldWidget);
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
              padding:  const EdgeInsets.symmetric(vertical:8,horizontal:kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_16),
              child: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: width,
                        child: Center(child: textCustom(MyString.label_rosteronduty, 18)),
                        // textCustomColor(
                        //         '(${stringFormat.formatDateWithSplash(today)})',
                        //         12,
                        //         MyColor.grey),
                      ),
                      // const SizedBox(height: 5),
                      // TextFormField(
                      //   controller: mySearchController,
                      //   maxLines: 1,
                      //   scrollPadding: const EdgeInsets.all(0),
                      //   onFieldSubmitted: (value) {
                      //     int count = 0;
                      //     count++;
                      //     if (count == 1) {
                      //       setState(() {
                      //         mySearchValue = value;
                      //         getSearchResultDataFilter(value,userListFilter).then(
                      //             (value) => userListFilter?.toSet().toList());
                      //       });
                      //       debugPrint('onchangevalue: $value  $mySearchValue');
                      //     }
                      //     debugPrint(
                      //         'total list size: ${userListFilter?.length} $count');
                      //   },
                      //   onChanged: (value) {},
                      //   decoration: const InputDecoration(
                      //       fillColor: Color(0xFFf2f2f2),
                      //       filled: true,
                      //       isDense: true,
                      //       enabledBorder: OutlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: Colors.grey, width: 0.5),
                      //       ),
                      //       focusedBorder: OutlineInputBorder(
                      //         borderSide:
                      //             BorderSide(color: Colors.grey, width: 0.5),
                      //       ),
                      //       contentPadding: EdgeInsets.only(
                      //           left: 0, bottom: 0, top: 0, right: 0),
                      //       prefixIcon: Icon(Icons.search),
                      //       hintText: 'search staffs',
                      //       hintStyle: TextStyle(fontSize: 12)),
                      // ),
                      const SizedBox(height: 10),
                      textCustomColor('All Groups', 12, MyColor.grey),
                      const SizedBox(height: 5),
                      Expanded(
                          flex: 1,
                          // child: mySearchValue.isEmpty
                          //     ? buildListViewBody(width, height,userList)
                          //     : buildListViewBodyFilter(
                          //         width, height, 'thomas',userListFilter)
                          child: FutureBuilder(
                            future: getListGroup(),
                            builder: (context, snapshot) {
                              late final listGR =
                                  snapshot.data as List<ListGroup>;
                              if (!snapshot.hasData) {
                                return Center(child: myprogresscircular());
                              } else if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return Center(child: myprogresscircular());
                              }
                              if (snapshot.hasError) {
                                return Center(child: textCustom(MyString.onduty_error, 12));
                              }
                              return ListView.builder(
                                itemCount: listGR.first.listGroup.length,
                                itemBuilder: (context, index) {
                                  return itemListDuty(
                                    onPress: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  OnDutyDetail(
                                                    group: listGR.first
                                                        .listGroup[index].name,
                                                    color: listGR.first
                                                        .listGroup[index].color,
                                                  )));
                                    },
                                    context: context,
                                    id: (index + 1).toString(),
                                    color:(listGR.first.listGroup[index].color!=null || listGR.first.listGroup[index].color!='' )?  Color(int.parse(listGR.first.listGroup[index].color)) : MyColor.grey_tab,
                                    hasChild: false,
                                    itemWidth: width,
                                    text: listGR.first.listGroup[index].name,
                                  );
                                },
                              );
                            },
                          )
                         ),
                    ],
                  )))),
    );
  }
}
