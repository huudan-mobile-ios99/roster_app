import 'package:flutter/material.dart';
import 'package:vegas_roster/Screen/editUser/editUserTabNew.dart';
import 'package:vegas_roster/Screen/editUser/editUserTabPrev.dart';
import 'package:vegas_roster/Screen/home.dart';
import 'package:vegas_roster/Screen/onduty/item_onduty.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class EditUserContainer extends StatefulWidget {
  String? name, number, vietnameseName, group, id;
  int? initIndex = 0;
  EditUserContainer(
      {this.name, this.number, this.vietnameseName, this.group, this.id,this.initIndex});
  @override
  State<EditUserContainer> createState() => _EditUserContainerState();
}

class _EditUserContainerState extends State<EditUserContainer>
    with TickerProviderStateMixin {
  late TabController _tabController;
  //   final List<Tab> myTabs = <Tab>[
  //   const Tab(text: MyString.roster_current, height: 25),
  //   const Tab(text: MyString.roster_prev,height:25),
  // ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: 2, initialIndex: widget.initIndex!);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        maintainBottomViewPadding: true,
        left: true,
        bottom: false,
        right: true,
        top: true,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal:kIsWeb ? DefaultValue.padding_64 : DefaultValue.padding_16,),
          child: Column(
            children: [
														const SizedBox(height: DefaultValue.padding_16,),
              SizedBox(
                width: width,
                child: Row(
																	crossAxisAlignment:CrossAxisAlignment.center,
																	mainAxisAlignment: MainAxisAlignment.start,
                  children: [
																			GestureDetector(
																				onTap: (){
																					Navigator.of(context).push(MaterialPageRoute(builder: (context) => const HomePage()));
																				},
																				child: textCustomColor('< BACK', 16, Colors.blueAccent)) ,
																				const SizedBox(width: DefaultValue.padding_16,),
                    Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        Container(
                            padding: const EdgeInsets.all(2.5),
                            color: MyColor.grey_tab,
                            child: textCustom('${widget.number}', 12)),
                        const SizedBox(width: 5),
                        textCustom('${widget.name}', 14),
                        const SizedBox(width: 5),
                        textCustomColor('(${widget.vietnameseName})', 12, MyColor.grey),
                        const SizedBox(width: 5),
                        textCustomColor('(${widget.group})', 12, MyColor.grey),
                      ],
                    ),
                  ],
                ),
              ),
														const SizedBox(height: DefaultValue.padding_16,),
              
              tabView(
                  width: width,
                  tabController: _tabController,
                  context: context,
                  hasColorFromParen: false),
              const SizedBox(height: 10),
              Expanded(
                flex: 1,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    EditUserTabCurrent(
                      id: widget.id,
                      name: widget.name,
                      vietnameseName: widget.vietnameseName,
                    ),
                    EditUserTabPrev(
                      id: widget.id,
                      name: widget.name,
                      vietnameseName: widget.vietnameseName,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
