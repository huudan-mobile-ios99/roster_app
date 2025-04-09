import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/rosterDate.dart';
import 'package:vegas_roster/Screen/eventlog/item_eventlog.dart';
import 'package:vegas_roster/Screen/notification/item_notification.dart';
import 'package:vegas_roster/Screen/roster/roster_all_detail.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class RosterAll extends StatefulWidget {
  String? id;
  RosterAll({this.id, Key? key}) : super(key: key);

  @override
  State<RosterAll> createState() => _RosterAllState();
}

class _RosterAllState extends State<RosterAll> {
  final stringFormat = StringFormat();
  DateTime datePicker = DateTime.now();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
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
                      textCustomColor(MyString.label_allrosterhistory, 18, Colors.blue),
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
              textWithColorBox(textCustomColor('Choose 1 item to display roster', 12, MyColor.black_text)),
              const SizedBox(height: 15),
              Expanded(
                  flex: 1,
                  child: FutureBuilder(
                    future: getAllRosterDate_(),
                    builder: (context, snapshot) {
                      late final item = snapshot.data as List<RosterDate>;
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: myprogresscircular());
                      }
                      if (!snapshot.hasData) {
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
                          child: ListView.builder(
                            // reverse: true,
                            padding: const EdgeInsets.all(0),
                            itemCount: item.first.rosterDateItem.length,
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (_) => RosterAllDetail(
                                        id: widget.id,
                                        startDate: stringFormat.formatDate(item.first.rosterDateItem[index].start.toDate()),
                                        endDate: stringFormat.formatDate(item.first.rosterDateItem[index].end.toDate()),
                                      )));
                                },
                                child: SizedBox(
                                  width:width,
                                  child: Stack(
                                    children: [
                                      itemNotification(
                                        verticalPadding: 10.0,
                                        index: (index + 1).toString(),
                                        isEnable: false,
                                        isSeen: false,
                                        itemWidth: width,
                                        onPress: () {
                                          debugPrint('onpress something');
                                        },
                                        item: const Icon(Icons.arrow_forward_ios),
                                        text: '${stringFormat.formatDateWithSplashFULL(item.first.rosterDateItem[index].start.toDate())} - ${stringFormat.formatDateWithSplashFULL(item.first.rosterDateItem[index].end.toDate())}',
                                        textDate: "",
                                      ),
                                      Positioned(
                                        right:DefaultValue.padding_8,
																																								top: DefaultValue.padding_8,
                                        child: item.first.rosterDateItem[index].isActive==true ?  Icon(Icons.check,color:MyColor.bluefb):Container())
                                    ],
                                  ),
                                ),
                              );
                            },
                          ));
                    },
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
