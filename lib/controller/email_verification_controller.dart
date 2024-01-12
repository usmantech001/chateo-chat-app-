import 'dart:async';

import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class EmailVerificationController extends GetxController{
final auth = FirebaseAuth.instance;

  @override
  Future<void> onInit() async {
    // TODO: implement onInit
    super.onInit();
   await emailVerification();
    setAutoRedirect();

  }
 
  emailVerification() async{
    try{
        await AuthController.instance.emailVerification();
    }catch (e){
       
    }
  }
  setAutoRedirect(){
    Timer.periodic( const Duration(seconds: 1), (timer) {
        auth.currentUser!.reload();
        final user = auth.currentUser;
        if(user!.emailVerified){
          timer.cancel();
          Get.offAndToNamed(AppRoute.VERIFY_SUCCESS);
          
        }
     });
  }
}