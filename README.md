# TABLE NOW (고객용)
매장의 실시간 영업정보를 제공하는 앱의 고객용 버전이다.
<br><br>

## 설명
Flutter를 이용한 크로스플랫폼 앱으로 매장을 이용하려는 고객에게 실시간 매장 정보를 제공하는 역할을 한다.<br>
매장의 영업정보가 매장 상황에 따라 예기치 않게 임시 변동된 경우, 고객이 겪게 되는 불편함을 해결하기 위해 해당 서비스를 기획하게 되었다.<br>
1. 매장명을 직접 입력하거나 카테고리를 선택해 찾고자 하는 매장을 검색할 수 있다.
2. 검색 결과는 매장 영업상태에 따라 필터를 적용하거나, 조건(업데이트순, 거리순 등)에 따라 정렬할 수 있다.
3. 로컬 DB인 SQLite를 이용해 앱 사용자가 계정 생성 없이 매장 즐겨찾기 기능을 이용할 수 있도록 하였다.
4. 매장 정보가 업데이트된 시간과 잔여테이블 수 정보를 제공해 고객들이 현재의 매장 상황을 확인할 수 있도록 하였다.
<br>

## 기술스택
- Flutter
- GetX (상태관리)
- SQLite
<br>

## Open API
- 네이버 지도 API
  - [네이버 지도 API 소개](https://www.ncloud.com/product/applicationService/maps)
  - [네이버 지도앱 연동 URL Scheme](https://guide.ncloud-docs.com/docs/naveropenapiv3-maps-url-scheme-url-scheme)
  <br>
- 카카오 애드핏
  - [카카오 애드핏 홈페이지](https://adfit.kakao.com/info)
<br>

## 스크린샷 (일부)
<div>
  <img src="https://user-images.githubusercontent.com/56622731/211699552-330b7312-bd6a-42a5-afa7-10f29aa989c6.png" alt="홈" width="200" style="border: 1px solid grey"/>
  <img src="https://user-images.githubusercontent.com/56622731/211699583-fd18acf5-c91f-4b8f-a943-4ae60b795198.png" alt="카테고리" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211699622-baf56b33-0b19-465a-805b-11f64bfd99a3.png" alt="검색" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211701433-7508cbca-6130-4114-a609-13cfab3ac7e2.png" alt="즐겨찾기" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211699645-e5a7548d-0c7b-4f0a-afc0-a713fd136d8d.png" alt="상세보기1" width="200"/>
  <img src="https://user-images.githubusercontent.com/56622731/211701669-70e38477-dbf9-4d08-b2c5-8327d65e0bca.png" alt="상세보기2" width="200"/>
</div><br><br>

## 변경/추가 고려중인 기능
- (변경) 네이버 지도 API &rarr; 카카오 역지오코딩, 구글 맵 API
  - 네이버 지도 API 정책 변경으로 월 한도 초과 시 요금 부과됨
  <br>
- (추가) 리뷰
  - 고객 계정 생성 필요함
<br>
