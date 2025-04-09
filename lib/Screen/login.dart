import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vegas_roster/Model/user.dart';
import 'package:vegas_roster/Model/usersave.dart';
import 'package:vegas_roster/Screen/widget_roster/mysnackbar.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/function.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:vegas_roster/Util/string_date_format.dart';
import 'package:vegas_roster/Widget/button.dart';
import 'package:vegas_roster/Widget/text.dart';
import 'package:vegas_roster/Widget/toast.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:ui';


class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final today = DateTime.now();
  final stringFormat = StringFormat();
  bool checkBox = false;
  late User userChild;
  bool isObsecure = true;
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final collection = FirebaseFirestore.instance.collection('user');

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;

				final double widthWeb = width/2;
				final double heightWeb = width/2;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Container(
												width: width,
												alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 35),
            child: Form(
              key: formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(MyString.titleApp, style: TextStyle(fontSize: 28)),
                  const SizedBox(
                    height: 40,
                  ),
                  SizedBox(
																				width:kIsWeb?widthWeb:width,
                    child: TextFormField(
                      onChanged: (value) => setState(() {}),
                      controller: usernameController,
                      decoration: InputDecoration(
                          isDense: true,
                          border: const OutlineInputBorder(),
                          hintText: MyString.userNamePlaceholder,
                          suffixIcon: circleCloseButton(() {
                            setState(() {
                              usernameController.clear();
                            });
                          }, usernameController)),
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
																				width:kIsWeb?widthWeb:width,
                    child: TextFormField(
                      onChanged: (value) => setState(() {}),
                      textInputAction: TextInputAction.next,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: false,
                        signed: false,
                      ),
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      decoration: InputDecoration(
                        isDense: true,
                        border: const OutlineInputBorder(),
                        hintText: MyString.passwordPlaceholder,
                        suffixIcon: Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween, // added line
                          mainAxisSize: MainAxisSize.min, // added line
                          children: <Widget>[
                            eyeButton(() {
                              setState(() {
                                isObsecure = !isObsecure;
                              });
                            }, isObsecure),
                            circleCloseButton(() {
                              setState(() {
                               passwordController.clear();
                              });
                            }, passwordController)
                          ],
                        ),
                      ),
                      obscureText: isObsecure,
                      controller: passwordController,
                    ),
                  ),
                  const SizedBox(
                    height: 25,
                  ),
                  SizedBox(
																				width: kIsWeb?widthWeb:width,
                    child: CheckboxListTile(
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      title: const Text(MyString.checkBox),
                      value: checkBox,
                      onChanged: (newValue) {
                        setState(() {
                          checkBox = newValue ?? false;
                        });
                      },
                      tileColor: Colors.grey.withOpacity(0.1),
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
																		myButton(
																		onPress: () {
                        debugPrint('${usernameController.text} ${passwordController.text} checkbox: $checkBox');
                        if (validateData() == true) {
                          login(
                              name: usernameController.text,
                              password: passwordController.text);
                          if (checkBox == true) {
                            saveCheckBoxForAuthentication(checkBox);
                          } else {
                            clearCheckBoxForAuthentication();
                          }
                        }
                        turnOffKeyBoard(context);
                      },
                      text: MyString.loginButton,
                      isReady: validateData()
																		),
                  // myBlueButton(
                  //     onPress: () {
                  //       debugPrint('${usernameController.text} ${passwordController.text} checkbox: $checkBox');
                  //       if (validateData() == true) {
                  //         login(
                  //             name: usernameController.text,
                  //             password: passwordController.text);
                  //         if (checkBox == true) {
                  //           saveCheckBoxForAuthentication(checkBox);
                  //         } else {
                  //           clearCheckBoxForAuthentication();
                  //         }
                  //       }
                  //       turnOffKeyBoard(context);
                  //     },
                  //     text: MyString.loginButton,
                  //     isReady: true),
                ],
              ),
            ),
          ),
        ));
  }

  bool validateData() {
    if (usernameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty) {
      return true;
    } else {
      return false;
    }
  }

  login({name, password}) async {
    final snap = await FirebaseFirestore.instance
        .collection('user')
        .where('name', isEqualTo: name)
        .where('password', isEqualTo: password)
        .get();
    final List<QueryDocumentSnapshot<Map<String, dynamic>>> user = snap.docs;
    debugPrint('result login user: ${user.length}');

    user.forEach((element) {
      debugPrint('${element.id} ${element.data()}');
      userChild = User.fromJson(element.data());
      debugPrint('${userChild.number} ${userChild.name} ${userChild.vietnameseName} ${userChild.group} ${userChild.role}  ${stringFormat.formatDate(userChild.birthday.toDate())} ');
      // saveDataUser(element.data());
    });

    if (user.isNotEmpty) {
      debugPrint('login can');
      debugPrint('id: ${userChild.id}');
      saveDataUser(userChild);

      Navigator.of(context).pushNamed(
        '/home',
      );
    } else {
      debugPrint('login can not');
      kIsWeb? ScaffoldMessenger.of(context).showSnackBar(mysnackBar(MyString.label_wrongpassword)) :  showToastError(MyString.label_wrongpassword);
    }
  }

  saveDataUser(newUserSave) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    UserSave newUserSave = UserSave(
      id: userChild.id,
      name: userChild.name,
      vietnameseName: userChild.vietnameseName,
      group: userChild.group,
      number: userChild.number,
      role: userChild.role,
    );
    final String jsonString = jsonEncode(newUserSave.toJson());
    debugPrint('jsonString $jsonString');
    pref.setString('userData', jsonString);
  }

  
}
