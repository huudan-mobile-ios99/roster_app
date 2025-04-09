// set up the AlertDialog
  import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/button.dart';

AlertDialog alert = AlertDialog(
    title: Text("Notice"),
    content: Text("Do you want to log out?"),
    actions: [
      cancelButton,launchButton
    ],
  );

   Widget cancelButton = TextButton(
    child: Text(MyString.cancelButton),
    onPressed:  () {
      
    },
  );
  Widget launchButton = TextButton(
    child: Text("YES"),
    onPressed:  () {},
  );
  