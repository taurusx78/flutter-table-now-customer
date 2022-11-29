import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/details_controller.dart';
import 'package:table_now/ui/components/loading_indicator.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/details/components/time_row_text.dart';
import 'package:table_now/ui/screen_size.dart';

class HoursBottomSheet extends StatelessWidget {
  HoursBottomSheet({Key? key}) : super(key: key);

  List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

  final DetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: getScreenHeight(context) * 0.6,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        color: Colors.white,
      ),
      child: Column(
        children: [
          // 헤더
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 15),
            child: Text(
              '영업시간',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 1,
            color: blueGrey,
          ),
          Obx(
            () {
              if (controller.isHoursLoaded.value) {
                var weeklyHours = controller.weeklyHours.value.weeklyHours!;
                double width = getScreenWidth(context) - 150;
                return Expanded(
                  child: ListView.separated(
                    itemCount: 7,
                    itemBuilder: (context, index) {
                      return _buildHoursInfo(
                        days[index],
                        weeklyHours[index][0],
                        weeklyHours[index][1],
                        weeklyHours[index][2],
                        weeklyHours[index][3],
                        width,
                      );
                    },
                    separatorBuilder: (context, index) => Container(
                      height: 1,
                      color: blueGrey,
                    ),
                  ),
                );
              } else {
                return const LoadingIndicator(height: 200);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHoursInfo(String day, String businessHours, String breakTime,
      String lastOrder, String holidayWeek, double width) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 15, 20, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 요일
          Text(
            day,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          // 영업시간 정보
          holidayWeek != '매주'
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TimeRowText(title: '영업시간', info: businessHours),
                    const SizedBox(height: 10),
                    TimeRowText(title: '휴게시간', info: breakTime),
                    if (lastOrder != '없음')
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TimeRowText(title: '주문마감', info: lastOrder),
                      ),
                    if (holidayWeek != '')
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: TimeRowText(
                          title: '정기휴무',
                          info: '매월 $holidayWeek $day요일',
                          width: width,
                        ),
                      ),
                  ],
                )
              : TimeRowText(title: '정기휴무', info: '$holidayWeek $day요일 휴무')
        ],
      ),
    );
  }
}
