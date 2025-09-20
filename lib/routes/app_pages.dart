import 'package:get/get.dart';

import '../presentation/auth/pages/auth_welcome_page.dart';
import '../presentation/auth/pages/phone_input_page.dart';
import '../presentation/auth/pages/otp_verify_page.dart';
import '../presentation/auth/pages/select_country_city_page.dart';
import '../presentation/auth/pages/select_role_page.dart';
import '../presentation/home/pages/home_router.dart';
import '../presentation/auth/pages/username_password_page.dart';
import '../presentation/auth/pages/email_optional_page.dart';
import '../presentation/auth/pages/id_scan_page.dart';
import '../presentation/auth/pages/login_username_password_page.dart';
import '../presentation/auth/pages/mfa_otp_page.dart';
import '../presentation/auth/pages/terms_page.dart';
import '../presentation/auth/pages/summary_page.dart';

class Routes {
  static const welcome = '/auth/welcome';
  static const phone = '/auth/phone';
  static const otp = '/auth/otp';
  static const countryCity = '/auth/country-city';
  static const role = '/auth/role';
  static const home = '/home';

  // Nuevas rutas
  static const registerUsername = '/auth/register/username';
  static const registerEmail = '/auth/register/email';
  static const registerIdScan = '/auth/register/id-scan';
  static const registerTerms = '/auth/register/terms';
  static const loginUserPass = '/auth/login';
  static const loginMfa = '/auth/login/mfa';
  static const registerSummary = '/auth/register/summary';

  static final pages = <GetPage<dynamic>>[
    GetPage(name: welcome, page: () => const AuthWelcomePage()),
    GetPage(name: phone, page: () => const PhoneInputPage()),
    GetPage(name: otp, page: () => const OtpVerifyPage()),
    GetPage(name: countryCity, page: () => const SelectCountryCityPage()),
    GetPage(name: role, page: () => const SelectRolePage()),
    GetPage(name: home, page: () => const HomeRouter()),

    // Nuevas
    GetPage(name: registerUsername, page: () => const UsernamePasswordPage()),
    GetPage(name: registerEmail, page: () => const EmailOptionalPage()),
    GetPage(name: registerIdScan, page: () => const IdScanPage()),
    GetPage(name: registerTerms, page: () => const TermsPage()),
    GetPage(name: loginUserPass, page: () => const LoginUsernamePasswordPage()),
    GetPage(name: loginMfa, page: () => const MfaOtpPage()),
    GetPage(name: registerSummary, page: () => const SummaryPage()),
  ];
}
