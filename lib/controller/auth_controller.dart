import 'package:chateo/route/app_pages.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AuthController extends GetxController{
  @override
  void onInit()async {
    // TODO: implement onInit
    super.onInit();
  }
  static  AuthController get instance => Get.find();
 final nameController = TextEditingController();
 final emailController = TextEditingController();
 final passwordController = TextEditingController();
 final phoneController = TextEditingController();
 
 final confirmPasswordController = TextEditingController();
 final auth = FirebaseAuth.instance;
 bool isObscure1=true;
 bool isObscure2 =true;
 bool isLoading = false;
 String verificationId ='';
 bool isVerifyingPhoneNumber = false;
 bool isVerifyingOtp = false;
 String countryDialCode = '+234 ';



 registration() async {
  if(passwordController.text!=confirmPasswordController.text){
    snackbar(title: 'Password Error', message: "Password doesn'\t match");
  }else if(nameController.text.isEmpty){
    snackbar(title: 'Username', message: 'Please provide your username');
  }else if(emailController.text.isEmpty){
    snackbar(title: 'Email', message: 'Please provide your email');
  }else if(passwordController.text.isEmpty||confirmPasswordController.text.isEmpty){
    snackbar(title: 'Password', message: 'Please provide your password');
  }else{
     try{
     isLoading = true;
     update();
    await auth.createUserWithEmailAndPassword(
      email: emailController.text.trim(), 
      password: passwordController.text.trim()
      );
    isLoading=false;
    update();
    Get.offAndToNamed(AppRoute.VERIFY_EMAIL);
  } on FirebaseException catch (e) {
    isLoading=false;
    update();
   snackbar(title: 'Account creation failed', message: e.code);
  }
  }
  
 }
 emailVerification() async {
  try{
    await auth.currentUser!.sendEmailVerification();
  // ignore: empty_catches
  }catch (e){

  }
 }
 changeObscure(int value){
  if(isObscure1==true&&value==1){
    isObscure1=false;
 
    update();
  }else if(isObscure1==false&&value==1){
    isObscure1=true;

    update();
  }else if(value!=1 && isObscure2==true){
    isObscure2=false;
 
    update();
  }else if(isObscure2==false && value!=1){
    isObscure2=true;

    update();
  }
 }

 verifyPhoneNumber(String phoneNumber) async {
  
  isVerifyingPhoneNumber =true;
  update();
  try{
      await auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          await auth.signInWithCredential(credential);
          
        }, 
        verificationFailed: (FirebaseAuthException e){
          isVerifyingPhoneNumber =false;
          update();
            errorSnackbar(title: 'Verification Failed', message: e.code);
        }, 
        codeSent: (verificationId, resedncode){
          verificationId = verificationId;
          update();
          isVerifyingPhoneNumber =false;
          update();
          Get.offAndToNamed(AppRoute.OTP_SCREEN, parameters: {
            'verificationId': verificationId,
            'phoneNumber': phoneNumber
          });

        }, codeAutoRetrievalTimeout:(verificationId) {
          verificationId=verificationId;
          update();

        }
        
        );
  }catch (e){

  }
 }

 verifyOtp(String verificationId, String smsCode, String phoneNumber) async {
  isVerifyingOtp =true;
  update();
  try{
     final userCredential= await auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: verificationId, smsCode: smsCode));
     if(userCredential.user!=null){
      // var token =await userCredential.user!.getIdToken();
      //  print('The token is ${token}');
      isVerifyingOtp =false;
      update();

      Get.offAndToNamed(AppRoute.PROFILE, parameters: {
        'userID': userCredential.user!.uid,
        'phoneNumber': phoneNumber
      });

     }
  }on FirebaseException catch (e){
     isVerifyingOtp =false;
     update();
     errorSnackbar(title: 'Errre', message: e.code);
  }
 }

  updateCountryDialCode(String dialCode){
    countryDialCode=dialCode;
    update();
  }
  
}

