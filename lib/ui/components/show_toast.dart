import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(String message) {
  Fluttertoast.showToast(
    msg: message,
    backgroundColor: const Color(0xDD616161),
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
  );
}
