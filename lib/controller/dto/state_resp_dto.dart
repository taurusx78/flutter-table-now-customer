// 영업상태 업데이트 요청 결과로 응답받은 데이터를 담은 DTO

class StateRespDto {
  final String state; // 영업상태
  final int tableCount; // 잔여테이블 수
  final String updated; // 업데이트 시간
  final String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간

  StateRespDto({
    required this.state,
    required this.tableCount,
    required this.updated,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  StateRespDto.fromJson(Map<String, dynamic> json)
      : state = json['state'],
        tableCount = json['tableCount'],
        updated = json['updated'],
        businessHours = json['businessHours'],
        breakTime = json['breakTime'],
        lastOrder = json['lastOrder'];
}
