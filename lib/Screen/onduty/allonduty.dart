




import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Screen/onduty/compare_time.dart';
import 'package:vegas_roster/Screen/onduty/item_list_staff.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

import '../../Model/user.dart';
import '../../Util/color.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class AllOnDuty extends StatefulWidget {
  final String? groupName, color;
  AllOnDuty({this.groupName, this.color});

  @override
  State<AllOnDuty> createState() => _AllOnDutyState();
}

class _AllOnDutyState extends State<AllOnDuty> {
  @override
  void initState() {
    super.initState();
  }

  final stringFormat = StringFormat();
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
                  return itemListStaff(
                    context: context,
                    height: height,
                    width: width,
                    index: index,
                    image: list[index].image,
                    list: list,
                    isActive: getTime(
                        today: DateTime.now(),
                        startTime: list[index].shift.first.date.toDate(),
                        endTime: list[index].shift.last.date.toDate()),
                    shift: list[index].shift.first.shiftName,
                    name: list[index].name,
                    startTime: list[index].shift.first.date.toDate(),
                    endTime: list[index].shift.last.date.toDate(),
                    color: widget.color!,
                  );
                },
              )
            : Center(child: textCustom(MyString.onduty_nostaff2, 12));
      },
    );
  }
}
