class CodeMsgRespDto {
  final int code;
  final String message;
  final dynamic response;

  CodeMsgRespDto({
    required this.code,
    required this.message,
    this.response,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  CodeMsgRespDto.fromJson(Map<String, dynamic> json)
      : code = json['code'],
        message = json['message'],
        response = json['response'];
}
