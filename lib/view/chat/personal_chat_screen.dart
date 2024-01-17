import 'dart:io';

import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/personal_chat_controller.dart';
import 'package:chateo/view/chat/chat_list.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class PersonalChatScreen extends StatelessWidget {
  const PersonalChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonalChatController>(
      builder: (personalChatController) {
        return Scaffold(
          
        backgroundColor: AppColors.textFieldColor,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          elevation: 5,
          flexibleSpace: Container(
            padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 20.h),
            height: 100,
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 10.w),
                  child: GestureDetector(
                    onTap: () {
                      Get.back();
                    },
                    child:Platform.isIOS? Icon(Icons.navigate_before, size: 38.sp,):Icon(Icons.arrow_back_sharp, size: 25.sp,)),
                ),
                CircleAvatar(
                  radius: 20.sp,
                  backgroundColor: AppColors.textFieldColor,
                ),
                Container(
                  margin: EdgeInsets.only(left: 10.w),
                  height: 40,
                  alignment: Alignment.centerLeft,
                  width: 190.w,
                 // color: Colors.red,
                  child: bigText(text: personalChatController.to_name)),
                  Expanded(child: Container()),
                  Padding(
                    padding: EdgeInsets.only(left: 5.w, right: 5.w),
                    child: Icon(Icons.search),
                  ),
                  Icon(Icons.more_vert)
              ],
            ),
          ),
        ),
          body: SafeArea(
            child: Column(
              children: [
                const Expanded(child: ChatList()),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    margin: EdgeInsets.only(top: 0.h),
                    padding: EdgeInsets.only(bottom: 10.h, right: 20.w, left: 10.w, top: 5.h),
                    color: Colors.white,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                       // Image.asset('assets/images/add.png', height: 35,width: 35,),
                       Expanded(
                         child: Card(
                          color: AppColors.textFieldColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                          ),
                           child: TextFormField(
                            controller: personalChatController.messasgeController,
                           expands: false,
                            maxLines: 7,
                            minLines: 1,
                            keyboardType: TextInputType.multiline,
                            decoration:const InputDecoration(
                              isDense: true,
                              hintText: 'send message...',
                              hintStyle:  TextStyle(
                                color: AppColors.hintTextColor
                              ),
                              //prefixIcon: Icon(Icons.person),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide.none,
                                
                              ),
                              focusedBorder:  OutlineInputBorder(
                                borderSide: BorderSide.none,
                                
                              ),
                            ),
                           ),
                         ),
                       ),
                       Padding(
                         padding: EdgeInsets.only(left: 10.w, bottom: 15.h),
                         child: GestureDetector(
                          onTap: () => personalChatController.pickImage(),
                          child: Icon(Icons.image_outlined, size: 30.sp,)),
                       ),
                            Padding(
                              padding: EdgeInsets.only(left: 5.w, bottom: 15.h),
                              child: GestureDetector(
                                onTap: (){
                                  if(personalChatController.messasgeController.text.isNotEmpty){
                                    personalChatController.sendMessage();
                                  }
                                },
                                child: Image.asset('assets/images/send.png', height: 35,width: 35,)
                                ),
                            ),
                        
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      }
    );
  }
}