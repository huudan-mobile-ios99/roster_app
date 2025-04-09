import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/eventlog.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EventLog extends StatefulWidget {
  const EventLog({Key? key}) : super(key: key);

  @override
  State<EventLog> createState() => _EventLogState();
}

class _EventLogState extends State<EventLog> {
  final stringFormat = StringFormat();
  DateTime datePicker = DateTime.now();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? name, id, number, group, role;
  @override
  void initState() {
    super.initState();
    getUserDataSave().then((value) {
      final UserSave user = value;
      getManagerOfGroupModel(groupName: user.group, role: MyString.user_role_manager)
          .then((value) {
        setState(() {
          name = value.name;
          number = value.number;
        });
      });
      // setState(() {
      //   name = user.name;
      //   id = user.id;
      //   number = user.number;
      //   group = user.group;
      //   role = user.role;
      // });
    });
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () async {
                await showDatePicker(
                  context: context,
                  initialDate: datePicker,
                  firstDate: DateTime(2022),
                  lastDate: DateTime(2030),
                ).then((selectedDate) {
                  if (selectedDate != null) {
                    setState(() {
                      datePicker = selectedDate;
                    });
                  }
                });
              },
              icon: const Icon(Icons.calendar_month))
        ],
        centerTitle: true,
        leading: const BackButton(color: Colors.white),
        title: textCustomColor('Event logs', 16, MyColor.white),
      ),
      body: SafeArea(
          child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_8, vertical: DefaultValue.padding_8),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            textWithColorBox(textCustomColor('Pick a day to display event log ↑', 12, MyColor.grey)),
            const SizedBox(height: 5),
            textCustom(stringFormat.formatDate(datePicker), 16),
            const SizedBox(width: 25),
            const SizedBox(height: 5),
            Expanded(
                child: FutureBuilder(
              future: getListEventLogbyDate(
                name,
                number,
                stringFormat.formatDate(datePicker),
                // group,
                // MyString.user_role_manager
              ),
              builder: (context, snapshot) {
                late final list = snapshot.data as List<EventItem>;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: myprogresscircular());
                }
                if (!snapshot.hasData) {
                  return Center(child: textWithColorBox(
                          textCustom(MyString.event_log_error, 12)));
                }
                return list.isNotEmpty
                    ? RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: () {
                          return Future(() {
                            setState(() {});
                          });
                        },
                        child: ListView.builder(
                          itemCount: list.length,
                          itemBuilder: (context, index) => itemEventLog(
                              width: width,
                              body: list[index].body,
                              index: index + 1,
                              time: list[index].time),
                        ),
                      )
                    : Center(
                        child: textWithColorBox(
                            textCustom(MyString.event_log_noitem, 12)),
                      );
              },
            ))
          ],
        ),
      )),
    );
  }
}
