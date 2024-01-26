import 'package:chateo/route/app_pages.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OnboardScreen extends StatelessWidget {
  const OnboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(left: 20.w, right: 20.w, top: 100.h, bottom: 70.h ),
         child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //crossAxisAlignment: CrossAxisAlignment.center,
          children: [
           Column(
            children: [
               SizedBox(
              height: 300.h,
              width: double.infinity,
              child: Image.asset('assets/images/chat_illustration.png',)),
              SizedBox(height: 50.h,),
              Text('Connect easily with your family and friends over countries', textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 25.sp,
                fontWeight: FontWeight.w700,
                color: Colors.black
              ),
              
              )
            ],
           ),

          button(text: 'Start Messaging', onTap: (){
            Get.offAndToNamed(AppRoute.SIGN_UP);
          }),
          ],
         ),
      ),
    );
  }
}