import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';

Widget itemGroup({itemWidth, isActive, text,bool isRostserPrev =false}) {
    return Container(
        margin: const EdgeInsets.only(right: 10),
								padding: const EdgeInsets.symmetric(horizontal: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color: isActive
                ? MyColor.blue
                : MyColor.grey_tab.withOpacity(1),
            border: Border.all(color:isRostserPrev ==false? Colors.blue:MyColor.green, width: 1)),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12,
              color: isActive == true ? MyColor.white : MyColor.black_text),
          textAlign: TextAlign.center,
        ));
  }

		Widget itemGroupBottomDialog({itemWidth, isActive, text,bool isRostserPrev =false}) {
    return Container(
        margin: const EdgeInsets.only(bottom: 5),
								padding: const EdgeInsets.all(DefaultValue.padding_8),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.5),
            color:  MyColor.white,
            border: Border.all(color: MyColor.grey_tab, width: .25)),
        child: Row(
          children: [
												Icon(Icons.group,color:MyColor.grey_tab),
												const SizedBox(width: 25,),
            Text(
              text,
              style: TextStyle(
                  fontSize: 12,
                  color:MyColor.black_text),
              textAlign:TextAlign.left,
            ),
          ],
        ));
  }