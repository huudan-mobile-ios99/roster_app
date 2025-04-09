 import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Widget/text.dart';
import '../../APIs/service_apis.dart';

Widget textWithColorBox(widget) {
    return Container(
        padding: const EdgeInsets.all(DefaultValue.padding_8),
        decoration: BoxDecoration(
          color: MyColor.grey_tab,
          borderRadius: BorderRadius.circular(5),
        ),
        child: widget);
  }

  Widget itemEventLog({index, String? time, body,width}) {
    return Container(
      margin: const EdgeInsets.only(bottom:5),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: MyColor.white,
        border: Border.all(color: MyColor.grey_tab, width: .5),
        borderRadius: BorderRadius.circular(5),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width/11,
            child: textCustomColor(index.toString(), 12,MyColor.grey),
          ),
          
          SizedBox(
            width:width/11*1.5,
            child: textCustomColor('${(time)}', 14,MyColor.black_text)),
          
          Expanded(
              child: textCustomColor(
                  body, 13, MyColor.black_text)),
        ],
      ),
    );
  }