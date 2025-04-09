import 'package:flutter/material.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Widget/text.dart';

import '../../Util/color.dart';

Widget itemListDuty(
    {itemWidth, text, color, hasChild = false, id, context,Function? onPress}) {
  return GestureDetector(
			onTap: (){
				onPress!();
			},
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7.5),
      margin: const EdgeInsets.only(bottom: 5),
      alignment: Alignment.center,
      width: itemWidth,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey, width: 0.5)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          textWithColorBox(textCustom(id, 16)),
          const SizedBox(width: 15),
          textCustom(text, 14),
         
        ],
      ),
    ),
  );
}
