import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PhoneSignInScreen extends StatelessWidget {
  const PhoneSignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(
      builder: (authController) {
        return Scaffold(
          appBar: AppBar(),
          body: Stack(
            children: [
              Container(
                alignment: Alignment.center,
                margin: EdgeInsets.only(left: 20.w, right: 20.w,top: 50.h ),
                 child: Column(
                
                  children: [
                    bigText(text: 'Enter your Phone Number'),
                   Padding(
                     padding: EdgeInsets.only(top: 10.h, bottom: 30.h),
                     child: reusableText(text: 'Please confirm your country code and enter your phone number'),
                   ),
                    Row(
                      children: [
                        Container(
                          color: AppColors.textFieldColor,
                          margin: EdgeInsets.only(right: 10.w),
                          //width: 50,
                          child: CountryCodePicker(
                            backgroundColor: Colors.red,
                            padding: EdgeInsets.all(0.w),
                            flagWidth: 20,
                            textStyle: TextStyle(
                              fontSize: 18.sp,
                              color: Colors.black
                            ),
                                     onChanged: (value){
                                      authController.updateCountryDialCode(value.dialCode!);
                        
                                     },
                                    
                                     initialSelection: 'NG',
                                     favorite: const ['+234','NG'],
                                     showCountryOnly: false,
                                     showOnlyCountryWhenClosed: false,
                                     alignLeft: false,
                                   ),
                        ),
                        Expanded(
                          child: textFieldContainer(hintText: 'Enter your number', controller: authController.phoneController, textInputType: TextInputType.number)
                        ),
                      ],
                    ),
                    SizedBox(height: 70.h,),
                     button(text: 'Continue', onTap: (){
                      FocusScope.of(context).unfocus();
                      authController.verifyPhoneNumber(authController.countryDialCode+authController.phoneController.text);
                     })

                  ],
                 ),
              ),
               authController.isVerifyingPhoneNumber == true
                  ?Positioned(
                  top: (MediaQuery.sizeOf(context).height/2)-100.h,
                  left:( MediaQuery.sizeOf(context).width/2)-15.w,
                 // right: MediaQuery.sizeOf(context).width/2 ,
                  child: progressIndicator()):Container(),
            ],
          ),
        );
      }
    );
  }
}