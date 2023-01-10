import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LocationController extends GetxController {
  SharedPreferences? pref; // 위치정보 내부저장소에 저장
  final RxString myLocation = '서울 강남구'.obs; // 현재위치 지번주소
  final RxDouble myLat = 37.514575.obs; // 현재위치 위도
  final RxDouble myLon = 127.0495556.obs; // 현재위치 경도
  final RxBool loaded = true.obs;

  @override
  Future<void> onInit() async {
    print('Location Controller 초기화됨');
    super.onInit();
    // 과거 위치정보 불러오기
    pref = await SharedPreferences.getInstance();
    var location = pref!.getStringList('location');
    if (location != null) {
      myLocation.value = location[0];
      myLat.value = double.parse(location[1]);
      myLon.value = double.parse(location[2]);
    }
  }

  // 현재위치 정보 얻기
  Future<String> getCurrentLocation() async {
    loaded.value = false;
    String result = '';
    // 위치정보 수집동의 얻기
    LocationPermission permission = await Geolocator.requestPermission();
    print(permission);
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      print(position);
      myLat.value = position.latitude; // 위도
      myLon.value = position.longitude; // 경도
      print('현재위치 위도/경도: ${myLat.value}, ${myLon.value}');

      // 네이버 API 통신을 위한 헤더 설정
      Map<String, String> headers = {
        // Client ID
        'X-NCP-APIGW-API-KEY-ID': dotenv.env['naverMapClientId']!,
        // Client Secret
        'X-NCP-APIGW-API-KEY': dotenv.env['naverMapClientSecret']!,
      };
      // 위도/경도를 지번주소로 변환 (네이버 API)
      dynamic response = await http.get(
          Uri.parse(
              'https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc?request=coordsToaddr&coords=${myLon.value},${myLat.value}&sourcecrs=epsg:4326&output=json'),
          headers: headers);

      String stringData = response.body;
      Map<String, dynamic> jsonData = jsonDecode(stringData);

      if (jsonData['status']['code'] == 0) {
        // 요청 성공
        var region = jsonData['results'][0]['region'];
        myLocation.value = region['area1']['name'] +
            ' ' +
            region['area2']['name'] +
            ' ' +
            region['area3']['name'];
        // 저장된 위치정보 업데이트
        pref = await SharedPreferences.getInstance();
        pref!.setStringList('location',
            [myLocation.value, myLat.value.toString(), myLon.value.toString()]);
        result = '위치정보가 업데이트 되었습니다.';
      } else {
        // 요청 실패 (ex. 해외 지역)
        result = '위치정보를 찾을 수 없습니다. (예. 해외 지역)';
      }
    } else {
      result = '위치정보 수집에 동의해 주세요.';
    }
    loaded.value = true;
    return result;
  }
}
