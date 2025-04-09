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


class UnActiveOnduty extends StatefulWidget {
  final String? groupName, color;
  UnActiveOnduty({this.groupName, this.color});

  @override
  State<UnActiveOnduty> createState() => _UnActiveOndutyState();
}

class _UnActiveOndutyState extends State<UnActiveOnduty> {
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
                  // return textCustom('${list[index].name} ${list[index].shift.first.shiftName}', 10);
                  return getTime(
                              today: DateTime.now(),
                              startTime: list[index].shift.first.date.toDate(),
                              endTime: list[index].shift.last.date.toDate()) ==
                          false
                      ? itemListStaff(
                    context: context,
                    height:height,width:width,
                    index: index,
                    image: list[index].image,
                    // date: stringFormat.FormatTime(list[index].shift.first.date.toDate()) + stringFormat.FormatTime(list[index].shift.last.date.toDate()) ,
                    list: list,
                    isActive: false,
                    shift: list[index].shift.first.shiftName,
                    name: list[index].name,
                    startTime: (list[index].shift.first.date.toDate()) ,
                    endTime: (list[index].shift.last.date.toDate()),
                    color: widget.color!,
                  ) : Container();
                },
              )
            : Center(child: textCustom(MyString.onduty_nostaff2, 12));
      },
    );
  }
}
