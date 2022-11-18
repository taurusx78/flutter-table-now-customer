import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/location_controller.dart';
import 'package:table_now/ui/custom_color.dart';

class LocationBar extends StatelessWidget {
  final dynamic tapFunc;

  LocationBar({Key? key, required this.tapFunc}) : super(key: key);

  final LocationController controller = Get.put(LocationController());

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: lightGrey,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(
                Icons.location_on,
                color: primaryColor,
                size: 20,
              ),
              const SizedBox(width: 5),
              Obx(
                () => controller.isLoaded.value
                    ? Text(
                        controller.myLocation.value,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : Container(
                        width: 20,
                        height: 20,
                        margin: const EdgeInsets.only(left: 5),
                        child: const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
              ),
            ],
          ),
          Obx(
            () => controller.isLoaded.value
                ? Material(
                    color: lightGrey,
                    child: InkWell(
                      child: Row(
                        children: const [
                          Icon(
                            Icons.my_location,
                            color: primaryColor,
                            size: 16,
                          ),
                          Text(
                            ' 내 위치',
                            style: TextStyle(fontSize: 14, color: primaryColor),
                          ),
                        ],
                      ),
                      onTap: tapFunc,
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
