import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/notification/item_notification.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RosterAllDetail extends StatefulWidget {
  String? id, startDate, endDate;
  RosterAllDetail({this.id, this.startDate, this.endDate, Key? key})
      : super(key: key);

  @override
  State<RosterAllDetail> createState() => _RosterAllDetailState();
}

class _RosterAllDetailState extends State<RosterAllDetail> {
  final stringFormat = StringFormat();
  DateTime datePicker = DateTime.now();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  @override
  void initState() {
    debugPrint('view all detail with init id: ${widget.id}');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final itemWidth = width / 16;
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal:kIsWeb ? DefaultValue.padding_64 :  DefaultValue.padding_16,vertical: DefaultValue.padding_16),
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      textCustomColor(kIsWeb ? '${MyString.label_allrosterhistorydetail} | ${widget.startDate}-${widget.endDate}'  : MyString.label_allrosterhistorydetail, 16, Colors.blue),
                    ],
                  ),
                  Positioned(
                      left: 8,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: textCustomColor('< BACK', 16, Colors.blue)))
                ],
              ),
              const SizedBox(height: 15),
              Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: getRosterDateFromByDate(
                        // id: "vJURMCfxILIQGJ0oxtRH",
                        id: widget.id,
                        date: widget.startDate),
                    builder: (context, snapshot) {
                      late final item = snapshot.data as List<Shift>;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: myprogresscircular());
                      }
                      if (!snapshot.hasData || snapshot.hasError) {
                        return Center(
                            child: textWithColorBox(
                                textCustom(MyString.rosterviewall_error, 12)));
                      }
                      return RefreshIndicator(
                          key: _refreshIndicatorKey,
                          onRefresh: () {
                            return Future(() {
                              setState(() {});
                            });
                          },

                          // child: textCustom('${widget.id} ${widget.startDate}', 14)
                          child: item.isNotEmpty
                              ? ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: item.length,
                                  itemBuilder: (context, index) {
                                    return GestureDetector(
                                      onTap: () {
                                        debugPrint('view detail');
                                      },
                                      child: itemNotification(
																																								isPassDay: item[index].date.toDate().difference(DateTime.now()).inDays >= 0? false: true,
                                        isToday: stringFormat.formatDate(item[index].date.toDate()) == stringFormat.formatDate(
                                          DateTime.now()
                                        ) ? true : false,
                                        verticalPadding: 10.0,
                                        index: (index + 1).toString(),
                                        isEnable: false,
                                        isSeen: false,
                                        itemWidth: width,
                                        onPress: () {
                                          debugPrint('onpress something');
                                        },
                                        item:
                                            const Icon(Icons.arrow_forward_ios),
                                        text:
                                            '${item[index].shiftName}   --   ${stringFormat.formatDateWithSplashFULL(item[index].date.toDate())}',
                                        textDate: "",
                                      ),
                                    );
                                  },
                                )
                              : Center(child: textWithColorBox(textCustom(MyString.viewall_roster_nodate, 14))));
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
