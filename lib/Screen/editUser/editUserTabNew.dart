import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/day.dart';
import 'package:vegas_roster/Model/shiftlist.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/editUser/item_edituser.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/function_date_edit.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;


class EditUserTabCurrent extends StatefulWidget {
  String? name, number, vietnameseName, group, id;
  EditUserTabCurrent(
      {this.name, this.number, this.vietnameseName, this.group, this.id});
  @override
  State<EditUserTabCurrent> createState() => _EditUserTabCurrentState();
}

class _EditUserTabCurrentState extends State<EditUserTabCurrent> {
  UserSave? user;
  String? name, role, group, number, vietnamese, id;
  List<Shift> listShift = [];
  List<DayM> listDays = [
    DayM(1, DateTime(2000, 01, 01), false, false, '', 'grey')
  ];

  final stringFormat = StringFormat();
  User? userModel;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    debugPrint('didchangedependencies editTabnew.dart');
  }

  @override
  void initState() {
    debugPrint('initstate edit.dart');
    getStartDateFromServer__().then((value) async {
      await generateDateWITHSTART(listDays, value);
      setState(() {
        listDays = listDays.toSet().toList();
      });
      listDays.removeAt(0);
    });
    getUserDataSave().then(
      (value) {
        user = value;
        setState(() {
          name = user?.name;
          group = user?.group;
          role = user?.role;
          number = user?.number;
          vietnamese = user?.vietnameseName;
          id = user?.id;
        });
      },
    );
  }
  @override
  void dispose() {
    listDays.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        textCustomColor(
            'all date from ${stringFormat.formatDateWithSplash(listDays.first.day)} to ${stringFormat.formatDateWithSplash(listDays.last.day)}',
            12,
            MyColor.black_text),
        const SizedBox(
          height: 5,
        ),
        Expanded(
          child: StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                // .collection('user')
                .collection('user/${widget.id}/${stringFormat.formatDate(listDays.first.day)}')
                .snapshots()
                .asBroadcastStream(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Center(child: myprogresscircular());
              }
              //this is important
              addShiftNametoList_(widget.id, stringFormat.formatDate(listDays.first.day));
              return SizedBox(
                child: GridView.builder(
                  itemCount: listDays.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                     crossAxisCount: kIsWeb ? 6 : 3,
                        childAspectRatio: 1,
                        crossAxisSpacing:kIsWeb? DefaultValue.padding_16 :  DefaultValue.padding_8,
                        mainAxisSpacing:kIsWeb? DefaultValue.padding_16 :  DefaultValue.padding_8,
                  ),
                  itemBuilder: (context, index) {
                    return stringFormat.formatDate(listDays.first.day) ==
                            stringFormat.formatDate(DateTime(2000, 01, 01))
                        ? Container()
                        : GestureDetector(
                            onTap: () {
                              // debugPrint('ontap $index');
                              // debugPrint('data: ${widget.name} ${widget.vietnameseName}');
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return FutureBuilder(
                                    future: getListShiftCode(),
                                    builder: (context, snapshot) {
                                      late final listWorkShift =
                                          snapshot.data as List<ShiftList>;
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(child: myprogresscircular());
                                      }
                                      if (!snapshot.hasData) {
                                        return Center(
                                            child: Container(
                                                padding:
                                                    const EdgeInsets.all(15),
                                                decoration: BoxDecoration(
                                                    color: MyColor.white,
                                                    borderRadius:
                                                        BorderRadius.circular( 7.5)),
                                                child: textCustom(
                                                    MyString.roster_no_itemshift,
                                                    12)));
                                      }
                                      return dialogDetailBody(
                                          userName: '${widget.name}',
                                          width: width,
                                          height: height/2,
                                          index: index,
                                          context: context,
                                          id: widget.id,
                                          nameSave: name,
                                          numberSave: number,
                                          listWorkShift:
                                              listWorkShift.first.shiftItem,
                                          dateFromList: listDays[index].day,
                                          shiftName: listDays[index].text,
                                          listDays: listDays);
                                    },
                                  );
                                },
                              );
                            },
                            child: Card(
                                shadowColor: Colors.blue,
                                elevation: 2.5,
                                child: ListTile(
                                    title: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    textCustomColor(
                                        '${stringFormat.formatDateOnlyDayDDDate(listDays[index].day)}',
                                        13,
                                        MyColor.black_text),
                                    const SizedBox(height: 5),
                                    listDays[index].text == ''
                                        ? textCustomColor(MyString.pickAItem,
                                            12, MyColor.grey)
                                        : Container(
                                            padding: const EdgeInsets.all(7.5),
                                            decoration: BoxDecoration(
                                              color: listDays[index].color ==
                                                      'blue'
                                                  ? MyColor.blue
                                                      .withOpacity(0.35)
                                                  : listDays[index].color ==
                                                          'green'
                                                      ? MyColor.green
                                                          .withOpacity(0.35)
                                                      : listDays[index].color ==
                                                              'red'
                                                          ? MyColor.red
                                                              .withOpacity(0.35)
                                                          : listDays[index]
                                                                      .color ==
                                                                  'yellow'
                                                              ? MyColor.yellow
                                                              : MyColor
                                                                  .grey_tab,
                                              // color: MyColor.grey_tab,
                                              borderRadius:
                                                  BorderRadius.circular(2.5),
                                            ),
                                            child: textCustom(
                                                '${listDays[index].text.toUpperCase()}',
                                                16),
                                          )
                                  ],
                                ))),
                          );
                  },
                ),
              );
            },
          ),
        )
      ],
    );
  }

  Future<List<Shift>> addShiftNametoList_(id, subCollection) async{
     Stream<QuerySnapshot> stream =  FirebaseFirestore.instance
        .collection("user/$id/$subCollection")
        .snapshots()
        .asBroadcastStream();
    stream.forEach((event) {
      event.docs.forEach((value) {
        final model = Shift.fromJson(value.data() as Map<String, dynamic>);
        // debugPrint(model.shiftName);
        listShift.add(model);
      });
    });

    listShift.asMap().forEach((key, value) {
      for (final item in listDays) {
        if (stringFormat.formatDate(item.day) ==
            stringFormat.formatDate(listShift[key].date.toDate())) {
          item.text = listShift[key].shiftName;
          if (listShift[key].shiftName.toUpperCase().contains("A")) {
            item.color = 'blue';
          } else if (listShift[key].shiftName.toUpperCase().contains("B")) {
            item.color = 'green';
          } else if (listShift[key].shiftName.toUpperCase().contains("C")) {
            item.color = 'red';
          } else if (listShift[key].shiftName.toUpperCase().contains("OFF")) {
            item.color = 'yellow';
          } else {
            item.color = 'grey';
          }
        }
      }
    });
    return listShift;
  }
}
