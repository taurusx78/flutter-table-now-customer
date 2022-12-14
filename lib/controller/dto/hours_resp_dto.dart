class HoursRespDto {
  List<List<String>> weeklyHours;

  HoursRespDto({required this.weeklyHours});

  // JSON 데이터를 Dart 오브젝트로 변경
  static HoursRespDto fromJson(Map<String, dynamic> json) {
    List<List<String>> weeklyHours = [];
    List<dynamic> temp = List.from(json['weeklyHours']);
    for (int i = 0; i < 7; i++) {
      weeklyHours.add(List.from(temp[i]));
    }
    return HoursRespDto(weeklyHours: weeklyHours);
  }
}
