 import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/controller/bttom_nav_controller.dart';
import 'package:chateo/controller/chat_list_controller.dart';
import 'package:chateo/controller/contact_controller.dart';
import 'package:chateo/controller/email_verification_controller.dart';
import 'package:chateo/controller/more_controller.dart';
import 'package:chateo/controller/notification_controller.dart';
import 'package:chateo/controller/otp_controller.dart';
import 'package:chateo/controller/personal_chat_controller.dart';
import 'package:chateo/controller/profile_controller.dart';
import 'package:get/get.dart';

Future<void> init() async{
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => BottomNavController(), fenix: true);
  Get.lazyPut(() => EmailVerificationController());
  Get.lazyPut(() => OtpController());
  Get.lazyPut(() => ProfileController());
  Get.lazyPut(() => ContactController(), fenix: true);
  Get.lazyPut(() => PersonalChatController(), fenix: true);
  Get.lazyPut(() => ChatListController(), fenix: true);
  Get.lazyPut(() => MoreController(), fenix: true);
  Get.lazyPut(() => NotificationController());
}