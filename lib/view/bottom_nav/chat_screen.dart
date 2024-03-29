import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/controller/chat_list_controller.dart';
import 'package:chateo/controller/notification_controller.dart';
import 'package:chateo/widgets/time_format.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

import '../../widgets/widgets.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    NotificationController.instance;
    return GetBuilder<ChatListController>(builder: (chatListController) {
      return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: EdgeInsets.only(top: 50.h),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      bigText(text: 'Chats'),
                      const Icon(Icons.more_vert),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
                  child: textFieldContainer(
                      hintText: 'Search',
                      controller: chatListController.searchController),
                ),
                Expanded(
                  child: CustomScrollView(
                    physics: const BouncingScrollPhysics(),
                    slivers: [
                      SliverPadding(
                        padding:
                            EdgeInsets.only(left: 20.w, right: 20.w, top: 10.h),
                        sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                                childCount: chatListController.chatData.length,
                                (context, index) {
                          var users = chatListController.chatData[index];

                          return GestureDetector(
                            onTap: () {
                              chatListController.goChat(users);
                            },
                            child: Container(
                                alignment: Alignment.center,
                                height: 68.h,
                                decoration: const BoxDecoration(
                                    border: Border(
                                        bottom: BorderSide(
                                  color: Color(0xFFEDEDED),
                                ))),
                                child: SizedBox(
                                  height: 50.h,

                                  // color: Colors.black,
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      chatListController.imgUrl(users)==''
                                          ? CircleAvatar(
                                              radius: 27.sp,
                                              
                                              backgroundColor:
                                                  Colors.grey.shade200,
                                                  child:const  Icon(
                                                Icons.person,
                                                color: Colors.grey,
                                              ),
                                            )
                                          : CachedNetworkImage(
                                            height: 60.h,
                                            width: 60.w,
                                            fit: BoxFit.cover,
                                              imageUrl: users
                                                          .data()!
                                                          .from_uid ==
                                                      chatListController.id
                                                  ? users.data()!.to_imgUrl ??
                                                      ''
                                                  : users.data()!.from_imgUrl ??
                                                      '',
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.person),
                                              imageBuilder:
                                                  (context, imageProvider) {
                                                return CircleAvatar(
                                                  backgroundImage:
                                                      imageProvider,
                                                );
                                              },
                                            ),
                                     
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 2.h),
                                        child: SizedBox(
                                          width: 200.w,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              bigText(
                                                  text: users
                                                              .data()!
                                                              .from_uid ==
                                                          chatListController.id
                                                      ? users.data()!.to_name!
                                                      : users
                                                          .data()!
                                                          .from_name!,
                                                  color:
                                                      const Color(0xFF0F1828),
                                                  fontSize: 18.w,
                                                  fontWeight: FontWeight.w600),
                                              reusableText(
                                                  text:
                                                      users.data()!.last_msg ??
                                                          '',
                                                  color: const Color(0xFFADB5BD))
                                            ],
                                          ),
                                        ),
                                      ),
                                      Expanded(child: Container()),
                                      Padding(
                                        padding:
                                            EdgeInsets.symmetric(vertical: 0.h),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            bigText(
                                              text: timeFormat((users
                                                      .data()!
                                                      .last_time as Timestamp)
                                                  .toDate(), fomChat: true),
                                              color: const Color(0xFFADB5BD),
                                              fontSize: 14.w,
                                              fontWeight: FontWeight.w600,
                                            ),
                                            
                                          chatListController.unreadMsg(users)==0?Container(): CircleAvatar(
                                              radius: 12,
                                              child: reusableText(
                                                  text: users.data()!.from_uid==chatListController.id?users.data()!.from_unread_msg.toString():users.data()!.to_unread_msg.toString(), fontSize: 12),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                )),
                          );
                        })),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ));
    });
  }
}
