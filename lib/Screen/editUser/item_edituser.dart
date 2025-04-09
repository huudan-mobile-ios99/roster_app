import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Screen/widget_roster/mysnackbar.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/global.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


Widget dialogDetailBody(
    {width,
				context,
    height,
    index,
    dateFromList,
    shiftName,
    userName,
    List<ShiftItem>? listWorkShift,
    id,
    nameSave,
    numberSave,
    List<DayM>? listDays}) {
  return dialogAlertBody(
      context: context,
      width:  width,
      height:kIsWeb ? height: height / 2,
      widget: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textCustom(MyString.roster_pickdate_title, 12),
            Expanded(
                flex: 1,
                child: GridView.builder(
                    itemCount: listWorkShift?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount:kIsWeb? 6: 5,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          debugPrint('dateTime and ID : $dateFromList $id shiftOLD: $shiftName shiftNew: ${listWorkShift?[index].shiftCode}');
                          String actionEventLog = 'Edit';

                          if (shiftName == null || shiftName == '') {
                            actionEventLog = 'Create';
                          }
                          debugPrint('id item edituser: ${id}');
                          // removeTodayShift(
                          //   id: id,
                          //   date: dateFromList,
                          //   dateCollectionName:stringFormat.formatDate(dateFromList),
                          // ).then((value) {
                          //   createTodayShift(
                          //       dateCollectionName:stringFormat.formatDate(dateFromList),
                          //       date: dateFromList,
                          //       id: id,
                          //       shiftName: listWorkShift?[index].shiftCode,
                          //     );
                          // });
																										if(listWorkShift?[index].shiftCode =="remove"){

																										}else{
																											print('date from list: ${dateFromList}') ;
																											removeMapDataFromCollection(
                                  id: id,
                                  date: dateFromList,
                                  shiftName: listWorkShift?[index].shiftCode,
                                  subCollectionName: stringFormat.formatDate(listDays?.first.day))
                              .then((value) {
                            if (shiftName != listWorkShift?[index].shiftCode) {
                              createMapDataToCollection(
                                  id: id,
                                  date: dateFromList,
                                  shiftName: listWorkShift?[index].shiftCode,
                                  subCollectionName: stringFormat.formatDate(listDays?.first.day)).then((value) {
																																			kIsWeb ? ScaffoldMessenger.of(myGlobals.scaffoldKey.currentContext!).showSnackBar(mysnackBar('${MyString.roster_setupworkshift_successful} ${listWorkShift?[index].shiftCode}'))  : null ; 
																																		});
                              createEventLog(
                                  date: stringFormat.formatDate(DateTime.now()),
                                  name: nameSave,
                                  number: numberSave,
                                  time: stringFormat.FormatTime(DateTime.now()),
                                  body:'$actionEventLog $userName shift from $shiftName to ${listWorkShift?[index].shiftCode} / day: ${stringFormat.formatDate(dateFromList)}');
                            }
                          });
																										}
                          Navigator.of(context).pop();
                        },
                        child: 
																								Card(
                          elevation: 1,
                          color: listWorkShift?[index].type == 'OFF'
                              ? MyColor.yellow
                              : MyColor.white,
                          shadowColor: listWorkShift?[index].type == "A"
                              ? MyColor.blue
                              : listWorkShift?[index].type == "B"
                                  ? MyColor.green
                                  : listWorkShift?[index].type == "C"
                                      ? MyColor.red
                                      : MyColor.grey,
                          child: Center(
                            child: textCustom(
                                '${listWorkShift?[index].shiftCode}', 16),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      title: '${stringFormat.formatDateWithSplash(listDays?[index].day)}');
}

Widget dialogDetailBodyEDit(
    {width,
    height,
    index,
    dateFromList,
    shiftName,
    userName,
    context,
    List<ShiftItem>? listWorkShift,
    id,
    nameSave,
    numberSave,
    listDays,
    textUpdate}) {
  return dialogAlertBody(
      context: context,
      width: width,
      height: height,
      widget: SizedBox(
        width: width,
        height: height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            textCustom('textUpdate', 14),
            Expanded(
                flex: 1,
                child: GridView.builder(
                    itemCount: listWorkShift?.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      childAspectRatio: 1,
                      mainAxisSpacing: 5,
                    ),
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          String actionEventLog = 'Edit';
                          if (shiftName == null || shiftName == '') {
                            actionEventLog = 'Create';
                          }
                          // Navigator.of(context).pop();
                        },
                        child: Card(
                          elevation: 1,
                          color: listWorkShift?[index].type == 'OFF'
                              ? MyColor.yellow
                              : MyColor.white,
                          shadowColor: listWorkShift?[index].type == "A"
                              ? MyColor.blue
                              : listWorkShift?[index].type == "B"
                                  ? MyColor.green
                                  : listWorkShift?[index].type == "C"
                                      ? MyColor.red
                                      : MyColor.grey,
                          child: Center(
                            child: textCustom(
                                '${listWorkShift?[index].shiftCode}', 16),
                          ),
                        ),
                      );
                    }))
          ],
        ),
      ),
      title: '${stringFormat.formatDateWithSplash(listDays[index].day)}');
}
