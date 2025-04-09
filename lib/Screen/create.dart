import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
// import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:vegas_roster/Controller/getXcontroller.dart';
import 'package:vegas_roster/Model/listgroup.dart';
import 'package:vegas_roster/Screen/onduty/item_listduty.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/button.dart';
import 'package:vegas_roster/Widget/dialog.dart';
import 'package:vegas_roster/Widget/progresscircular.dart';
import 'package:vegas_roster/Widget/text.dart';

class CreateUser extends StatefulWidget {
  const CreateUser({Key? key}) : super(key: key);
  @override
  State<CreateUser> createState() => _CreateUserState();
}

// class _CreateUserState extends State<CreateUser> with WidgetsBindingObserver{
class _CreateUserState extends State<CreateUser> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool checkBox = false;
  bool isObsecure = true;
  bool isObsecureConfirmPW = true;
  bool isDisplayLoading = false;
  bool isButtonReady = false;
  TextEditingController usernameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordControllerConfirmPW = TextEditingController();
  TextEditingController usernameVietNameController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  List<String> list_gender = ['Male', 'Female'];
  List<String> list_role = ['User', 'Manager'];
  String? valueGender, valueRole, valueGroup, valueDatePicker, valueColor;
  DateTime? valueDatePickerDateTime;

  @override
  void initState() {
    super.initState();
    // WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void dispose() {
    super.dispose();
    // WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
        key: _scaffoldKey,
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          icon: Icon(Icons.arrow_back_ios)),
                      textCustom(MyString.createUser, 24),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  textfieldUsername(),
                  const SizedBox(
                    height: 25,
                  ),
                  textfieldUsernameVN(),
                  const SizedBox(
                    height: 25,
                  ),
                  textfieldNumber(),
                  const SizedBox(
                    height: 25,
                  ),
                  textfieldPassword(),
                  const SizedBox(
                    height: 25,
                  ),
                  textfieldPasswordConfirm(),
                  const SizedBox(height: 25),
                  rowInfo(
                      valueGender: valueGender,
                      valueRole: valueRole,
                      valueGroup: valueGroup,
                      valueDatePicker: valueDatePicker,
                      context: context,
                      onPressGender: () {
                        debugPrint('click gender');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialogAlertBody(
                                context: context,
                                width: width,
                                widget: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: list_gender.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          valueGender = list_gender[index];
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      title: Text(
                                          '${index + 1}.  ${list_gender[index]}'),
                                    ));
                                  },
                                ),
                                height: height / 2,
                                title: MyString.chooseGender);
                          },
                        );
                      },
                      onPressGroup: () {
                        debugPrint('click group');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialogAlertBody(
                                context: context,
                                width: width,
                                height: height / 2,
                                widget: FutureBuilder(
                                  future: getListGroup(),
                                  builder: (context, snapshot) {
                                    late final listGR =
                                        snapshot.data as List<ListGroup>;
                                    if (!snapshot.hasData) {
                                      return Center(
                                          child: myprogresscircular());
                                    } else if (snapshot.connectionState ==
                                        ConnectionState.waiting) {
                                      return Center(
                                          child: myprogresscircular());
                                    }
                                    if (snapshot.hasError) {
                                      return Center(
                                          child: textCustom(
                                              MyString.onduty_error, 12));
                                    }
                                    return ListView.builder(
                                      itemCount: listGR.first.listGroup.length,
                                      itemBuilder: (context, index) {
                                        return itemListDuty(
                                          onPress: () {
                                            debugPrint('click group detail');
                                            setState(() {
                                              valueGroup = listGR
                                                  .first.listGroup[index].name;

                                              valueColor = listGR
                                                  .first.listGroup[index].color;
                                            });
                                            Navigator.of(context).pop();
                                          },
                                          context: context,
                                          id: (index + 1).toString(),
                                          color: (listGR.first.listGroup[index]
                                                          .color !=
                                                      null ||
                                                  listGR.first.listGroup[index]
                                                          .color !=
                                                      '')
                                              ? Color(int.parse(listGR.first
                                                  .listGroup[index].color))
                                              : MyColor.grey_tab,
                                          hasChild: false,
                                          itemWidth: width,
                                          text: listGR
                                              .first.listGroup[index].name,
                                        );
                                      },
                                    );
                                  },
                                ),
                                title: MyString.chooseGroup);
                          },
                        );
                      },
                      onPressRole: () {
                        debugPrint('click role');
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return dialogAlertBody(
                                context: context,
                                width: width,
                                height: height / 2,
                                widget: ListView.builder(
                                  padding: const EdgeInsets.all(0),
                                  itemCount: list_role.length,
                                  itemBuilder: (context, index) {
                                    return Card(
                                        child: ListTile(
                                      onTap: () {
                                        setState(() {
                                          valueRole = list_role[index];
                                        });
                                        Navigator.of(context).pop();
                                      },
                                      title: Text(
                                          '${index + 1}.  ${list_role[index]}'),
                                    ));
                                  },
                                ),
                                title: MyString.chooseRole);
                          },
                        );
                      },
                      onPressDatePicker: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime(2000, 01, 01),
                                firstDate: DateTime(1980),
                                lastDate: DateTime(2030))
                            .then((value) {
                          final stringFormat = StringFormat();
                          setState(() {
                            valueDatePicker = stringFormat.formatDate(value);
                            valueDatePickerDateTime = value;
                          });
                          debugPrint(valueDatePicker);
                        });
                      }),
                  const SizedBox(
                    height: 40,
                  ),
                  myButton(
                      onPress: () {
                        if (validateData() == true) {
                          setState(() {
                            isDisplayLoading = true;
                          });
                          debugPrint(
                              '${usernameController.text} ${numberController.text} ${passwordController.text} ${passwordControllerConfirmPW.text} $valueGender $valueGender $valueGroup $valueRole $valueDatePicker');
                          createNewUser(
                            context: context,
                            color: valueColor,
                            name: usernameController.text,
                            vietnameseName: usernameVietNameController.text,
                            collectionName: 'user',
                            birthday: valueDatePickerDateTime,
                            gender: valueGender,
                            group: valueGroup,
                            number: numberController.text,
                            password: passwordController.text,
                            role: valueRole,
                          );
                          addFirstShiftData();
                          turnOffKeyBoard(context);
                        } else {
                          debugPrint('do nothing');
                        }
                      },
                      text: MyString.createUserButton,
                      width: width,
                      isReady: validateData()),

                  const SizedBox(height: 25),

                  // isDisplayLoading == true
                  //     ? Center(child: myprogresscircular())
                  //     : Container(height: 0, width: 0),
                ],
              ),
            ),
          ),
        ));
  }

  addFirstShiftData() {
    final collection = FirebaseFirestore.instance.collection('user');
    collection.doc('kfNjDMzpry01isTurLNt').update({
      'shift': FieldValue.arrayUnion([
        {
          "shiftName": '',
          "date": Timestamp.fromDate(DateTime(2022, 01, 01)),
        },
      ])
    });
  }

  bool validateData() {
    if (usernameController.text.isNotEmpty &&
        usernameVietNameController.text.isNotEmpty &&
        numberController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        passwordControllerConfirmPW.text.isNotEmpty &&
        valueGender != null &&
        valueRole != null &&
        valueGroup != null &&
        valueDatePicker != null) {
      return true;
    } else {
      return false;
    }
  }

  Widget rowInfo(
      {onPressGender,
      onPressRole,
      onPressGroup,
      onPressDatePicker,
      context,
      valueGender,
      valueRole,
      valueGroup,
      valueDatePicker}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [
            IconButton(
              onPressed: () async {
                await onPressGender();
                turnOffKeyBoard(context);
              },
              icon: const Icon(Icons.man),
              color: MyColor.grey,
              tooltip: 'Choose gender',
              iconSize: 30,
            ),
            valueGender != null
                ? textCustom(valueGender ?? '', 12)
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            IconButton(
              onPressed: () {
                onPressRole();
                turnOffKeyBoard(context);
              },
              icon: const Icon(Icons.apps_sharp),
              color: MyColor.grey,
              tooltip: 'Choose role',
              iconSize: 30,
            ),
            valueRole != null
                ? textCustom(valueRole ?? '', 12)
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            IconButton(
              onPressed: () {
                onPressGroup();
                turnOffKeyBoard(context);
              },
              icon: const Icon(Icons.group),
              color: MyColor.grey,
              tooltip: 'Choose group',
              iconSize: 30,
            ),
            valueGroup != null
                ? textCustom(valueGroup ?? '', 12)
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
        const SizedBox(width: 10),
        Column(
          children: [
            IconButton(
              onPressed: () async {
                await onPressDatePicker();
                turnOffKeyBoard(context);
              },
              icon: const Icon(Icons.cake),
              color: MyColor.grey,
              tooltip: MyString.chooseBirthday,
              iconSize: 30,
            ),
            valueDatePicker != null
                ? textCustom(valueDatePicker ?? '', 12)
                : Container(
                    width: 0,
                    height: 0,
                  )
          ],
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  Widget textfieldUsername() {
    return TextFormField(
      controller: usernameController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
          isDense: true,
          border: const OutlineInputBorder(),
          hintText: MyString.userNamePlaceholder,
          suffixIcon: circleCloseButton(() {
            setState(() {
              usernameController.clear();
            });
          }, usernameController)),
    );
  }

  Widget textfieldUsernameVN() {
    return TextFormField(
      controller: usernameVietNameController,
      onChanged: (value) {
        setState(() {});
      },
      decoration: InputDecoration(
          isDense: true,
          border: const OutlineInputBorder(),
          hintText: MyString.userNamePlaceholderVN,
          suffixIcon: circleCloseButton(() {
            setState(() {
              usernameController.clear();
            });
          }, usernameController)),
    );
  }

  Widget textfieldNumber() {
    return TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (value) {
        setState(() {});
      },
      controller: numberController,
      decoration: InputDecoration(
          isDense: true,
          border: const OutlineInputBorder(),
          hintText: MyString.numberPlaceholder,
          suffixIcon: circleCloseButton(() {
            setState(() {
              numberController.clear();
            });
          }, numberController)),
    );
  }

  Widget textfieldPassword() {
    return TextFormField(
      onChanged: (value) => setState(() {}),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        hintText: MyString.passwordPlaceholder,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
          mainAxisSize: MainAxisSize.min, // added line
          children: <Widget>[
            circleCloseButton(() {
              setState(() {
                passwordController.clear();
              });
            }, passwordController),
            eyeButton(() {
              setState(() {
                isObsecure = !isObsecure;
              });
            }, isObsecure),
          ],
        ),
      ),
      obscureText: isObsecure,
      controller: passwordController,
    );
  }

  Widget textfieldPasswordConfirm() {
    return TextFormField(
      onChanged: (value) => setState(() {}),
      keyboardType: const TextInputType.numberWithOptions(
        decimal: false,
        signed: false,
      ),
      decoration: InputDecoration(
        isDense: true,
        border: const OutlineInputBorder(),
        hintText: MyString.passwordConfirmPlaceholder,
        suffixIcon: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
          mainAxisSize: MainAxisSize.min, // added line
          children: <Widget>[
            circleCloseButton(() {
              setState(() {
                passwordControllerConfirmPW.clear();
              });
            }, passwordControllerConfirmPW),
            eyeButton(() {
              setState(() {
                isObsecureConfirmPW = !isObsecureConfirmPW;
              });
            }, isObsecureConfirmPW),
          ],
        ),
      ),
      obscureText: isObsecureConfirmPW,
      controller: passwordControllerConfirmPW,
    );
  }
}
