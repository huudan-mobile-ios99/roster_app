import 'package:flutter/material.dart';

Widget textCustom(String text,double fontSize) {
  return  Text(text, style: TextStyle(fontSize: fontSize));
}
Widget textCustomColor(String text,double fontSize,color) {
  return  Text(text, style: TextStyle(fontSize: fontSize,color: color),overflow:TextOverflow.clip,);
}
Widget textCustomColorAlign(String text,double fontSize,color,textAlign) {
  return  Text(text, style: TextStyle(fontSize: fontSize,color: color),overflow:TextOverflow.clip,textAlign: textAlign,);
}

