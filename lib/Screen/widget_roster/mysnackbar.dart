import 'package:flutter/material.dart';
import 'package:vegas_roster/Util/color.dart';

mysnackBar(message){
	return SnackBar(
		content:  Text(message,style: TextStyle(color:MyColor.white),),
		action: SnackBarAction(label: 'CLOSE',onPressed: () {},),
		duration:const Duration(seconds: 2),
		);
}