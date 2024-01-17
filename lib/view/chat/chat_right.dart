import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/constants/constants.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

Widget ChatRight(MsgContent msgContent){
  return Container(
    padding: EdgeInsets.only(right: 20.w, top: 10.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
         ConstrainedBox(
          constraints:msgContent.type=='text'? BoxConstraints(
            maxHeight: 400.h,
            maxWidth: 230.w,
            minWidth: 100.w,
           
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
                
              ):BorderRadius.all(Radius.circular(8)),
              color: AppColors.MainColor
            ),
            child:msgContent.type=='text'? Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              
              children: [
               // reusableText(text: msgContent.message!, color: Colors.white, textAlign: TextAlign.start, ),
                Text(
                  
                  msgContent.message!, 
                  textAlign: TextAlign.start,
                  style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  
                ),),
               Row(
                mainAxisSize: MainAxisSize.min,
               
                //mainAxisAlignment: MainAxisAlignment.center,
                 children: [
                  
                   Align(
                    alignment: Alignment.bottomRight,
                    child: reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: Color(0xFFFFFFFF), fontSize: 12)
                    ),
                 ],
               )
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
                  child:  reusableText(text: DateFormat().add_jm().format((msgContent.addtime! as Timestamp).toDate()), color: Color(0xFFFFFFFF), fontSize: 12)
                    )
              ],
            ),
          ),
          )
      ],
    ),
  );
}