import 'dart:io' show Platform, exit;
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Screen/editUser/edit.dart';
import 'package:vegas_roster/Screen/notification/notification.dart';
import 'package:vegas_roster/Screen/onduty/onduty.dart';
import 'package:vegas_roster/Screen/roster/roster.dart';
import 'package:vegas_roster/Screen/roster/roster_prev.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/text.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final controllerX = Get.put(MyGetXController());
  int selectedIndex = 0; //New
  List<Widget> children = [
    RosterPrev(),
    Edit(),
    const OnDuty(),
    const NotificationPage(),
  ];
  //New
  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
          onWillPop: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: textCustom(MyString.title_closeTheApp, 16),
                    actions: [
                      TextButton(
                          onPressed: () {
                            if (Platform.isAndroid) {
                              SystemNavigator.pop();
                            } else if (Platform.isIOS) {
                              exit(0);
                            }
                          },
                          child: textCustom('YES', 16)),
                      TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: textCustom('NO', 16))
                    ],
                  );
                });
            return false;
          },
          child: children[selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex, //New
        onTap: onItemTapped,
        iconSize: 28,
        backgroundColor: MyColor.grey_tab,
        selectedItemColor: Colors.blueAccent,
        unselectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        showUnselectedLabels: false,
        showSelectedLabels: false,
        unselectedItemColor: MyColor.grey,
        selectedLabelStyle: const TextStyle(fontSize: 12, color: Colors.grey),
        items: <BottomNavigationBarItem>[
          const BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Roster',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.edit),
            label: 'Edit',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.online_prediction),
            label: 'On Duty',
          ),
          BottomNavigationBarItem(
            icon: Stack(children: <Widget>[
              const Icon(Icons.notifications),
              Positioned(
                  // draw a red marble
                  top: 0.0,
                  right: 0.0,
                  child: 
                  GetX<MyGetXController>(builder: (controller) {
                    return controller.totalNotification.value >0 ? Container(
                        padding: const EdgeInsets.all(.5),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadiusDirectional.circular(2.5),
                          color: MyColor.red,
                        ),
                        child: 
                        textCustomColor(
                            controller.totalNotification.value >= 99
                                ? '99+'
                                : '${controller.totalNotification.value}',
                            11,
                            MyColor.white),
                        ) : Container();
                  })
                  )
            ]),
            label: 'Notifications',
          ),
        ],
      ),
    );
  }
}
