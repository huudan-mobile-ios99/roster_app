import 'package:flutter/material.dart';
import 'package:vegas_roster/APIs/service_apis.dart';
import 'package:vegas_roster/Model/notificationM.dart';
import 'package:vegas_roster/Util/color.dart';
Widget iconNotification({
  id,
  name,
  notificationNum,
}) {
  return Stack(
    children: [
      Icon(
        Icons.notifications,
        size: 28,
        color: MyColor.grey,
      ),
      Positioned(
          top: 0,
          right: 0,
          child: SizedBox(
            child: notificationNum == 0 ? Container() :  Text(
                notificationNum >= 100 ? '99+' : notificationNum.toString(),
                style: const TextStyle(
                    color: Colors.blueAccent, fontWeight: FontWeight.bold),
              ),)),
    ],
  );
}
// Widget iconNotification({id, name,}) {
//   return Stack(
//     children: [
//       Icon(
//         Icons.notifications,
//         size: 28,
//         color: MyColor.grey,
//       ),
//       Positioned(
//           top: 0,
//           right: 0,
//           child: SizedBox(
//               child: FutureBuilder(
//             future: getListNotification(
//               id: id,
//               name: name,
//             ),
//             builder: (context, snapshot) {
//               late final List<NotificationItem> list =
//                   snapshot.data as List<NotificationItem>;
//               if (snapshot.hasError || snapshot.connectionState==ConnectionState.waiting) {
//                 return Container();
//               }
//               return  
//               list.isNotEmpty ? Text(
//                 list.length>=100 ? '99+' : list.length.toString(),
//                 style: const TextStyle(color: Colors.blueAccent, fontWeight: FontWeight.bold),
//               ):Container();
//             },
//           ))),
//     ],
//   );
// }
