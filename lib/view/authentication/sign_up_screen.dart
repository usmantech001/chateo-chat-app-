import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AuthController>(builder: (authController) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Stack(
            children: [
              Container(
                padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 70.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    bigText(
                      text: 'Create Account',
                    ),
                    SizedBox(
                      height: 30.h,
                    ),
                    inputContainer(
                        context: context,
                        icon: Icons.person,
                        hintText: 'Enter your username',
                        controller: authController.nameController),
                    inputContainer(
                        context: context,
                        icon: Icons.mail,
                        hintText: 'Enter your email',
                        controller: authController.emailController),
                    inputContainer(
                        context: context,
                        icon: Icons.lock,
                        hintText: 'Enter your password ',
                        isPassword: true,
                        controller: authController.passwordController,
                        obscureText: authController.isObscure1,
                        onTap: () {
                          authController.changeObscure(1);

                        },
                        ),
                        
                    inputContainer(
                        context: context,
                        icon: Icons.lock,
                        hintText: 'Confirm your password',
                        isPassword: true,
                        controller: authController.confirmPasswordController,
                        obscureText: authController.isObscure2,
                        onTap: () => authController.changeObscure(2),
                        ),
                    SizedBox(
                      height: 50.h,
                    ),
                    button(
                        text: 'Sign Up',
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          authController.registration();
                        }),
                    Padding(
                      padding: EdgeInsets.only(top: 10.h),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          reusableText(
                            text: 'Already have an account?',
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                          bigText(text: 'Log in', fontSize: 18.sp)
                        ],
                      ),
                    )
                  ],
                ),
              ),
              authController.isLoading == true
                  ?Positioned(
                  top: (MediaQuery.sizeOf(context).height/2)-100.h,
                  left:( MediaQuery.sizeOf(context).width/2)-15.w,
                 // right: MediaQuery.sizeOf(context).width/2 ,
                  child: progressIndicator()):Container(),
            ],
          ),
        ),
      );
    });
  }
}
