import 'package:get/get.dart';
import 'package:table_now/binding/details_binding.dart';
import 'package:table_now/binding/main_binding.dart';
import 'package:table_now/binding/search_binding.dart';
import 'package:table_now/binding/store_binding.dart';
import 'package:table_now/ui/app_info/app_notice/app_notice_page.dart';
import 'package:table_now/ui/app_info/customer_service/customer_service_page.dart';
import 'package:table_now/ui/app_info/customer_service/faq_page.dart';
import 'package:table_now/ui/app_info/extra/extra_page.dart';
import 'package:table_now/ui/app_info/extra/license_page.dart';
import 'package:table_now/ui/app_info/help/help_page.dart';
import 'package:table_now/ui/app_info/policy/location_terms_page.dart';
import 'package:table_now/ui/app_info/policy/policy_page.dart';
import 'package:table_now/ui/app_info/policy/privacy_policy_page.dart';
import 'package:table_now/ui/app_info/policy/terms_conditions_page.dart';
import 'package:table_now/ui/category/category_results_page.dart';
import 'package:table_now/ui/details/details_page.dart';
import 'package:table_now/ui/details/image_page.dart';
import 'package:table_now/ui/details/naver_map_page.dart';
import 'package:table_now/ui/main_page.dart';
import 'package:table_now/ui/search/search_page.dart';
import 'package:table_now/ui/search/search_results_page.dart';
import 'package:table_now/ui/splash/splash_page.dart';

abstract class Routes {
  static const splash = '/splash';
  static const main = '/main';

  /* 검색 */
  static const search = '/search';
  static const searchResults = '/search_results';

  /* 카테고리 */
  static const categoryResults = '/category_results';

  /* 상세보기 */
  static const details = '/details';
  static const image = '/image';
  static const naverMap = '/naver_map';

  /* 더보기 */
  static const appNotice = '/app_notice';
  static const help = '/help';
  static const customerService = '/customer_service';
  static const faq = '/faq';
  static const policy = '/policy';
  static const termsConditions = '/terms_conditions';
  static const privacyPolicy = '/privacy_policy';
  static const locationTerms = '/location_terms';
  static const extra = '/extra';
  static const license = '/license';
}

class Pages {
  static final routes = [
    GetPage(
      name: Routes.splash,
      page: () => const SplashPage(),
    ),
    GetPage(
      name: Routes.main,
      page: () => MainPage(),
      binding: MainBinding(),
    ),
    /* 검색 */
    GetPage(
      name: Routes.search,
      page: () => SearchPage(),
      binding: SearchBinding(),
    ),
    GetPage(
      name: Routes.searchResults,
      page: () => SearchResultsPage(),
    ),
    /* 카테고리 */
    GetPage(
      name: Routes.categoryResults,
      page: () => CategoryResultsPage(),
      binding: StoreBinding(),
    ),
    /* 상세보기 */
    GetPage(
      name: Routes.details,
      page: () => DetailsPage(),
      binding: DetailsBinding(),
    ),
    GetPage(
      name: Routes.image,
      page: () => const ImagePage(),
    ),
    GetPage(
      name: Routes.naverMap,
      page: () => NaverMapPage(),
    ),
    /* 더보기 */
    GetPage(
      name: Routes.appNotice,
      page: () => const AppNoticePage(),
    ),
    GetPage(
      name: Routes.help,
      page: () => const HelpPage(),
    ),
    GetPage(
      name: Routes.customerService,
      page: () => const CustomerServicePage(),
    ),
    GetPage(
      name: Routes.faq,
      page: () => const FAQPage(),
    ),
    GetPage(
      name: Routes.policy,
      page: () => const PolicyPage(),
    ),
    GetPage(
      name: Routes.termsConditions,
      page: () => const TermsConditionsPage(),
    ),
    GetPage(
      name: Routes.privacyPolicy,
      page: () => const PrivacyPolicyPage(),
    ),
    GetPage(
      name: Routes.locationTerms,
      page: () => const LocationTermsPage(),
    ),
    GetPage(
      name: Routes.extra,
      page: () => const ExtraPage(),
    ),
    GetPage(
      name: Routes.license,
      page: () => const LicensePage(),
    ),
  ];
}
