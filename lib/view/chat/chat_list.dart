import 'package:chateo/controller/personal_chat_controller.dart';
import 'package:chateo/view/chat/chat_left.dart';
import 'package:chateo/view/chat/chat_right.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ChatList extends StatelessWidget {
  const ChatList({super.key,});

  @override
  Widget build(BuildContext context) {
   // final personalChatController = PersonalChatController.instance;
    return GetBuilder<PersonalChatController>(
      builder: (personalChatController) {
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          reverse: true,
          controller: ScrollController(),
          slivers: [
           SliverPadding(
            padding: EdgeInsets.only(bottom: 10.h, top: 10.h),
            sliver: SliverList(
              
              delegate: SliverChildBuilderDelegate(
                
                childCount: personalChatController.msgList.length,
                (context, index) {
                  var msgcontent = personalChatController.msgList[index];
                    if(msgcontent.uid==personalChatController.userId){
                       return ChatRight(msgcontent);
                    }else{
                      return ChatLeft(msgcontent);
                    }
                  
                }
                )
              ),
            ),
          ],
        );
      }
    );
  }
}