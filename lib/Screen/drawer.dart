import 'package:flutter/material.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/text.dart';

class MyDrawer extends StatefulWidget {
  const MyDrawer({Key? key}) : super(key: key);

  @override
  State<MyDrawer> createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {
  String? name, number;
  @override
  void initState() {
    getUserDataSave().then(
      (value) {
        UserSave user = value;
        setState(() {
          name = user.name;
          number = user.number;
        });
      },
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
          //  (name!.isNotEmpty || number!.isNotEmpty) ? 
          //  buildDrawerItem(
          //       routeName: '/createUser',
          //       text: 'Create new user',
          //       icon: const Icon(Icons.add, size: 24)) ,
            // :
            // Container(),
            // buildDrawerItem(
            //     routeName: '/updateUser',
            //     text: 'Update user',
            //     icon: const Icon(Icons.update_rounded, size: 24)),
          //  (name!.isNotEmpty || number!.isNotEmpty) ?  
											const SizedBox(height: DefaultValue.padding_16,),
											textCustom(MyString.label_menu_drawer, 18),
											const SizedBox(height: DefaultValue.padding_8,),
           buildDrawerItem(
                routeName: '/eventLog',
                text: 'Event log',
                icon: const Icon(Icons.event_sharp, size: 24)),
            // :
            // Container(),
            // buildDrawerItem(routeName: '/allShift',text: 'View work shift history',icon: const Icon(Icons.view_agenda, size: 24)),
            buildDrawerItem(
                routeName: '/shiftTime',
                text: 'View work shift time',
                icon: const Icon(Icons.timelapse, size: 24)),
            // buildDrawerItem(routeName: '/setupDate',text: 'Set up dates',icon: const Icon(Icons.date_range,size: 24)),
            // buildDrawerItem(routeName: '/colorMap',text: 'View group color map',icon: const Icon(Icons.color_lens,size: 24)),
          ],
        ),
      ),
    );
  }

  Widget buildDrawerItem({
    routeName,
    text,
    Icon? icon,
  }) {
    return Card(
        child: ListTile(
            dense: true,
            leading: IconButton(
                onPressed: () {
                  debugPrint('click move  user');
                  Navigator.of(context).pushNamed(routeName);
                },
                icon: icon!),
            title: textCustom(text, 16)));
  }
}
