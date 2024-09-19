import 'package:pet_app/pages/auth/login_page.dart';
import 'package:pet_app/pages/auth/register_page.dart';
import 'package:pet_app/pages/auth/forget_password_page.dart';
import 'package:pet_app/pages/home/add_pet_page.dart';
import 'package:pet_app/pages/my/profile_page.dart';
import 'package:pet_app/pages/my/del_account_page.dart';
import 'package:pet_app/pages/my/forget_password_page.dart';
import 'package:pet_app/pages/home_container_page.dart';
import 'package:pet_app/pages/home/home_page.dart';
import 'package:pet_app/pages/my/edit_profile_page.dart';
import 'package:pet_app/pages/my/change_password_page.dart';
import 'package:pet_app/pages/search/search_place_page.dart';
import 'package:pet_app/pages/socail/socail_page.dart';
import 'package:pet_app/pages/load_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String loadPage = '/load_page';
  static const String loginPage = '/login_page';
  static const String registerPage = '/register_page';
  static const String forgetPasswordPage = '/forget_password_page';
  static const String homeContainerPage = '/home_container_page';
  static const String homePage = '/home_page';
  static const String searchPage = '/search_page';
  static const String socialPage = '/social_page';
  static const String accountPage = '/account_page';
  static const String profilePage = '/profile_page';
  static const String changePasswordPage = '/change_password_page';
  static const String delAccountdPage = '/del_account_page';
  static const String forgetPasswordPage2 = '/forget_password_page2';
  static const String notificationPage = '/notification_page';
  static const String vaccinePage = '/vaccine_page';
  static const String drugPage = '/drug_page';
  static const String medicaldPage = '/medicald_page';
  static const String dietPage = '/diet_page';
  static const String excretionPage = '/excretion_page';
  static const String addPetPage = '/add_pet_page';
  static const String accessControlPage = '/access_control_page';

  static Map<String, WidgetBuilder> routes = {
    // Auth頁面
    loadPage: (context) => const LoadPage(),
    loginPage: (context) => const LoginPage(),
    registerPage: (context) => const RegisterPage(),
    forgetPasswordPage: (context) => const ForgetPassword(),

    // 導航欄頁面
    homeContainerPage: (context) => const HomeContainerPage(),
    homePage: (context) => const HomePage(),
    searchPage: (context) => const SearchPlacePage(),
    socialPage: (context) => const SocialPage(),
    accountPage: (context) => const ProfilePage(),
    profilePage: (context) => const EditProfilePage(),

    // 登入後Auth頁面
    changePasswordPage: (context) => const ChangePasswordPage(),
    delAccountdPage: (context) => const DelAccountPage(),
    forgetPasswordPage2: (context) => const ForgetPasswordPage(),

    //
    addPetPage: (context) => const AddPetPage(),
  };
}
