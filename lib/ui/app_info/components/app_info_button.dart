import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';

class AppInfoButton extends StatelessWidget {
  final String title;
  final IconData? icon;
  final dynamic routeFunc;

  const AppInfoButton({
    Key? key,
    required this.title,
    this.icon,
    required this.routeFunc,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: 60,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: const BoxDecoration(
            border: Border(
          bottom: BorderSide(color: blueGrey),
        )),
        child: Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: Icon(icon!),
                    ),
                  Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: Text(
                      title,
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ],
              ),
              const Icon(
                Icons.keyboard_arrow_right_rounded,
                color: Colors.black54,
              ),
            ],
          ),
        ),
      ),
      onTap: routeFunc,
    );
  }
}
