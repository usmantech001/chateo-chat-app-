import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/controller/otp_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class OtpVerificationScreen extends StatelessWidget {
  const OtpVerificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OtpController>(
      builder: (otpController) {
        return GetBuilder<AuthController>(
          builder: (authController) {
            return Scaffold(
              backgroundColor: Colors.white,
              body: SingleChildScrollView(
                child: Stack(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 20.w, right: 20.w,top: 100.h, bottom: 100.h),
                      
                      child: Column(
                        //mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          bigText(text: 'Enter Code', fontSize: 30.sp ),
                          SizedBox(height: 10.h,),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: reusableText(text: 'We have sent you an SMS with the code to ${otpController.phoneNumber}',color: Colors.black45 ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 25.h),
                            child: OTPTextField(
                            length: 6,
                            
                            width: MediaQuery.of(context).size.width,
                            fieldWidth: 50.w,
                            style: TextStyle(
                              fontSize: 22.sp
                            ),
                            textFieldAlignment: MainAxisAlignment.spaceBetween,
                            fieldStyle: FieldStyle.box,
                            onCompleted: (smsCode) {
                              FocusScope.of(context).unfocus();
                              //authController.setOTP(otp);
                              otpController.verifyOtp(smsCode);
                            },
                            onChanged: (value) {
                              
                            },
                          ),
                          ),
               

                          SizedBox(height: 20.h,),
                            reusableText(text: 'Didn\'t receive a code? ',),
                            SizedBox(height: 30.h,),
                            button(text: 'Resend Code', onTap: (){
                              authController.verifyPhoneNumber(otpController.phoneNumber);
                            })
                        ],
                      ),
                    ),
                    otpController.isVerifyingOtp==true?Positioned(
                  top: (MediaQuery.sizeOf(context).height/2)-100.h,
                  left:( MediaQuery.sizeOf(context).width/2)-15.w,
                 // right: MediaQuery.sizeOf(context).width/2 ,
                  child: progressIndicator()):Container(),
                  ],
                ),
              ),
            );
          }
        );
      }
    );
  }
}