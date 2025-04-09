import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/text.dart';

Widget myButton({onPress, text, width, isReady}) {
  return SizedBox(
      width: width,
      child: ElevatedButton(
        child: Text(text),
        onPressed: () {
          onPress();
        },
        style: ElevatedButton.styleFrom(
            elevation: 1.0,
            primary: isReady == true ? Colors.blue : Colors.grey,
      						padding: const EdgeInsets.symmetric(horizontal: DefaultValue.padding_32,vertical:DefaultValue.padding_16),
            textStyle: const TextStyle(fontFamily: MyString.main_fontFamily, fontSize: 16, fontWeight: FontWeight.normal)),
      ));
}

Widget myBlueButton({onPress, text, isReady}) {
  return InkWell(
    onTap: () {
      onPress();
    },
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: DefaultValue.padding_32,vertical:DefaultValue.padding_8),
						child: textCustomColor(text, 16, isReady ==true ? MyColor.white : MyColor.black_text),
      decoration: BoxDecoration(
          color: isReady == true ? MyColor.bluefb : MyColor.grey_tab,
          borderRadius: BorderRadius.circular(DefaultValue.padding_16)),
    ),
  );
}

Widget circleCloseButton(Function onPress, TextEditingController controller) {
  return controller.text.isNotEmpty
      ? IconButton(
          onPressed: () {
            onPress();
          },
          icon: const Icon(
            Icons.close,
          ),
        )
      : const SizedBox(height: 0.0, width: 0);
}

Widget circleCloseIconButton(TextEditingController controller, String text) {
  return text.isNotEmpty
      ? IconButton(
          onPressed: () {
            controller.clear();
          },
          icon: const Icon(
            Icons.close,
          ),
        )
      : const SizedBox(height: 0.0, width: 0);
}

Widget eyeButton(Function onPress, bool isObsecure) {
  return IconButton(
    onPressed: () {
      onPress();
    },
    icon: Icon(
      isObsecure ? Icons.visibility : Icons.visibility_off,
    ),
  );
}
