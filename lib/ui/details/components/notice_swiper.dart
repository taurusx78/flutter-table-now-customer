import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/details_controller.dart';
import 'package:table_now/data/store/model/notice.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';
import 'package:table_now/util/host.dart';

import 'index_indicator.dart';
import 'notice_round_text.dart';

class NoticeSwiper extends StatelessWidget {
  final List<Notice> noticeList;

  NoticeSwiper({Key? key, required this.noticeList}) : super(key: key);

  final DetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 20, 15, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 알림 헤더
          Row(
            children: [
              const Text(
                '알림',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 5),
              Text(
                '${noticeList.length}개',
                style: const TextStyle(color: primaryColor),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 알림 목록
          SizedBox(
            height: 110, // 높이 지정 필수!
            child: Swiper(
              itemCount: noticeList.length,
              itemBuilder: (context, index) {
                return _buildNoticeItem(context, noticeList[index]);
              },
              onIndexChanged: (index) {
                controller.changeCurNoticeIndex(index);
              },
              viewportFraction: 1,
              scale: 0.8,
              loop: false,
            ),
          ),
          // const CustomDivider(),
          Container(
            height: 1,
            color: blueGrey,
            margin: const EdgeInsets.only(top: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildNoticeItem(context, Notice notice) {
    // 첨부사진 유무
    bool existImage = notice.imageUrlList.isNotEmpty;
    // 임시휴무 유무
    bool hasHoliday = notice.holidayStart != '';

    return GestureDetector(
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blueGrey),
              color: lightGrey2,
            ),
            child: Row(
              children: [
                // 첨부사진이 있는 경우
                if (existImage)
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(5),
                      child: Image.network(
                        '$host/image?type=notice&filename=' +
                            notice.imageUrlList[0],
                        width: 90,
                        height: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                SizedBox(
                  width: existImage
                      ? getScreenWidth(context) - 152
                      : getScreenWidth(context) - 52,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // 알림 라벨
                          const NoticeRoundText(title: '알림'),
                          // 휴무 라벨
                          if (hasHoliday)
                            const Padding(
                              padding: EdgeInsets.only(left: 5),
                              child: NoticeRoundText(title: '휴무'),
                            ),
                          const SizedBox(width: 8),
                          // 알림 등록일
                          Text(
                            '${notice.createdDate} 등록',
                            style: const TextStyle(
                                fontSize: 14, color: Colors.black54),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      // 제목
                      Text(
                        notice.title.replaceAll('', '\u{200B}'), // 말줄임 에러 방지
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: !hasHoliday ? 2 : 1,
                      ),
                      // 휴무 알림인 경우
                      if (hasHoliday)
                        Padding(
                          padding: const EdgeInsets.only(top: 5),
                          child: _buildHolidayText(
                            notice.holidayStart,
                            notice.holidayEnd,
                            18,
                            15,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 인덱스
          Positioned(
            right: 1,
            top: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(4),
                  bottomLeft: Radius.circular(4),
                ),
                color: Colors.black45,
              ),
              child: Obx(
                () => Text(
                  '${controller.curNoticeIndex.value + 1}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      onTap: () {
        // 첨부사진 인덱스 초기화
        controller.changeCurNoticeImageIndex(0);
        // 알림 상세보기 Dialog
        _showNoticeDialog(context, notice, existImage, hasHoliday);
      },
    );
  }

  void _showNoticeDialog(
      context, Notice notice, bool existImage, bool hasHoliday) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          contentPadding: EdgeInsets.zero,
          content: Builder(
            builder: (context) {
              return SizedBox(
                width: getScreenWidth(context) * 0.9,
                height: existImage
                    ? getScreenHeight(context) * 0.6
                    : getScreenHeight(context) * 0.3,
                child: ListView(
                  children: [
                    // 첨부사진이 있는 경우
                    if (notice.imageUrlList.isNotEmpty)
                      Container(
                        height: getScreenHeight(context) * 0.3,
                        padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                        child: _buildNoticeImageList(notice.imageUrlList),
                      ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: const [
                                  // 알림 라벨
                                  NoticeRoundText(title: '알림'),
                                  // 휴무 라벨
                                  Padding(
                                    padding: EdgeInsets.only(left: 8),
                                    child: NoticeRoundText(title: '휴무'),
                                  ),
                                ],
                              ),
                              // 알림 등록일
                              Text(
                                '${notice.createdDate} 등록',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 15),
                          // 제목
                          Text(
                            notice.title,
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 10),
                          // 휴무 알림인 경우
                          if (hasHoliday)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: _buildHolidayText(
                                notice.holidayStart,
                                notice.holidayEnd,
                                20,
                                16,
                              ),
                            ),
                          // 내용
                          Text(notice.content),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildHolidayText(String holidayStart, String holidayEnd,
      double iconSize, double fontSize) {
    return RichText(
      text: TextSpan(
        children: [
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Padding(
              padding: const EdgeInsets.only(right: 5),
              child: Icon(
                Icons.event_note,
                size: iconSize,
                color: Colors.blueGrey,
              ),
            ),
          ),
          TextSpan(
            text:
                '${holidayStart.substring(2)} ~ ${holidayEnd.substring(2)} 휴무',
            style: TextStyle(
              fontSize: fontSize,
              color: Colors.black,
            ),
          )
        ],
      ),
      overflow: TextOverflow.ellipsis,
      maxLines: 1, // 한 줄 말줄임
    );
  }

  Widget _buildNoticeImageList(List<String> imageUrlList) {
    int noticeImageCount = imageUrlList.length;
    return Stack(
      children: [
        Swiper(
          itemCount: noticeImageCount,
          itemBuilder: (context, index) {
            return GestureDetector(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(5),
                child: Image.network(
                  '$host/image?type=notice&filename=' + imageUrlList[index],
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              onTap: () {
                Get.toNamed(
                  Routes.image,
                  arguments: ['notice', imageUrlList, index],
                );
              },
            );
          },
          onIndexChanged: (index) {
            controller.changeCurNoticeImageIndex(index);
          },
          loop: false,
        ),
        // 이미지 인덱스 Indicator
        Positioned(
          right: 5,
          bottom: 5,
          child: Obx(
            () => IndexIndicator(
              index: controller.curNoticeImageIndex.value + 1,
              length: noticeImageCount,
            ),
          ),
        ),
      ],
    );
  }
}
