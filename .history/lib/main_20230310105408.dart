import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:vegas_roster/Screen/all_shift.dart';
import 'package:vegas_roster/Screen/authentication.dart';
import 'package:vegas_roster/Screen/colormap.dart';
import 'package:vegas_roster/Screen/create.dart';
import 'package:vegas_roster/Screen/editUser/edit.dart';
import 'package:vegas_roster/Screen/editUser/editUserContainer.dart';
import 'package:vegas_roster/Screen/eventlog/event_log.dart';
import 'package:vegas_roster/Screen/home.dart';
import 'package:vegas_roster/Screen/home_example.dart';
import 'package:vegas_roster/Screen/login.dart';
import 'package:vegas_roster/Screen/notification/notification.dart';
import 'package:vegas_roster/Screen/onduty/ondutyDetail.dart';
import 'package:vegas_roster/Screen/onduty/onduty.dart';
import 'package:vegas_roster/Screen/roster/roster.dart';
import 'package:vegas_roster/Screen/roster/roster_all.dart';
import 'package:vegas_roster/Screen/roster/roster_group.dart';
import 'package:vegas_roster/Screen/roster/roster_prev.dart';
import 'package:vegas_roster/Screen/setupdate.dart';
import 'package:vegas_roster/Screen/shift_time.dart';
import 'package:vegas_roster/Screen/update.dart';
import 'package:vegas_roster/Util/color.dart';
import 'package:vegas_roster/Util/default_value.dart';
import 'package:vegas_roster/Util/string.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import './firebase_options.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: kIsWeb
        ? const FirebaseOptions(
            apiKey: "AIzaSyCRN1CcozAzwBc_K19vjNbSq1yZgW6c5A0",
            projectId: "vegas-roster",
            messagingSenderId: "143133002260",
            appId: "1:143133002260:web:45efcf227ea125efba3501",
          )
        : null,
  );
  runApp(const MyApp());
}

class SystemUiOverlayStyle {}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        title: MyString.titleApp,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: MyColor.bluefb,
          fontFamily: MyString.main_fontFamily,
          textTheme: TextTheme(),
          primarySwatch: Colors.blue,
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                    horizontal: DefaultValue.padding_16,
                    vertical: DefaultValue.padding_8),
                textStyle:
                    const TextStyle(fontFamily: MyString.main_fontFamily),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(DefaultValue.padding_16))),
          ),
          snackBarTheme: const SnackBarThemeData(
              contentTextStyle:
                  TextStyle(fontFamily: MyString.main_fontFamily)),
          buttonTheme: const ButtonThemeData(),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
                textStyle:
                    const TextStyle(fontFamily: MyString.main_fontFamily)),
          ),
        ),
        // home:   const OnDuty(),
        home: const Authentication(),
        routes: <String, WidgetBuilder>{
          '/login': (BuildContext context) => const Login(),
          '/createUser': (BuildContext context) => const CreateUser(),
          '/updateUser': (BuildContext context) => const updateUser(),
          '/home_example': (BuildContext context) => MyHomePageExample(),
          '/home': (BuildContext context) => const HomePage(),
          '/onduty': (BuildContext context) => const OnDuty(),
          '/ondutyDetail': (BuildContext context) => OnDutyDetail(),
          '/edit': (BuildContext context) => Edit(),
          // '/editUser': (BuildContext context) => EditUserShift(),
          '/editUserContainer': (BuildContext context) => EditUserContainer(),
          '/roster': (BuildContext context) => Roster(),
          '/rosterPrev': (BuildContext context) => RosterPrev(),
          '/rosterGroup': (BuildContext context) => RosterGroup(),
          '/allShift': (BuildContext context) => const AllShift(),
          '/shiftTime': (BuildContext context) => const ShiftTime(),
          '/colorMap': (BuildContext context) => const ColorMap(),
          '/setupDate': (BuildContext context) => const SetUpDate(),
          '/eventLog': (BuildContext context) => const EventLog(),
          '/rosterAll': (BuildContext context) => RosterAll(),
          '/notification': (BuildContext context) => const NotificationPage(),
        });
  }
}
