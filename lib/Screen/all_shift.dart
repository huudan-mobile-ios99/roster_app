import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AllShift extends StatefulWidget {
  const AllShift({ Key? key }) : super(key: key);

  @override
  State<AllShift> createState() => _AllShiftState();
}

class _AllShiftState extends State<AllShift> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: textCustomColor('All shift', 16, MyColor.black_text),
      ),
      body: SafeArea(child: Container(child:textCustom('all shift', 12))),
    );
  }
}