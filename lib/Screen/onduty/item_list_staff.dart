import 'package:flutter/material.dart';
import 'package:vegas_roster/Screen/onduty/compare_time.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

import '../../APIs/service_apis.dart';

Widget itemListStaff({color,index,name,shift,bool isActive =false,list,image,date,context,height,width,startTime,endTime}){
  return Opacity( opacity: isActive ==false ? .5 : 1,
                    child: InkWell(
                      splashColor:MyColor.grey_tab,
                      onTap: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialogAlertBody(
                                context: context,
                                height: height/4,
                                isTitleWidget: true,
                                widgetTitle: textCustom(
                                    '${list[index].name} detail', 16),
                                width: width,
                                widget: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(Icons.work,
                                            color: MyColor.grey, size: 18),
                                        const SizedBox(width: 10),
                                        textCustom(
                                            shift,
                                            14),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(Icons.watch_later_outlined,
                                            color: MyColor.grey, size: 18),
                                        const SizedBox(width: 10),
                                        textCustom(
                                            '${stringFormat.FormatTime(startTime)} - ${stringFormat.FormatTime(endTime)}   ${stringFormat.formatDate(DateTime.now())}',
                                            14),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Icon(
                                            getTime(
                                                        today: DateTime.now(),
                                                        startTime: startTime,
                                                        endTime: endTime) ==
                                                    true
                                                ? Icons.check_box_outlined
                                                : Icons.check_box_outline_blank,
                                            color: MyColor.grey,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        textCustom(
                                            getTime(
                                                        today: DateTime.now(),
                                                        startTime: startTime,
                                                        endTime: endTime) ==
                                                    true
                                                ? 'Available'
                                                : 'UnAvailable',
                                            14),
                                      ],
                                    ),
                                  ],
                                ),
                                onPress: () {
                                  debugPrint('onPress');
                                });
                          });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(2.5),
                          border: Border.all(
                            color:  isActive ==false? MyColor.grey_tab: Color(int.parse(color!)),
                            width: 1,
                          ),
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                                padding: const EdgeInsets.all(7.5),
                                child:ClipOval(
                                  child: Image.network(
                                    image,
                                    fit: BoxFit.cover,
                                    loadingBuilder:(context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Center(child: myprogresscircular());
                                    },
                                    errorBuilder: (context, error, stackTrace) => Icon(Icons.person, color: MyColor.grey),
                                  ),
                                )),
                            // Positioned(
                            //   top:10,
                            //   child: textCustom(date, 10)),
                            Positioned(
                                bottom: 5,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 3.5, vertical: 1.5),
                                    decoration: BoxDecoration(
                                      boxShadow: [
                                        BoxShadow(
                                          color: MyColor.grey,
                                        )
                                      ],
                                      borderRadius: BorderRadius.circular(2.5),
                                      color: MyColor.white,
                                    ),
                                    child: textCustomColor('${name}', 10,Colors.black))),
                           
                          ],
                        ),
                      ),
                    ),
                  );
}