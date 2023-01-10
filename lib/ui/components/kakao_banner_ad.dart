import 'package:flutter/material.dart';
import 'package:flutter_adfit/flutter_adfit.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:table_now/ui/custom_color.dart';

class KakaoBannerAd extends StatelessWidget {
  const KakaoBannerAd({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: blueGrey,
          ),
          child: const Center(
            child: Text('테이블나우'),
          ),
        ),
        Positioned(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: blueGrey, width: 1),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(5),
              child: AdFitBanner(
                adId: dotenv.env['kakaoAdfitBannerCode']!,
                adSize: AdFitBannerSize.BANNER,
                listener: (AdFitEvent event, AdFitEventData data) {
                  switch (event) {
                    case AdFitEvent.AdReceived:
                      break;
                    case AdFitEvent.AdClicked:
                      break;
                    case AdFitEvent.AdReceiveFailed:
                      print('카카오 애드핏 광고 노출 실패');
                      break;
                    case AdFitEvent.OnError:
                      print('카카오 애드핏 광고 초기화 실패');
                      break;
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
