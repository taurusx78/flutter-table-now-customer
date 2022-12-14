class StoreNameRespDto {
  final int id;
  final String name;

  StoreNameRespDto({
    required this.id,
    required this.name,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  StoreNameRespDto.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
