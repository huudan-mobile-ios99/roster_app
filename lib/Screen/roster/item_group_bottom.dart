import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Screen/roster/item_group.dart';
import 'package:vegas_roster/Screen/roster/roster_group.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ItemGroupBottom extends StatefulWidget {
  List<DateTime> listDate;
  bool isRosterPrev = false;
  ItemGroupBottom(
      {Key? key, required this.listDate, required this.isRosterPrev})
      : super(key: key);

  @override
  State<ItemGroupBottom> createState() => _ItemGroupBottomState();
}

class _ItemGroupBottomState extends State<ItemGroupBottom> {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height * 3 / 4;
    final itemWidth = width / 16;
    return Container(
      width: width,
						color: MyColor.blue_bg,
      padding: const EdgeInsets.symmetric(vertical: DefaultValue.padding_16, horizontal: kIsWeb ? DefaultValue.padding_64: DefaultValue.padding_16),
      height: height,
      child: Column(
        children: [
          Row(
												mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              textCustom(MyString.label_group_pickg, 16),
              IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.close,color:MyColor.black_text))
            ],
          ),
          Expanded(
            child: FutureBuilder(
              future: getListGroup(),
              builder: (context, snapshot) {
                late final list = snapshot.data as List<ListGroup>;
                if (snapshot.connectionState == ConnectionState.waiting ||
                    !snapshot.hasData) {
                  return Center(child: myprogresscircular());
                }
                if (snapshot.hasError) {
                  return Center(child: textCustom(MyString.roster_error, 12));
                }
                return ListView.builder(
                  scrollDirection: Axis.vertical,
                  reverse: true,
                  padding: const EdgeInsets.all(0),
                  itemCount: list.first.listGroup.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      focusColor: MyColor.bluefb,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => RosterGroup(
                                  isRosterPrev: widget.isRosterPrev,
                                  group: list.first.listGroup[index].name,
                                  listDate: widget.listDate,
                                )));
                      },
                      child: itemGroupBottomDialog(
                          isRostserPrev: widget.isRosterPrev,
                          isActive: false,
                          itemWidth: itemWidth * 3,
                          text: list.first.listGroup[index].name),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
