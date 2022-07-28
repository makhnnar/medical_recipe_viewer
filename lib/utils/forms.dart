

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

bool validateValue(String value,String expression){
  String pattern = r"(^"+expression+"\$)";
  RegExp regExp = new RegExp(pattern);
  print("validateValue value:$value matches? ${regExp.hasMatch(value)}");
  return regExp.hasMatch(value);
}

void showToast(String msg){
  Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: Colors.grey,
      textColor: Colors.white,
      fontSize: 16.0
  );
}