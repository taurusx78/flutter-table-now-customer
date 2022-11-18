import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:jiffy/jiffy.dart';
import 'package:table_now/controller/dto/store_resp.dart';
import 'package:table_now/route/routes.dart';
import 'package:table_now/ui/components/state_round_box.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/screen_size.dart';
import 'package:table_now/util/host.dart';

class StoreItem extends StatelessWidget {
  final StoreResp store;
  final bool isBookmark;

  const StoreItem({
    Key? key,
    required this.store,
    required this.isBookmark,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: blueGrey, width: 1),
        ),
        child: Row(
          children: [
            // 대표사진
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(5),
                bottomLeft: Radius.circular(5),
              ),
              child: Image.network(
                '$host/image?type=basic&filename=' + store.basicImageUrl,
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              width: getScreenWidth(context) - 30 < 500
                  ? getScreenWidth(context) - 132
                  : 498,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 매장명
                  Text(
                    store.name.replaceAll('', '\u{200B}'), // 말줄임 에러 방지,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 한 줄 말줄임
                  ),
                  const SizedBox(height: 5),
                  // 지번주소 & 거리
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        store.jibunAddress,
                        style: const TextStyle(color: Colors.black54),
                      ),
                      if (!isBookmark)
                        Text(
                          ' · ${store.distance.toStringAsFixed(1)} km',
                          style: const TextStyle(color: Colors.black54),
                        ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // 업데이트 시간
                      Row(
                        children: [
                          const Icon(
                            Icons.update,
                            color: Colors.black54,
                            size: 15,
                          ),
                          Text(
                            ' 업데이트 ' + Jiffy(store.updated).fromNow(),
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.black54,
                            ),
                          )
                        ],
                      ),
                      // 영업상태
                      StateRoundBox(
                        state: store.state,
                        tableCount: store.tableCount,
                      ),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      onTap: () async {
        Get.toNamed(Routes.details, arguments: store.id);
      },
    );
  }
}
