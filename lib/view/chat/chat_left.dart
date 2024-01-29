// ignore_for_file: unnecessary_cast

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/widgets/time_format.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

// ignore: non_constant_identifier_names
Widget ChatLeft(MsgContent msgContent){
  return Container(
    padding: EdgeInsets.only(left: 20.w, top: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
         constraints:msgContent.type=='text'? BoxConstraints(
            maxHeight: 400.h,
            maxWidth: 230.w,
            minWidth: 60.w,
           
          ):BoxConstraints(
            maxHeight: 400.h,
            maxWidth: 230.w
          ),
          child: Container(
           padding:msgContent.type=='text'? 
            EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h): 
            EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
            decoration: BoxDecoration(
              borderRadius:msgContent.type=='text'? BorderRadius.only(
                topLeft: Radius.circular(16.sp),
                topRight: Radius.circular(16.sp),
                bottomLeft: Radius.circular(16.sp),
                
              ):const BorderRadius.all(Radius.circular(8)),
              color: Colors.white
            ),
            child:msgContent.type=='text'?  Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                 Text(
                  
                  msgContent.message!, 
                  textAlign: TextAlign.start,
                  style: TextStyle(
                  color: const Color(0xFF0F1828),
                  fontSize: 18.sp,
                  
                ),),
                reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: const Color(0xFFADB5BD), fontSize: 10)
              ],
            ):Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                CachedNetworkImage(imageUrl: msgContent.message??''),
                SizedBox(height: 5.h,),
               msgContent.imgMessage==''?Container(): reusableText(text: msgContent.imgMessage!, color: Colors.white, textAlign: TextAlign.start),
                Align(
                  alignment: Alignment.centerRight,
                  child:  reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: const Color(0xFFFFFFFF), fontSize: 12)
                    )
              ],
            ),
          ),
          )
      ],
    ),
  );
}

// ignore: non_constant_identifier_names
Widget ChatLeft1(MsgContent msgContent, DateTime time){
  return Column(
    children: [
      Container(
        padding: EdgeInsets.symmetric(horizontal: 10.h, vertical: 10.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10
          )
        ),
        child: Text(
          timeFormat(time), 
          style: const TextStyle(
          color: Colors.grey
        ),),
      ),
      Container(
        padding: EdgeInsets.only(left: 20.w, top: 10.h),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            ConstrainedBox(
             constraints:msgContent.type=='text'? BoxConstraints(
                maxHeight: 400.h,
                maxWidth: 230.w,
                minWidth: 60.w,
               
              ):BoxConstraints(
                maxHeight: 400.h,
                maxWidth: 230.w
              ),
              child: Container(
               padding:msgContent.type=='text'? 
                EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h): 
                EdgeInsets.symmetric(horizontal: 5.w, vertical: 5.h),
                decoration: BoxDecoration(
                  borderRadius:msgContent.type=='text'? BorderRadius.only(
                    topLeft: Radius.circular(16.sp),
                    topRight: Radius.circular(16.sp),
                    bottomLeft: Radius.circular(16.sp),
                    
                  ):const BorderRadius.all(Radius.circular(8)),
                  color: Colors.white
                ),
                child:msgContent.type=='text'?  Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    
                     Text(
                      
                      msgContent.message!, 
                      textAlign: TextAlign.start,
                      style: TextStyle(
                      color: const Color(0xFF0F1828),
                      fontSize: 18.sp,
                      
                    ),),
                    reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: const Color(0xFFADB5BD), fontSize: 10)
                  ],
                ):Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CachedNetworkImage(imageUrl: msgContent.message??''),
                    SizedBox(height: 5.h,),
                   msgContent.imgMessage==''?Container(): reusableText(text: msgContent.imgMessage!, color: Colors.white, textAlign: TextAlign.start),
                    Align(
                      alignment: Alignment.centerRight,
                      child:  reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: const Color(0xFFFFFFFF), fontSize: 12)
                        )
                  ],
                ),
              ),
              )
          ],
        ),
      ),
    ],
  );
}