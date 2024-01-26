import 'package:chateo/controller/email_verification_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class VerifyEmailScreen extends StatelessWidget {
  const VerifyEmailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<EmailVerificationController>(
      builder: (emailController) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              children: [
                SizedBox(
                  height: 330.h,
                  width: MediaQuery.sizeOf(context).width,

                ),
                bigText(text: 'verify your email address!', ),
                Padding(
                  padding:EdgeInsets.symmetric(vertical: 15.h),
                  child: reusableText(text: 'akanjiusman67@gmail.com', fontSize: 15),
                ), 
                reusableText(text: 'Congratulations! Your Account Awaits verify Your Email to Start Sending Message to Your Friends and Family', fontSize: 16, color: Colors.black54),
                Padding(
                  padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
                  child: button(text: 'Continue', onTap: (){
                
                  }),
                ),
                GestureDetector(
                  onTap: () => emailController.emailVerification(),
                  child: reusableText(text: 'Resend Email', fontSize: 15))
              ],
            ),
          ),
        );
      }
    );
  }
}