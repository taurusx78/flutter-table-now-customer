class Notice {
  final int id; // 알림 id
  final String title; // 제목
  final String content; // 내용
  final String holidayStartDate; // 임시휴무 시작일
  final String holidayEndDate; // 임시휴무 종료일
  final String createdDate; // 알림 등록일
  final List<String> imageUrlList; // 알림 첨부사진 목록

  Notice({
    required this.id,
    required this.title,
    required this.content,
    required this.holidayStartDate,
    required this.holidayEndDate,
    required this.createdDate,
    required this.imageUrlList,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  Notice.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        content = json['content'],
        holidayStartDate = json['holidayStartDate'].replaceAll('-', '.'),
        holidayEndDate = json['holidayEndDate'].replaceAll('-', '.'),
        createdDate = json['createdDate'].substring(0, 10).replaceAll('-', '.'),
        imageUrlList = List.from(json['imageUrlList']);
}
