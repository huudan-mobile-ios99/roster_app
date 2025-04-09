import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


import '../../model/user.dart';

class EditRosterDialog extends StatefulWidget {
  String? date,oldRoster;
  final Function? onPress;
  // String? shiftName;
  EditRosterDialog({
    Key? key,
    this.date,
    this.onPress,
    this.oldRoster,
  }) : super(key: key);

  @override
  State<EditRosterDialog> createState() => _EditRosterDialogState();
}

class _EditRosterDialogState extends State<EditRosterDialog> {
  final controller = Get.put(MyGetXController());
  String requestMessage = MyString.edit_dialog;
  String? shiftCode;
  @override
  void dispose() {
    controller.removeShiftCode();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getListShiftCode(),
      builder: (context, snapshot) {
        late final listWorkShift = snapshot.data as List<ShiftList>;
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
        return GetBuilder<MyGetXController>(
          builder: (controller) {
            return dialogAlertBody(
                context: context,
                textButton2: MyString.requestButton,
                functionRequest: () {
                  if (controller.shiftCode.value != MyString.edit_dialog) {
                    widget.onPress!();
                  } else {
                    debugPrint('do nothing');
                  }
                },
                width: width,
                height:kIsWeb?height/2: height/2,
                hasRequestBtn: true,
                widget: SizedBox(
                  width: width,
                  height: height,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                    (controller.shiftCodeOld.value.isEmpty && controller.shiftCode2.value.isEmpty) ?  textCustom(MyString.edit_dialog, 14)  : textCustomColor('Request work shift from ${controller.shiftCodeOld.value} to ${controller.shiftCode2.value}', 14, MyColor.black_text.withOpacity(.75)),
                      Expanded(
                          flex: 1,
                          child: GridView.builder(
                              itemCount: listWorkShift.first.shiftItem.length,
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:kIsWeb? 6 : 5,
                                childAspectRatio: 1,
                                mainAxisSpacing: 5,
                              ),
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    // setState(() {
                                    //   shiftCode = listWorkShift
                                    //       .first.shiftItem[index].shiftCode;
                                    //   requestMessage =
                                    //       MyString.edit_dialog_withdata +
                                    //           listWorkShift
                                    //               .first.shiftItem[index].shiftCode;
                                    // });
                                    debugPrint('click: $index ${listWorkShift.first.shiftItem[index].shiftCode}');
                                    controller.saveShiftCode(
                                        (MyString.edit_dialog_withdata +
                                                listWorkShift.first
                                                    .shiftItem[index].shiftCode)
                                            .obs,
                                        listWorkShift.first.shiftItem[index]
                                            .shiftCode.obs,(widget.oldRoster).toString().obs);
                                  },
                                  child: Card(
                                    elevation: 1,
                                    color: listWorkShift
                                                .first.shiftItem[index].type ==
                                            'OFF'
                                        ? MyColor.yellow
                                        : MyColor.white,
                                    shadowColor: listWorkShift
                                                .first.shiftItem[index].type ==
                                            "A"
                                        ? MyColor.blue
                                        : listWorkShift.first.shiftItem[index]
                                                    .type ==
                                                "B"
                                            ? MyColor.green
                                            : listWorkShift
                                                        .first
                                                        .shiftItem[index]
                                                        .type ==
                                                    "C"
                                                ? MyColor.red
                                                : MyColor.grey,
                                    child: Center(
                                      child: textCustom(
                                          '${listWorkShift.first.shiftItem[index].shiftCode}',
                                          16),
                                    ),
                                  ),
                                );
                              }))
                    ],
                  ),
                ),
                title: widget.date);
          },
        );
      },
    );
  }
}
