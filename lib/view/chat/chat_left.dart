import 'package:chateo/model/msg_model.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget ChatLeft(MsgContent msgContent){
  return Container(
    padding: EdgeInsets.only(left: 20.w, top: 20.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 100.h,
            maxWidth: 230.w
          ),
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.sp),
                topRight: Radius.circular(16.sp),
                bottomLeft: Radius.circular(16.sp),
                
              ),
              color: Colors.white
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                reusableText(text: msgContent.message!, color: Color(0xFF0F1828), textAlign: TextAlign.start),
                reusableText(text: '9:15', color: Color(0xFFADB5BD), fontSize: 10)
              ],
            ),
          ),
          )
      ],
    ),
  );
}