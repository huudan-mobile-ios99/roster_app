// import 'package:flutter/material.dart';
// import 'package:vegas_roster/Widget/text.dart';

// class contentUpdate extends StatefulWidget {
// 		const contentUpdate({ Key? key }) : super(key: key);

// 		@override
// 		State<contentUpdate> createState() => _contentUpdateState();
// }

// class _contentUpdateState extends State<contentUpdate> {
// 		@override
// 		Widget build(BuildContext context) {
// 				Container(
//     width: width,
//     height: height / 3,
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.start,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(5),
//               border: Border.all(
//                 color: MyColor.grey_tab,
//               )),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.start,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               textCustom(
//                 color: listModel![index].isLargeValue == '0'
//                     ? MyColor.green
//                     : listModel[index].isLargeValue == '1'
//                         ? MyColor.blue
//                         : listModel[index].isLargeValue == '2'
//                             ? MyColor.red
//                             : MyColor.black_text,
//                 fontSize: 14,
//                 isBold: false,
//                 text: listModel[index].value.toString(),
//               ),
//               const SizedBox(width: 10),
//               textCustom(
//                 color: MyColor.grey,
//                 fontSize: 14,
//                 isBold: false,
//                 text: listModel[index].note.toString() == ''
//                     ? 'no note available'
//                     : listModel[index].note.toString(),
//               ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 15,
//         ),
//         Row(
//           children: [
//             Icon(Icons.add_box_rounded, color: MyColor.grey, size: 20),
//             const SizedBox(width: 5),
//             textCustom(
//                 color: MyColor.black_text,
//                 fontSize: 16,
//                 isBold: false,
//                 text: MyString.label_saving_update_titlesub)
//           ],
//         ),
//         SizedBox(
//           height: 15,
//         ),
//         Container(
//             padding: const EdgeInsets.all(10),
//             decoration: BoxDecoration(
//                 color: MyColor.grey_tab,
//                 borderRadius: BorderRadius.circular(5)),
//             width: width,
//             child: GetBuilder<MyGetXController>(
//               builder: (controller) {
//                 return TextField(
//                   maxLength: 7,
//                   keyboardType: TextInputType.text,
//                   decoration: InputDecoration.collapsed(
//                       hintText: MyString.label_saving_update_hint_moneyvalue,
//                       hintStyle: const TextStyle(
//                         fontSize: 16,
//                       )),
//                   controller: controllerMoneyValue,
																		
//                 );
//               },
//             )),
//         const SizedBox(height: 10),
//         Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//               color: MyColor.grey_tab, borderRadius: BorderRadius.circular(5)),
//           width: width,
//           child: TextField(
//             keyboardType: TextInputType.text,
//             decoration: InputDecoration.collapsed(
//                 hintText: MyString.label_saving_update_hint_note,
//                 hintStyle: const TextStyle(
//                   fontSize: 16,
//                 )),
//             controller: controllerNote,
//           ),
//         ),
//       ],
//     ),
//   );
// 		}
// }