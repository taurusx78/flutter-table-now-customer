class StoreNameResp {
  final int id;
  final String name;

  StoreNameResp({
    required this.id,
    required this.name,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  StoreNameResp.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'];
}
