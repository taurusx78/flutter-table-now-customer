import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/store_controller.dart';
import 'package:table_now/ui/custom_color.dart';

class StateFilter extends StatelessWidget {
  StateFilter({Key? key}) : super(key: key);

  final StoreController _storeController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        children: List.generate(
          _storeController.filterList.length,
          (index) {
            bool isSelected = _storeController.curFilterIndex.value == index;
            return Container(
              height: 35,
              padding: const EdgeInsets.only(right: 7),
              child: ChoiceChip(
                label: Text(_storeController.filterList[index]),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : Colors.black54,
                ),
                selected: isSelected,
                selectedColor: primaryColor,
                shape: StadiumBorder(
                  side: BorderSide(
                    color: isSelected ? Colors.transparent : blueGrey,
                  ),
                ),
                backgroundColor: Colors.white,
                onSelected: (value) {
                  _storeController.changeCurFilterIndex(index);
                  // 선택한 필터 적용
                  _storeController.filterStoreList();
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
