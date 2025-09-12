import 'package:get/get.dart';

import '../presentation/auth/pages/auth_welcome_page.dart';
import '../presentation/auth/pages/phone_input_page.dart';
import '../presentation/auth/pages/otp_verify_page.dart';
import '../presentation/auth/pages/select_country_city_page.dart';
import '../presentation/auth/pages/select_role_page.dart';
import '../presentation/home/pages/home_router.dart';

class Routes {
  static const welcome = '/auth/welcome';
  static const phone = '/auth/phone';
  static const otp = '/auth/otp';
  static const countryCity = '/auth/country-city';
  static const role = '/auth/role';
  static const home = '/home';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: welcome, page: () => const AuthWelcomePage()),
    GetPage(name: phone, page: () => const PhoneInputPage()),
    GetPage(name: otp, page: () => const OtpVerifyPage()),
    GetPage(name: countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: role, page: () => const SelectRolePage()),
    GetPage(name: home, page: () => const HomeRouter()),
  ];
}
