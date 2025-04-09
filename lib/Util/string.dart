import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class MyString {
  static const String main_fontFamily =  "Quicksand" ;
  // static const String main_fontFamily = kIsWeb ? "Quicksand" : 'Nunito';
  static const String titleApp = 'VEGAS ROSTER';
  static const String userNamePlaceholderVN = 'Enter Username Vietnamese';
  static const String userNamePlaceholder = 'Enter Username ';
  static const String numberPlaceholder = 'Enter Number';
  static const String passwordPlaceholder = 'Enter Password';
  static const String passwordConfirmPlaceholder = 'Enter Password Confirm';
  static const String loginButton = 'LOGIN';
  static const String checkBox = 'Remember me';
  static const String createUser = 'CREATE NEW USER';
  static const String updateUser = 'UPDATE USER';
  static const String createUserButton = 'CREATE';
  static const String updaetUserButton = 'UPDATE';
  static const String requestButton = 'REQUEST';
  static const String responseButton = 'RESPONSE';
  static const String responseButton_decline = 'RESPONSE_DECLINE';
  static const String cancelButton = 'CANCEL';
  static const String viewAllBtn = 'VIEW ALL';
  static const String pickAItem = 'Pick a item';
  static const String chooseGroup = 'Choose group';
  static const String chooseGender = 'Choose gender';
  static const String chooseRole = 'Choose role';
  static const String chooseBirthday = 'Choose birthday';

  static const String user_role_manager = 'Manager';
  static const String user_role_user = 'User';

  static const String chooseWorkShift = 'Choose Work Shift';
  static const String detailinfor_shift = 'Shift infor detail';
  static const String onduty_nostaff = 'No staff for this day';
  static const String onduty_nostaff2 = 'No staff found for today';
  static const String onduty_error = 'An error orcur';
  static const String roster_error = 'An error orcur';
  static const String no_data = 'No data found';
  static const String roster_nostaff =
      'No staff and roster date for this group';
  static const String roster_current = 'Current Roster';
  static const String roster_no_itemshift = 'Shift item must be different with the current';
  static const String roster_prev = 'Previous Roster';
  static const String title_closeTheApp = 'Close App?';
  static const String roster_pickdate_title = 'Choose work shift for this date';
  static const String roster_setupworkshift = 'set up work shift';
  static const String roster_setupworkshift_successful = 'set up work shift successful';

  static const String event_log_error = 'Error when loading logs';
  static const String noti_error = 'Error when loading notifications';
  static const String event_log_noitem = 'No event log found';
  static const String noti_noitem = 'No notifications  found';

  static const String rosterviewall_log_error = 'Error when loading all roster';
  static const String rosterviewall_error = 'Error when loading all roster';
  static const String rosterviewall_noitem = 'No rosters found';

  static const String rosterview_button_tooltip = 'Choose a group'; 

  static const String notification = 'Notification';
  static const String edit_dialog = 'Pick a day and send request';
  static const String edit_dialog_withdata = 'Request work shift to: ';

  static const String notification_create_successfull =
      'Your request is sent successfully';
  static const String notification_create_unsuccessfull =
      'Your request can not send';

  static const String action_new = 'new';
  static const String action_seen = 'seen';
  static const String action_approve = 'approve';
  static const String request_approve = 'Your request was approved';
  static const String request_decline = 'Your request was declined';
  static const String request_sent_success = 'request was sent successully';
  static const String request_sent_success_Decline =
      'you declined the request successfully';
  static const String request_sent_unsuccess = 'request can be sent';

  static const String viewall_roster_nodate = 'No item found for this roster';
  static const String label_group_pickg = 'Pick a group to view roster';
  static const String label_notificationrequest = 'NOTIFICATION REQUEST';
  static const String label_rosteronduty = 'ROSTER ON DUTY';
  static const String label_menu_drawer = 'MENU';
  static const String label_allrosterhistory = 'VIEW ALL ROSTER HISTORY';
  static const String label_allrosterhistorydetail = 'ROSTER HISTORY DETAIL';
  static const String label_request_roster = 'REQUEST ROSTER';
  static const String label_back = '< BACK';
  static const String label_no_data = 'An error found or No data';
  static const String label_wrongpassword = 'Wrong password or username';
  static const String request_error_input ='Can not request because can find old work shift';


		final GlobalKey<ScaffoldState> _scaffoldKeyGlobal = GlobalKey<ScaffoldState>();
}
