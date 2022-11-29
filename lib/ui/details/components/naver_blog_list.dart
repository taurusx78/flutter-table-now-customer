import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:table_now/controller/details_controller.dart';
import 'package:table_now/data/store/model/blog.dart';
import 'package:table_now/ui/custom_color.dart';
import 'package:table_now/ui/details/components/custom_divider.dart';

class NaverBlogList extends StatelessWidget {
  final List<Blog> blogList;

  NaverBlogList({Key? key, required this.blogList}) : super(key: key);

  final DetailsController controller = Get.find();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 0, 15, 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                height: 1,
                color: blueGrey,
                margin: const EdgeInsets.only(bottom: 20),
              ),
              // 블로그 리뷰 헤더
              const Text(
                '블로그 리뷰',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 15),
              // 블로그 리뷰 목록
              _buildBlogList(),
            ],
          ),
        ),
        // 더보기 버튼
        _buildMoreButton(),
      ],
    );
  }

  Widget _buildBlogList() {
    return ListView.separated(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: blogList.length,
      itemBuilder: (context, index) {
        return GestureDetector(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: primaryColor.withOpacity(0.1)),
              color: const Color(0xFFF5FAFD),
            ),
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 제목
                  RichText(
                    text: TextSpan(
                      children: [
                        WidgetSpan(
                          alignment: PlaceholderAlignment.middle,
                          child: Padding(
                            padding: const EdgeInsets.only(right: 5),
                            child: Image.asset(
                              'assets/images/icons/edit_note.png',
                              color: primaryColor,
                              width: 28,
                            ),
                          ),
                        ),
                        TextSpan(
                          text:
                              blogList[index].title.replaceAll('', '\u{200B}'),
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 한 줄 말줄임
                  ),
                  const SizedBox(height: 5),
                  // 내용
                  Text(
                    blogList[index].description.replaceAll('', '\u{200B}'),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 두 줄 말줄임
                  ),
                  const SizedBox(height: 5),
                  // 게시일 & 블로그명
                  RichText(
                    text: TextSpan(
                      text: blogList[index].postdate + '  ·  ',
                      style:
                          const TextStyle(fontSize: 13, color: Colors.black54),
                      children: [
                        TextSpan(
                          text: blogList[index]
                              .bloggername
                              .replaceAll('', '\u{200B}'),
                        ),
                      ],
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1, // 한 줄 말줄임
                  ),
                ],
              ),
            ),
          ),
          onTap: () {
            // 블로그 리뷰 링크 연결
            controller.launchBlogUrl(index);
          },
        );
      },
      separatorBuilder: (context, index) => const SizedBox(height: 15),
    );
  }

  Widget _buildMoreButton() {
    return InkWell(
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          border: const Border(
            top: BorderSide(color: blueGrey, width: 2),
          ),
          gradient: LinearGradient(
            colors: [primaryColor.withOpacity(0.7), primaryColor],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                '블로그 검색결과 더보기',
                style: TextStyle(fontSize: 17, color: Colors.white),
              ),
              Padding(
                padding: EdgeInsets.only(top: 3),
                child: Icon(
                  Icons.keyboard_arrow_right_rounded,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        // 블로그 더보기 검색결과 연결
        controller.launchMoreResultsUrl();
      },
    );
  }
}
