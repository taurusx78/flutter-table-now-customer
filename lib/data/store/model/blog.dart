class Blog {
  final String title; // 제목
  final String description; // 내용
  final String bloggername; // 블로그명
  final String postdate; // 게시일
  final String link; // URL 링크

  Blog({
    required this.title,
    required this.description,
    required this.bloggername,
    required this.postdate,
    required this.link,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  Blog.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        description = json['description'],
        bloggername = json['bloggername'],
        postdate = json['postdate'].replaceAllMapped(
            RegExp(r'(\d{4})(\d{2})(\d{2})'), (m) => '${m[1]}.${m[2]}.${m[3]}'),
        link = json['link'];
}
