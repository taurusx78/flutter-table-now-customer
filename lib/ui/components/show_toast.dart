import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast(context, String message, int? duration) {
  final fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: const Color(0xBB000000),
    ),
    child: Text(
      message,
      style: const TextStyle(fontSize: 15, color: Colors.white),
      textAlign: TextAlign.center,
    ),
  );

  fToast.showToast(
    child: toast,
    toastDuration: Duration(milliseconds: duration ?? 1500),
    gravity: ToastGravity.CENTER,
  );
}
