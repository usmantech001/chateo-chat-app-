import 'package:chateo/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Widget bigText(
    {required String text,
    double fontSize = 25.0,
    FontWeight fontWeight = FontWeight.w700,
    Color color = Colors.black,
    TextOverflow overflow = TextOverflow.ellipsis}) {
  return Text(
    text,
    textAlign: TextAlign.center,
    overflow: overflow,
    style: TextStyle(
      color: color,
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
    ),
  );
}

Widget reusableText(
    {required String text,
    Color color = AppColors.Black1,
    double fontSize = 18,
    TextOverflow overflow = TextOverflow.ellipsis,
    TextAlign textAlign = TextAlign.center}) {
  return Text(
    text,
    textAlign: textAlign,
    overflow: overflow,
    style: TextStyle(color: color, fontSize: fontSize.sp),
  );
}

Widget button({
  required String text,
  required Function() onTap,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      alignment: Alignment.center,
      height: 60,
      width: double.infinity,
      decoration: BoxDecoration(
          color: AppColors.MainColor, borderRadius: BorderRadius.circular(15)),
      child: reusableText(text: text, color: Colors.white),
    ),
  );
}

Widget inputContainer({
  required BuildContext context,
  required IconData icon,
  required String hintText,
  bool isPassword = false,
  required TextEditingController controller,
  Function()? onTap,
  bool obscureText = false,
}) {
  return Container(
    margin: EdgeInsets.only(bottom: 25.h),
    padding: EdgeInsets.only(left: 10.w, right: 10.w),
    height: 55.h,
    width: MediaQuery.sizeOf(context).width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.sp),
        border: Border.all(color: Colors.grey),
        color: Colors.grey[100]),
    child: Row(
      children: [
        Icon(
          icon,
          size: 22.sp,
          color: Colors.black.withOpacity(0.3),
        ),
        Expanded(
          child: TextFormField(
            controller: controller,
            cursorColor: AppColors.MainColor,
            obscureText: obscureText,
            decoration: InputDecoration(
              isDense: true,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey[400]),
              enabledBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
              focusedBorder:
                  const OutlineInputBorder(borderSide: BorderSide.none),
            ),
          ),
        ),
        isPassword == true
            ? GestureDetector(
                onTap: onTap,
                child: Icon(
                  Icons.remove_red_eye_sharp,
                  size: 22.sp,
                  color: Colors.black.withOpacity(0.3),
                ))
            : Container()
      ],
    ),
  );
}

SnackbarController snackbar(
    {required String title,
    required String message,
    Color color = Colors.red}) {
  return Get.snackbar(title, message,
      icon: const Icon(
        Icons.error,
        color: Colors.white,
      ),
      isDismissible: true,
      backgroundColor: color,
      padding: EdgeInsets.all(10.sp),
      colorText: Colors.white);
}

Widget progressIndicator() {
  return Material(
    borderRadius: BorderRadius.circular(30),
    elevation: 5,
    child: CircleAvatar(
      radius: 30.sp,
      backgroundColor: Colors.white,
      child: const CircularProgressIndicator(
        color: AppColors.MainColor,
      ),
    ),
  );
}

errorSnackbar({required String title, required String message}) {
  return Get.snackbar(title, message,
      isDismissible: true,
      shouldIconPulse: true,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      icon: const Icon(Icons.warning),
      backgroundColor: Colors.red.shade600);
}

Widget textFieldContainer(
    {required String hintText,
    required TextEditingController controller,
    TextInputType textInputType = TextInputType.name}) {
  return Container(
    height: 50.h,
    alignment: Alignment.bottomCenter,
    width: double.infinity,
    decoration: const BoxDecoration(
      color: AppColors.textFieldColor,
    ),
    child: TextFormField(
      controller: controller,
      keyboardType: textInputType,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.hintTextColor),
        //prefixIcon: Icon(Icons.person),
        enabledBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide.none,
        ),
      ),
    ),
  );
}

Widget moreContainer({required String imgPath, required String text}) {
  return Container(
    padding: EdgeInsets.only(left: 20.w, right: 20.w, bottom: 35.h),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset(
              'assets/images/$imgPath.png',
              height: 20.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            bigText(
                text: text,
                fontSize: 20.sp,
                color: const Color(0xFF0F1828),
                fontWeight: FontWeight.w600)
          ],
        ),
        Icon(
          Icons.navigate_next,
          size: 28.sp,
          color: const Color(0xFF0F1828),
        )
      ],
    ),
  );
}
