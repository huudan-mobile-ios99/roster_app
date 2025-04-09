import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

import '../Model/user.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
          alignment: Alignment.center,
          height: height,
          width: width,
          child: FutureBuilder(
            future: getSearchGroup('IT Technical'),
            builder: (context, snapshot) {
              late final list = snapshot.data as List<User>;
              if (snapshot.connectionState == ConnectionState.waiting) {
                return myprogresscircular();
              }
              if (!snapshot.hasData) {
                return textCustom('no data', 16);
              }
              return textCustom(list.length.toString()+list.first.name, 16);
            },
          )),
    );
  }

  
}
