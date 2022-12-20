import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:naver_map_plugin/naver_map_plugin.dart';
import 'package:table_now/ui/components/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class NaverMapPage extends StatelessWidget {
  NaverMapPage({Key? key}) : super(key: key);

  final String name = Get.arguments[0];
  final String address = Get.arguments[1];
  final double latitude = Get.arguments[2];
  final double longitude = Get.arguments[3];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            NaverMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(latitude, longitude),
              ),
              locationButtonEnable: true, // 현재 위치 찾기 버튼
              markers: [
                Marker(
                  markerId: 'id',
                  position: LatLng(latitude, longitude),
                  captionText: name,
                )
              ],
              onMapCreated: (NaverMapController controller) {},
            ),
            Container(
              width: double.infinity,
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(20, 20, 50, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 주소
                  Text(
                    address,
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 15),
                  Row(
                    children: [
                      // 지도앱 열기 버튼
                      InkWell(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.map_outlined,
                              size: 18,
                              color: Colors.black54,
                            ),
                            Text(
                              ' 지도앱 열기',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        onTap: () async {
                          // 매장명 URL 인코딩
                          String encodedName = Uri.encodeComponent(name);
                          // 네이버지도 앱 연동
                          Uri mapUrl = Uri.parse(
                              'nmap://place?lat=$latitude&lng=$longitude&name=$encodedName&appname=com.example.table_now');
                          if (!await launchUrl(mapUrl)) {
                            print('네이버지도 앱 연동에 실패하였습니다.');
                            throw 'Could not launch $mapUrl';
                          }
                        },
                      ),
                      const SizedBox(width: 15),
                      // 주소복사 버튼
                      InkWell(
                        child: Row(
                          children: const [
                            Icon(
                              Icons.copy_rounded,
                              size: 18,
                              color: Colors.black54,
                            ),
                            Text(
                              ' 주소복사',
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Clipboard.setData(ClipboardData(text: address));
                          showToast(context, '주소가 복사되었습니다.', null);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // 창닫기 버튼
            Positioned(
              right: 0,
              child: IconButton(
                icon: const Icon(Icons.cancel, color: Colors.black54),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
