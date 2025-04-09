import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/shift.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ShiftTime extends StatefulWidget {
  const ShiftTime({Key? key}) : super(key: key);

  @override
  State<ShiftTime> createState() => _ShiftTimeState();
}

class _ShiftTimeState extends State<ShiftTime> {
  @override
  Widget build(BuildContext context) {
			 final width = MediaQuery.of(context).size.width;
				 final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        leading: const BackButton(color: Colors.white),
        title: textCustomColor('Shift time', 16, MyColor.white),
      ),
      body: SafeArea(
          child: Container(
											width: width,
											height:height,
										 padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_8, vertical: DefaultValue.padding_8),

            child: FutureBuilder(
        future: getListShiftCode(),
        builder: (context, snapshot) {
            late final listWork = snapshot.data as List<ShiftList>;
            late final listWorkShift =
                listWork.first.shiftItem as List<ShiftItem>;
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: myprogresscircular());
            }
            if (!snapshot.hasData) {
              return Center(
                  child: Container(
                      padding: const EdgeInsets.all(15),
                      decoration: BoxDecoration(
                          color: MyColor.white,
                          borderRadius: BorderRadius.circular(7.5)),
                      child: textCustom(MyString.roster_no_itemshift, 12)));
            }
            return ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: listWorkShift.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                    dense: true,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        textCustomColor(listWorkShift[index].shiftCode.toUpperCase(),16,Colors.blue),
                        textCustomColor(listWorkShift[index].shiftTime,14,MyColor.black_text),
                      ],
                    ),
                  ));
                });
        },
      ),
          )),
    );
  }
}
