import 'package:flutter/material.dart';

Widget myprogresscircular() {
  return const CircularProgressIndicator(
    strokeWidth: 1,
    // valueColor: new AlwaysStoppedAnimation<Color>(MyColor.red),
  );
}
Widget myprogresscircularSmall() {
  return  const SizedBox(
    height:25,width:25,
    child: CircularProgressIndicator(
      strokeWidth: 0.5,
      // valueColor: new AlwaysStoppedAnimation<Color>(MyColor.red),
    ),
  );
}


