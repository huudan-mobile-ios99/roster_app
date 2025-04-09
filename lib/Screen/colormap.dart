import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Widget/text.dart';

class ColorMap extends StatefulWidget {
  const ColorMap({Key? key}) : super(key: key);

  @override
  State<ColorMap> createState() => _ColorMapState();
}

class _ColorMapState extends State<ColorMap> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: textCustomColor('Color map', 16, MyColor.black_text),
      ),
      body: SafeArea(
        child: Container(child: textCustom('color map', 12)),
      ),
    );
  }
}
