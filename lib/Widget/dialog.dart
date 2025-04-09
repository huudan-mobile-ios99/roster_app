import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Widget dialogAlertBody(
    {height,
    width,
    title,
    onPress,
    widget,
    context,
    subtitle,
    isTitleWidget = false,
    widgetTitle,
    textButton2,
    bool hasRequestBtn = false,
    functionRequest}) {
  return AlertDialog(
    title: isTitleWidget == true ? widgetTitle : Text(title),
    content: SizedBox(height:kIsWeb ? height*2/3 :  height , width: kIsWeb ? width/2 : width, child: widget),
    actions: [
      hasRequestBtn == true
          ? TextButton(
              child:  Text(textButton2),
              onPressed: () {
                functionRequest();
              },
            )
          : Container(),
      TextButton(
        child: const Text(MyString.cancelButton),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
    ],
  );
}

Widget dialogAlertBodyYN({height, width, title, onPress, context, subtitle}) {
  return AlertDialog(
    title: Text(title),
    actions: [
      TextButton(
        child: const Text(MyString.cancelButton),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      TextButton(
        child: const Text('YES'),
        onPressed: () {
          onPress();
        },
      ),
    ],
  );
}
