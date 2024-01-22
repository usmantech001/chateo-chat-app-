import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/controller/more_controller.dart';
import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  GetBuilder<MoreController>(
      builder: (moreController) {
        return Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            flexibleSpace: Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 20.w, left: 20.w, top: 50.h),
              color: Colors.white,
            //  height: 100,
            child:  Column(
              children: [
                bigText(text: 'More', color: Color(0xFF0F1828)),
              ],
            ),
            ),
            scrolledUnderElevation: 0,
          ),
          backgroundColor: Colors.white,
          body:SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              children: [
                Material(
                  elevation: 0.5,
                  color: Colors.white,
                  child: Container(
                    padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 15.h, bottom: 15.h),
                   // margin: EdgeInsets.only(bottom: 20.h),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                       
                       
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                moreController.profileData!.imgUrl!=null? CachedNetworkImage(
                                      imageUrl: moreController.profileData!.imgUrl!,
                                      fit: BoxFit.cover,
                                      width: 50.w,
                                      height: 50.h,
                                      imageBuilder: (context, imageProvider) {
                                        return CircleAvatar(
                                        //radius: 35.sp,
                                        
                                       backgroundImage: imageProvider,
                                        
                                        );
                                      },
                                     ): CircleAvatar(
                                  radius: 25.sp,
                                  backgroundColor: const Color(0xFFEDEDED),
                                 child: Image.asset('assets/images/account.png', height: 30.h,),
                                ),
                                Container(
                                  width: 200.w,
                                  padding: EdgeInsets.only(left: 15.w, ),
                                 // color: Colors.black,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      bigText(text: '${moreController.profileData!.firstName??''} ${moreController.profileData!.lastName??''}', fontSize: 20.sp),
                                      reusableText(text: moreController.profileData!.phoneNumber??'', color: Color(0xFFADB5BD))
                                    ],
                                  ),
                                )
                              ],
                            ),
                            Icon(Icons.navigate_next, size:28.sp ,color: Color(0xFF0F1828),)
                          ],
                        )
                      ],
                    ),
                    ),
                ),

              Container(
                margin: EdgeInsets.only(top: 30.h),
                child: Column(
                  children: [
                     moreContainer(imgPath: 'account', text: 'Account'),
                 moreContainer(imgPath: 'chats', text: 'Chat'),
                 moreContainer(imgPath: 'appearance', text: 'Appearance'),
                 moreContainer(imgPath: 'notification', text: 'Notification'),
                 moreContainer(imgPath: 'privacy', text: 'Privacy'),
                 moreContainer(imgPath: 'data_usage', text: 'Data Usage'),
                 moreContainer(imgPath: 'Help', text: 'Help'),
                 moreContainer(imgPath: 'invite', text: 'Invite Your Friends')
                  ],
                ),
              )
              ],
            ),
          ) ,
        );
      }
    );
  }
}