import 'package:flutter/material.dart';

class DayM {
  DayM(this.id, this.day, this.isSelected, this.isWeekDay, this.text,this.color);
  int id;
  DateTime day;
  String text;
  String color;
  bool isSelected = false;
  bool isWeekDay = false;
}
