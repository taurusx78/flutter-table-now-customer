import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/ui/custom_color.dart';

class SortDropdown extends StatelessWidget {
  SortDropdown({Key? key}) : super(key: key);

  final StoreController _storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => PopupMenuButton(
        child: Row(
          children: [
            Text(
              _storeController.curSortOption.value,
              style: const TextStyle(color: Colors.black54),
            ),
            const Icon(
              Icons.keyboard_arrow_down_rounded,
              color: Colors.black54,
            ),
          ],
        ),
        itemBuilder: (context) {
          return _storeController.sortList
              .map((option) => PopupMenuItem(
                    value: option,
                    child: Text(
                      option,
                      style: TextStyle(
                        fontSize: 14,
                        color: _storeController.curSortOption.value == option
                            ? primaryColor
                            : Colors.black54,
                      ),
                    ),
                  ))
              .toList();
        },
        onSelected: (value) {
          _storeController.changeCurSortOption(value);
          // 선택한 정렬 적용
          _storeController.sortStoreList();
        },
      ),
    );
  }
}
