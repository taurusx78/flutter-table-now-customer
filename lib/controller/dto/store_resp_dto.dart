// 서버로부터 응답받은 매장 전체정보 데이터를 담을 DTO

class StoreRespDto {
  final int id; // 매장 id
  final String name; // 매장명
  final String jibunAddress; // 지번주소
  final String basicImageUrl; // 대표사진 1개
  final String state; // 영업상태
  final int tableCount; // 잔여테이블 수
  final String updated; // 업데이트 시간
  final double distance; // 현재위치와의 거리

  StoreRespDto({
    required this.id,
    required this.name,
    required this.jibunAddress,
    required this.basicImageUrl,
    required this.state,
    required this.tableCount,
    required this.updated,
    required this.distance,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  StoreRespDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        jibunAddress = json['jibunAddress'],
        basicImageUrl = json['basicImageUrl'],
        state = json['state'],
        tableCount = json['tableCount'],
        updated = json['updated'],
        distance = json['distance'];
}
