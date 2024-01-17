import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/auth_controller.dart';
import 'package:chateo/controller/profile_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ProfileController>(builder: (profileController) {
      return Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          title: bigText(text: 'Profile'),
          centerTitle: true,
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                margin: EdgeInsets.only(top: 30.h, left: 20.w, right: 20.w),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: AppColors.textFieldColor,
                          radius: 60,
                          child: profileController.imgUrl != null
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: CachedNetworkImage(
                                    imageUrl: profileController.imgUrl!,
                                    height: MediaQuery.sizeOf(context).height,
                                    width: MediaQuery.sizeOf(context).width,
                                    fit: BoxFit.cover,
                                    )
                                  )
                              : Image.asset(
                                  'assets/images/add_icon.png',
                                  height: 50,
                                ),
                        ),
                        Positioned(
                            bottom: 0.h,
                            right: 0,
                            child: GestureDetector(
                                onTap: () => profileController.pickImage(),
                                child: Image.asset(
                                  'assets/images/person.png',
                                  height: 35.h,
                                )))
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50.h, bottom: 20.h),
                      child: textFieldContainer(
                          hintText: 'First Name (Required)',
                          controller: profileController.firstNameController),
                    ),
                    textFieldContainer(
                        hintText: 'Last Name (Optional)',
                        controller: profileController.lastNameontroller),
                    SizedBox(
                      height: 50.h,
                    ),
                    button(
                        text: 'Save',
                        onTap: () {
                          profileController.saveUserProfile();
                          FocusScope.of(context).unfocus();
                        })
                  ],
                ),
              ),
            ),
            profileController.isSaving == true
                  ?Positioned(
                  top: (MediaQuery.sizeOf(context).height/2)-100.h,
                  left:( MediaQuery.sizeOf(context).width/2)-15.w,
                 // right: MediaQuery.sizeOf(context).width/2 ,
                  child: progressIndicator()):Container(),
          ],
        ),
      );
    });
  }
}
