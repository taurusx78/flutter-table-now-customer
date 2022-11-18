import 'package:flutter/material.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/details/components/time_row_text.dart';
import 'package:table_now/ui/screen_size.dart';

class HoursBottomSheet extends StatelessWidget {
  HoursBottomSheet({Key? key}) : super(key: key);

  List<String> days = ['월', '화', '수', '목', '금', '토', '일'];

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
            padding: EdgeInsets.symmetric(vertical: 13),
            child: Text(
              '영업정보',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 1,
            color: blueGrey,
          ),
          Expanded(
            child: ListView.separated(
              itemCount: 7,
              itemBuilder: (context, index) {
                return _buildHoursInfo(
                  days[index],
                  '수정예정',
                  '수정예정',
                  '수정예정',
                );
              },
              separatorBuilder: (context, index) => Container(
                height: 1,
                color: blueGrey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursInfo(
      String day, String businessHours, String breakTime, String lastOrder) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),
          Column(
            children: [
              TimeRowText(title: '영업시간', info: businessHours),
              const SizedBox(height: 10),
              TimeRowText(title: '휴게시간', info: breakTime),
              if (lastOrder != '없음')
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: TimeRowText(title: '주문마감', info: lastOrder),
                ),
            ],
          )
        ],
      ),
    );
  }
}
