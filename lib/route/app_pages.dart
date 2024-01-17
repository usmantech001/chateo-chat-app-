// ignore_for_file: constant_identifier_names, prefer_const_constructors

import 'package:chateo/middleware/welcome_middleware.dart';
import 'package:chateo/view/authentication/otp_verification_screen.dart';
import 'package:chateo/view/authentication/phone_sign_in_screen.dart';
import 'package:chateo/view/authentication/profile_screen.dart';
import 'package:chateo/view/authentication/sign_up_screen.dart';
import 'package:chateo/view/authentication/verification_success_screen.dart';
import 'package:chateo/view/authentication/verify_email_screen.dart';
import 'package:chateo/view/bottom_nav/bottom_nav.dart';
import 'package:chateo/view/bottom_nav/chat_screen.dart';
import 'package:chateo/view/bottom_nav/contact_screen.dart';
import 'package:chateo/view/chat/personal_chat_screen.dart';
import 'package:chateo/view/chat/picked_image_Screen.dart';
import 'package:chateo/view/onboard/onboard_screen.dart';
import 'package:get/get.dart';

class AppRoute{
  static const String ONBOARD = '/';
  static const String SIGN_UP ='/sign_up';
  static const String VERIFY_EMAIL = '/verify_email';
  static const String VERIFY_SUCCESS = '/verify_success';
  static const String BOTTOMNAV ='/bottom_nav';
  static const String OTP_SCREEN ='/otp_screen';
  static const String PROFILE ='/profile';
  static const String PERSONAL_CHAT = '/personal_chat';
  static const String CHAT = '/chat';
  static const String PICKED_IMAGE = '/picked_image';

 static List<GetPage> pages =[
    GetPage(
      name: ONBOARD,
      middlewares: [
        WelcomeMiddleware(priority: 1)
      ],
      page: ()=> OnboardScreen()),
    GetPage(name: SIGN_UP, page: ()=> PhoneSignInScreen()),
    GetPage(name: VERIFY_EMAIL, page: ()=> VerifyEmailScreen()),
    GetPage(name: VERIFY_SUCCESS, page: ()=> VerificationScuccessScreen()),
    GetPage(name: BOTTOMNAV, page: ()=>BottomNavScreen()),
    GetPage(name: OTP_SCREEN, page: ()=>OtpVerificationScreen()),
    GetPage(name: PROFILE, page: ()=>ProfileScreen()),
    GetPage(name: PERSONAL_CHAT, page: ()=>PersonalChatScreen()),
    GetPage(name: CHAT, page: ()=> ChatScreen(),),
    GetPage(name: PICKED_IMAGE, page: ()=>PickedImageScreen())
  ];

}