import 'blog.dart';
import 'notice.dart';

class Store {
  final int id; // 매장 id
  final String name; // 매장명
  final String category; // 카테고리
  final String phone; // 전화
  final String address; // 도로명주소
  final String detailAddress; // 상세주소
  final String jibunAddress; // 지번주소
  final double latitude; // 위도
  final double longitude; // 경도
  final String description; // 소개
  final String website; // 웹사이트

  final List<String> basicImageUrlList; // 대표사진 리스트
  final List<String> insideImageUrlList; // 매장내부사진 리스트
  final String insideModified; // 매장내부사진 최종수정일
  final List<String> menuImageUrlList; // 메뉴사진 리스트
  final String menuModified; // 메뉴사진 최종수정일

  final int allTableCount; // 전체테이블 수
  final int tableCount; // 잔여테이블 수

  final String businessHours; // 오늘의 영업시간
  final String breakTime; // 오늘의 휴게시간
  final String lastOrder; // 오늘의 주문마감시간

  final String state; // 영업상태
  final String updated; // 업데이트 시간

  final List<Notice> noticeList; // 알림 리스트
  final List<Blog> blogList; // 네이버 블로그 리뷰 리스트

  Store({
    required this.id,
    required this.name,
    required this.category,
    required this.phone,
    required this.address,
    required this.detailAddress,
    required this.jibunAddress,
    required this.latitude,
    required this.longitude,
    required this.description,
    required this.website,
    required this.basicImageUrlList,
    required this.insideImageUrlList,
    required this.insideModified,
    required this.menuImageUrlList,
    required this.menuModified,
    required this.allTableCount,
    required this.tableCount,
    required this.businessHours,
    required this.breakTime,
    required this.lastOrder,
    required this.state,
    required this.updated,
    required this.noticeList,
    required this.blogList,
  });

  // JSON 데이터를 Dart 오브젝트로 변경
  Store.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        category = json['category'],
        phone = json['phone'],
        address = json['address'],
        detailAddress = json['detailAddress'],
        jibunAddress = json['jibunAddress'],
        latitude = json['latitude'],
        longitude = json['longitude'],
        description = json['description'],
        website = json['website'],
        basicImageUrlList = List.from(json['basicImageUrlList']),
        insideImageUrlList = List.from(json['insideImageUrlList']),
        insideModified = json['insideModified'],
        menuImageUrlList = List.from(json['menuImageUrlList']),
        menuModified = json['menuModified'].substring(0, 8),
        allTableCount = json['allTableCount'],
        tableCount = json['tableCount'],
        businessHours = json['businessHours'],
        breakTime = json['breakTime'],
        lastOrder = json['lastOrder'],
        state = json['state'],
        updated = json['updated'],
        noticeList = List.from(json['noticeList'])
            .map((notice) => Notice.fromJson(notice))
            .toList(),
        blogList = List.from(json['blogList'])
            .map((blog) => Blog.fromJson(blog))
            .toList();
}
