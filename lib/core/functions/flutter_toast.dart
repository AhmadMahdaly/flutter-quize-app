import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:smle/core/functions/responsive_config.dart';

void customToast({required String msg, required var color, int? time}) =>
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: time ?? 1,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
