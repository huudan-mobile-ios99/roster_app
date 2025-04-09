import 'package:flutter/material.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/widget_roster/item_roster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

Widget itemNotification(
    {itemWidth,
    text,
    textDate,
    index,
    onPress,
    isSeen,
    isToday = false,
    isEnable = false,
    isPassDay = false,
    hasDateText = false,
    double verticalPadding = 0.0,
    item,
    isUser = true,
    onPressRemove,
    onPressDecline,
    onPressApprove}) {
  return Container(
    padding: EdgeInsets.symmetric(vertical: verticalPadding),
    width: itemWidth,
    margin: const EdgeInsets.only(bottom: 10),
    decoration: BoxDecoration(
        color: isPassDay == true ? MyColor.grey_tab : MyColor.white,
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
            color:
                isToday == false ? MyColor.grey.withOpacity(.75) : MyColor.red,
            width: .75)),
    child: Slidable(
      direction: Axis.horizontal,
      enabled: isEnable,
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        children: [
         isUser == false ? SlidableAction(
            padding: const EdgeInsets.all(0),
            spacing: 1,
            flex: 1,
            onPressed: (context) {
              onPressApprove();
            },
            backgroundColor: MyColor.blue,
            foregroundColor: Colors.white,
            // icon: Icons.approval,
            label: 'Approve',
          ):Container(),
          SlidableAction(
            spacing: 1,
            padding: const EdgeInsets.all(0),
            flex: 1,
            onPressed: (context) {
             isUser == false ? onPressDecline() : onPressRemove();
              
            },
            backgroundColor: MyColor.red_text,
            foregroundColor: Colors.white,
            // icon: Icons.remove_circle,
            label: 'Remove',
          ),
        ],
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 3.5),
        child: Row(
          children: [
            SizedBox(
                width: itemWidth / 10,
                child: Container(
                    alignment: Alignment.center,
                    // padding: const EdgeInsets.symmetric(horizontal:5,vertical: 5),
                    child: textCustomColor(index, 16, Colors.blueAccent))),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                textCustom(text, 12),
                hasDateText == true ? const SizedBox(height: 2.5) : Container(),
                hasDateText == true
                    ? textCustomColor(textDate, 12, MyColor.grey)
                    : Container(),
              ],
            )),
            // SizedBox(
            //     width: itemWidth / 10,
            //     child: IconButton(
            //         onPressed: () {
            //           onPress();
            //         },
            //         icon: const Icon(Icons.more_vert,color:Colors.grey)))
          ],
        ),
      ),
    ),
  );
}
