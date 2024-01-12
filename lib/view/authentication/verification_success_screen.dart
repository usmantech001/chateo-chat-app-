import 'package:chateo/route/app_pages.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class VerificationScuccessScreen extends StatelessWidget {
  const VerificationScuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
           children: [
             Container(
            
              height: 330.h,
              width: MediaQuery.sizeOf(context).width,
              child: Lottie.asset('assets/lottie/successful.json'),

            ),
            bigText(text: 'Your account is successfully created!', ),
          SizedBox(height: 10.h,),
            reusableText(text: 'Welcome to your Ultimate Chatting Destination. Your Account is Created, Unleash the joy of Seamless Online Chatting', fontSize: 16, color: Colors.black54),
            Padding(
              padding: EdgeInsets.only(top: 30.h, bottom: 20.h),
              child: button(text: 'Continue', onTap: (){
                 Get.offAndToNamed(AppRoute.BOTTOMNAV);
              }),
            ),
          
           ],
        ),
      ),
    );
  }
}