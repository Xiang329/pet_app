import 'package:pet_app/pages/auth/login_page.dart';
import 'package:pet_app/pages/auth/register_page.dart';
import 'package:pet_app/pages/auth/forget_password_page.dart';
import 'package:pet_app/pages/home/access_control_page.dart';
import 'package:pet_app/pages/home/add_pet_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/excretion/excretion_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/diet/diet_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/drug/drug_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/medical/medical_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/notification/notification_page.dart';
import 'package:pet_app/pages/home/notification_and_record_pages/vaccine/vaccine_page.dart';
import 'package:pet_app/pages/my/account_page.dart';
import 'package:pet_app/pages/my/del_account_page.dart';
import 'package:pet_app/pages/my/forget_password_page.dart';
import 'package:pet_app/pages/home_container_page.dart';
import 'package:pet_app/pages/home/home_page.dart';
import 'package:pet_app/pages/my/profile_page.dart';
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
    accountPage: (context) => const AccountPage(),
    profilePage: (context) => const ProfilePage(),

    // 登入後Auth頁面
    changePasswordPage: (context) => const ChangePasswordPage(),
    delAccountdPage: (context) => const DelAccountPage(),
    forgetPasswordPage2: (context) => const ForgetPasswordPage(),

    // 寵物通知及紀錄頁面
    notificationPage: (context) => const NotificationPage(),
    vaccinePage: (context) => const VaccinePage(),
    drugPage: (context) => const DrugPage(),
    medicaldPage: (context) => const MedicalPage(),
    dietPage: (context) => const DietPage(),
    excretionPage: (context) => const ExcretionPage(),

    //
    addPetPage: (context) => const AddPetPage(),
    accessControlPage: (context) => const AccessControlPage(),
  };
}
