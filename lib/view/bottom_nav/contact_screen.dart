import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/contact_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ContactController>(builder: (contactController) {
      print('The contact list is ${contactController.usersList.length}');
      return Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 50.h),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  bigText(
                      text: 'Contact',
                      color: const Color(0xFF0F1828),
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w600),
                  const Icon(
                    Icons.add,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.w, right: 20.w, top: 20.h),
              child: textFieldContainer(
                  hintText: 'search',
                  controller: contactController.searchController),
            ),
            contactController.usersList.isEmpty
                ? Container()
                : Expanded(
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      slivers: [
                        SliverPadding(
                          padding: EdgeInsets.only(
                              left: 20.w, right: 20.w, top: 10.h),
                          sliver: SliverList(
                              delegate: SliverChildBuilderDelegate(
                                  childCount: contactController
                                      .usersList.length, (context, index) {
                            var users = contactController.usersList[index];
                            return GestureDetector(
                              onTap: () => contactController.goToChat(users),
                              child: Container(
                                  alignment: Alignment.center,
                                  height: 70.h,
                                  decoration: const BoxDecoration(
                                      border: Border(
                                          bottom: BorderSide(
                                    color: Color(0xFFEDEDED),
                                  ))),
                                  child: SizedBox(
                                    height: 50.h,
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        users.imgUrl != null
                                            ? CachedNetworkImage(
                                                imageUrl: users.imgUrl!,
                                                fit: BoxFit.cover,
                                                width: 50.w,
                                                height: 50.h,
                                                imageBuilder:
                                                    (context, imageProvider) {
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          image: imageProvider,
                                                          fit: BoxFit.cover),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15.sp),
                                                      //color: Colors.red
                                                    ),
                                                  );
                                                },
                                              )
                                            : CircleAvatar(
                                                radius: 20.sp,
                                                backgroundColor:
                                                    AppColors.textFieldColor,
                                                child: Image.asset(
                                                  'assets/images/account.png',
                                                  height: 20.h,
                                                ),
                                              ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 2.h),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              bigText(
                                                  text: users.firstName!,
                                                  color:
                                                      const Color(0xFF0F1828),
                                                  fontSize: 18.sp,
                                                  fontWeight: FontWeight.w600),
                                              reusableText(
                                                  text: 'Last seen yesterday',
                                                  color:const Color(0xFFADB5BD))
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
                  )
          ],
        ),
      );
    });
  }
}
