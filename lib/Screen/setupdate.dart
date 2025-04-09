import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/dateroster.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function_date_edit.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/button.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class SetUpDate extends StatefulWidget {
  const SetUpDate({Key? key}) : super(key: key);

  @override
  State<SetUpDate> createState() => _SetUpDateState();
}

class _SetUpDateState extends State<SetUpDate> {
  DateTime selectedDateStart = DateTime.now();
  bool valueCheckBox = false;
  DateTime selectedDateEnd = DateTime.now();
  final stringFormat = StringFormat();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateStart,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateStart) {
      setState(() {
        selectedDateStart = picked;
      });
    }
  }

  Future<void> _selectDateEnd(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDateEnd,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDateEnd) {
      setState(() {
        selectedDateEnd = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: const BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        title: textCustomColor('Set up dates', 16, MyColor.black_text),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 8),
        height: height,
        width: width,
        color: MyColor.white,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              height: height,
              width: width / 2,
              child: Column(
                children: [
                  textCustom('Create dates ', 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textCustom(
                          "${selectedDateStart.toLocal()}".split(' ')[0], 12),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () => _selectDate(context),
                        child: textCustom('Select start', 12),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textCustom(
                          "${selectedDateEnd.toLocal()}".split(' ')[0], 12),
                      SizedBox(
                        height: 5.0,
                      ),
                      TextButton(
                        onPressed: () => _selectDateEnd(context),
                        child: textCustom('Select end', 12),
                      ),
                    ],
                  ),
                  myButton(
                    onPress: () {
                      if (stringFormat.formatDate(selectedDateStart) !=
                              stringFormat.formatDate(DateTime.now()) &&
                          stringFormat.formatDate(selectedDateEnd) !=
                              stringFormat.formatDate(DateTime.now())) {
                        debugPrint('run create date');
                        createNewDateForShift(
                          context: context,
                          end: Timestamp.fromDate(selectedDateEnd),
                          start: Timestamp.fromDate(selectedDateStart),
                          isactive: true,
                        );
                      } else {
                        debugPrint('can not run this');
                      }
                    },
                    isReady: true,
                    text: 'create date',
                    width: width / 2,
                  )
                ],
              ),
            ),
            Container(
              height: height,
              width: width / 2,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      textCustom('List all dates', 16),
                      Material(
                        
                        child: InkWell(
                          
                            onTap: () {
                              setState(() {});
                            },
                            child: textCustom('Refresh', 12)),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Expanded(
                    flex: 1,
                    child: FutureBuilder(
                      future: getStartDateFromServerTOLIST(),
                      builder: (context, snapshot) {
                        late final list = snapshot.data as List<DateRosterM>;
                        if (!snapshot.hasData) {
                          return Center(child: myprogresscircular());
                        }
                        return ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return dialogAlertBody(
                                          context: context,
                                          height: height / 2,
                                          isTitleWidget: false,
                                          onPress: () {},
                                          title: 'Edit this date',
                                          width: width,
                                          widget: ListView(
                                            padding:const EdgeInsets.all(0),
                                            children: [
                                              textCustom(
                                              'start date: ${stringFormat.formatDateWithSplashFULL(list[index].start.toDate())}',
                                              12),
                                              textCustom(
                                              'end date: ${stringFormat.formatDateWithSplashFULL(list[index].end.toDate())}',
                                              12),
                                              textCustom(
                                              'isActive: ${list[index].isActive}',
                                              12),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  ElevatedButton(
                                                      onPressed: () {
                                                        deleteDateForShift(
                                                          context: context,end: Timestamp.fromDate(list[index].end.toDate()),start: Timestamp.fromDate(list[index].start.toDate()),isactive: list[index].isActive,
                                                        );
                                                      },
                                                      child:textCustom('delete', 12)),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  ElevatedButton(
                                                      onPressed: () {},
                                                      child: textCustom(
                                                          'set active', 12)),
                                                ],
                                              ),
                                            ],
                                          ));
                                    });
                              },
                              child: Container(
                                  margin: const EdgeInsets.only(bottom: 5),
                                  padding: const EdgeInsets.all(2.5),
                                  decoration: BoxDecoration(
                                      color: !list[index].isActive ? MyColor.grey_tab.withOpacity(0.5) :MyColor.white,
                                      border: Border.all(color: MyColor.grey_tab),
                                      borderRadius: BorderRadius.circular(5)),
                                  child: Row(
                                    children: [
                                      textCustom('$index', 14),
                                      Expanded(
                                          child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          textCustom(
                                              'start date: ${stringFormat.formatDate(list[index].start.toDate())}',
                                              12),
                                          textCustom(
                                              'end date: ${stringFormat.formatDate(list[index].end.toDate())}',
                                              12),
                                        ],
                                      ))
                                    ],
                                  )),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
