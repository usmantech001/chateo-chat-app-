import 'package:cached_network_image/cached_network_image.dart';
import 'package:chateo/controller/personal_chat_controller.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class PickedImageScreen extends StatelessWidget {
  const PickedImageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<PersonalChatController>(
      builder: (personalChatController) {
        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 30.h,
                left: 20.w,
                child: GestureDetector(
                  onTap: () => Get.back(),
                  child: Icon(Icons.cancel))),
               Align(
                alignment: Alignment.center,
                child:personalChatController.isUploadingImage==true?CircularProgressIndicator(): ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.sizeOf(context).width,
                    maxHeight: 330.h 
                  ),
                  child: CachedNetworkImage(
                    imageUrl:personalChatController.imgUrl! ),
                  ),
              ),
              Positioned(
                bottom: 20.h,
                right: 10.w,
                left: 10.w,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    textFieldContainer(hintText: 'Add a caption', controller: personalChatController.imageTextController),
                    SizedBox(height: 15.h,),
                    GestureDetector(
                      onTap: () => personalChatController.sendImageMessage(),
                      child: Image.asset('assets/images/send.png', height: 35,width: 35,))
                  ],
                ))
            ],
          ),
        );
      }
    );
  }
}