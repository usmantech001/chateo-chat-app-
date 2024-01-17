import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MoreScreen extends StatelessWidget {
  const MoreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
                            CircleAvatar(
                              radius: 25.sp,
                            ),
                            Container(
                              width: 200.w,
                              padding: EdgeInsets.only(left: 15.w, ),
                             // color: Colors.black,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  bigText(text: 'Akanji usman', fontSize: 20.sp),
                                  reusableText(text: '+234 7067764892', color: Color(0xFFADB5BD))
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
}