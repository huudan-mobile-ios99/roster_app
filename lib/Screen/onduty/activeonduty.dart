import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Screen/onduty/compare_time.dart';
import 'package:vegas_roster/Screen/onduty/item_list_staff.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import '../../Model/user.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ActiveOnduty extends StatefulWidget {
  final String? groupName, color;
  ActiveOnduty({this.groupName, this.color});

  @override
  State<ActiveOnduty> createState() => _ActiveOndutyState();
}

class _ActiveOndutyState extends State<ActiveOnduty> {
  @override
  void initState() {
    
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return FutureBuilder(
      future: getSearchResultData2('${widget.groupName}'),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: myprogresscircular());
        }
        if (!snapshot.hasData || snapshot.hasError) {
          return Center(child: textCustom(MyString.onduty_error, 12));
        }
        late final list = snapshot.data as List<User>;

        // return textCustom('text', 12);
        return list.isNotEmpty
            ? GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:kIsWeb? 7 :  5,
                  crossAxisSpacing: kIsWeb ? DefaultValue.padding_16 : DefaultValue.padding_8,
                  childAspectRatio: 1,
                  mainAxisSpacing: kIsWeb ? DefaultValue.padding_16 : DefaultValue.padding_8,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return
                  getTime(
                              today: DateTime.now(),
                              startTime: list[index].shift.first.date.toDate(),
                              endTime: list[index].shift.last.date.toDate()) ==
                          true
                      ?
                   itemListStaff(
                    context: context,
                    height: height,
                    width: width,
                    index: index,
                    image: list[index].image,
                    list: list,
                    isActive:true,
                    shift: list[index].shift.first.shiftName,
                    name: list[index].name,
                    startTime: DateTime.now(),
                    endTime:  DateTime.now(),
                    color: widget.color!,
                  )
                  :Container()
                  ;
                },
              )
            : Center(child: textCustom(MyString.onduty_nostaff2, 12));
      },
    );

    // FutureBuilder(
    //   future: getSearchResultData('${widget.groupName}'),
    //   builder: (context, snapshot) {
    //     if (snapshot.connectionState == ConnectionState.waiting) {
    //       return Center(child: myprogresscircular());
    //     }
    //     if (!snapshot.hasData || snapshot.hasError) {
    //       return Center(child: textCustom(MyString.onduty_error, 12));
    //     }
    //     late final list = snapshot.data as List<User>;

    //     // return textCustom('text', 12);
    //     return list.isNotEmpty
    //         ? GridView.builder(
    //             gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
    //               crossAxisCount: 5,
    //               crossAxisSpacing: 5,
    //               childAspectRatio: 1,
    //               mainAxisSpacing: 5,
    //             ),
    //             itemCount: list.length,
    //             itemBuilder: (context, index) {
    //               // return textCustom('${list[index].name} ${list[index].shift.first.shiftName}', 10);
    //               return getTime(
    //                           today: DateTime.now(),
    //                           startTime: list[index].shift.first.date.toDate(),
    //                           endTime: list[index].shift.last.date.toDate()) ==
    //                       true
    //                   ?
    //                   itemListStaff(
    //                 context: context,
    //                 height:height,width:width,
    //                 index: index,
    //                 image: list[index].image,
    //                 list: list,
    //                 isActive: true,
    //                 shift: list[index].shift.first.shiftName,
    //                 name: list[index].name,
    //                 startTime: (list[index].shift.first.date.toDate()) ,
    //                 endTime: (list[index].shift.last.date.toDate()),
    //                 color: widget.color!,
    //               )

    //               : Container();
    //             },
    //           )
    //         : Center(child: textCustom(MyString.onduty_nostaff2, 12));
    //   },
    // );
  }
}
