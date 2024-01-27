import 'package:chateo/controller/auth_controller.dart';
import 'package:get/get.dart';

class OtpController extends GetxController{
  late String verificationId;
  late String phoneNumber;
  bool isVerifyingOtp = false;
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   verificationId= Get.parameters['verificationId']??'';
   phoneNumber = Get.parameters['phoneNumber']??'';
  }

  verifyOtp(smsCode, ) async {
    isVerifyingOtp = true;
    update();
  await AuthController.instance.verifyOtp(verificationId, smsCode, phoneNumber);
   isVerifyingOtp = false;
    update();
  }
}