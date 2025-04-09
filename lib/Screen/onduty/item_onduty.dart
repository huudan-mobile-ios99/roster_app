import 'package:flutter/material.dart';
import 'package:vegas_roster/Screen/onduty/function_onduty.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

import '../../Util/string.dart';

Widget buildListViewBodyFilter(width, height, keyword, userListFilter) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
        color: MyColor.grey_tab.withOpacity(0.25),
        borderRadius: BorderRadius.circular(5)),
    child: ListView.builder(
      itemCount: userListFilter?.length,
      itemBuilder: (context, index) {
        return Card(
            child: ListTile(
                trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.more_vert_sharp,
                      color: MyColor.black_text,
                    )),
                subtitle: Row(
                  children: [
                    textCustom('${userListFilter?[index].vietnameseName}', 12),
                    const SizedBox(width: 10),
                    textCustom('${userListFilter?[index].role}', 12),
                    const SizedBox(width: 10),
                    textCustom('${userListFilter?[index].group}', 12),
                  ],
                ),
                dense: true,
                title: Row(
                  children: [
                    Text(
                      '${userListFilter?[index].number}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(width: 10),
                    Text('${userListFilter?[index].name}'),
                  ],
                )));
      },
    ),
  );
}

Widget buildListViewBody(width, height, userList) {
  return FutureBuilder(
    future: getSearchResultData_().then((value) {
      userList = value;
    }),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(
          child: textCustom(MyString.onduty_error, 12),
        );
      }
      if (snapshot.connectionState == ConnectionState.waiting) {
        return Center(
          child: myprogresscircular(),
        );
      }

      return ListView.builder(
        itemCount: userList?.length,
        itemBuilder: (context, index) {
          final myShift = userList?[index].shift;
          return Container(
            margin: const EdgeInsets.only(bottom: 5),
            padding: const EdgeInsets.all(5),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2.5),
                border: Border.all(color: MyColor.grey, width: 0.5)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Container(
                      width: 15,
                      height: 15,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: userList?[index].role.toLowerCase() ==
                                'it technical'
                            ? MyColor.blue
                            : MyColor.grey_tab,
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Container(
                      padding: EdgeInsets.all(2.5),
                      decoration: BoxDecoration(
                        color: MyColor.grey_tab,
                      ),
                      child: textCustom('${userList?[index].number}', 10),
                    ),
                    const SizedBox(width: 5),
                    textCustom('${userList?[index].name}', 14),
                    const SizedBox(width: 5),
                    textCustomColor('(${userList?[index].vietnameseName})', 12,
                        MyColor.grey),
                  ],
                ),
                textCustom('${userList?[index].shift[index].shiftName}', 16)
              ],
            ),
          );
        },
      );
    },
  );
}

Widget tabView(
    {myTabs, tabController, context, color, bool hasColorFromParen = false,width}) {
  return Container(
				width: width,
    color: MyColor.grey_tab,
    child: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            width: width,
            child: TabBar(
              isScrollable: true,
              labelPadding: const EdgeInsets.symmetric(horizontal: 25),
              controller: tabController,
              unselectedLabelColor: MyColor.black_text.withOpacity(0.75),
              labelColor: MyColor.white,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                  color: hasColorFromParen == false
                      ? MyColor.bluefb
                      : Color(int.parse(color))),
              tabs: [
                const Tab(
                  text: MyString.roster_current,
                  height: 30,
                ),
              const Tab(
                text: MyString.roster_prev,
                height: 30,
              ),
              ]
              // tabs: tabNames
            ),
          ),
        )),
  );
}

Widget tabViewEqual(
    {myTabs,
    tabController,
    context,
    color,
    bool hasColorFromParen = false,
    width}) {
  return PreferredSize(
      preferredSize: const Size.fromHeight(50),
      child: Align(
        alignment: Alignment.center,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: TabBar(
            isScrollable: true,
            controller: tabController,
            unselectedLabelColor: MyColor.black_text.withOpacity(0.75),
            labelColor: MyColor.white,
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: BoxDecoration(
                color: hasColorFromParen == false
                    ? MyColor.blue
                    : Color(int.parse(color))),
            tabs: [
              Container(width: width/4 , child: const Tab(text: 'All', height: 25)),
              Container(
                width: width/4 ,
                child: const Tab(
                  text: 'Active',
                  height: 30,
                ),
              ),
              Container(
                width: width/4 ,
                child: const Tab(
                  text: 'UnActive',
                  height: 30,
                ),
              ),
            ],
          ),
        ),
      ));
}

Widget tabBarView(_tabController) {
  return Container(
    height: 400,
    width: 400,
    child: TabBarView(
      controller: _tabController,
      children: [
        // listItems(),
        Center(child: Text("Favorite list will be shown here")),
        Center(child: Text("Filter")),
      ],
    ),
  );
}
