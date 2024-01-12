 import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/controller/bttom_nav_controller.dart';
import 'package:chateo/controller/email_verification_controller.dart';
import 'package:chateo/controller/otp_controller.dart';
import 'package:chateo/controller/profile_controller.dart';
import 'package:get/get.dart';

Future<void> init() async{
  Get.lazyPut(() => AuthController(), fenix: true);
  Get.lazyPut(() => BottomNavController());
  Get.lazyPut(() => EmailVerificationController());
  Get.lazyPut(() => OtpController());
  Get.lazyPut(() => ProfileController());
}