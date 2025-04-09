import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/home.dart';
import 'package:vegas_roster/Screen/login.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';

class Authentication extends StatefulWidget {
  const Authentication({Key? key}) : super(key: key);
  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  bool checkbox = false;
  bool checkbox1 = false;
  String userID = '';
  @override
  void initState() {
    super.initState();
    getCheckBoxSave().then(
      (value) {
        setState(() {
          checkbox = value;
        });
        debugPrint('value checkBox: $checkbox');
      },
    );
    getUserDataSave().then((value) {
      late final UserSave user;
      user = value;
      setState(() {
        userID = user.id;
      });
      // debugPrint('user i can get in authen: ${user.id}');
    });
  }

 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
        future: getCheckBoxSave(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: myprogresscircular());
          } else if (!snapshot.hasData) {
            return Center(
              child: myprogresscircular(),
            );
          }
          final checkBoxValue = snapshot.data as bool;

          return checkBoxValue == true ? const HomePage() : const Login();
        },
      ),
    );
  }
}
