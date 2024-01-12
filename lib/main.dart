import 'dart:io';

import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/dep/init.dart' as dep;
import 'package:chateo/route/app_pages.dart';
import 'package:chateo/storage/storage_service.dart';
import 'package:chateo/view/authentication/phone_sign_in_screen.dart';
import 'package:chateo/view/authentication/sign_up_screen.dart';
import 'package:chateo/view/onboard/onboard_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid? await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyAemIL4gAHBIHnDvCEKP8Z3qhcRbWqtDz4", 
      appId: "1:166281742356:android:c2ae6f49be771403873f01", 
      messagingSenderId: "166281742356", 
      projectId: "chateo-a7a4d"
      )
  ): await Firebase.initializeApp();
  await Get.putAsync(() => StorageService().init());
   Get.put(UserStore());
  await dep.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(392, 783),
      builder: (_,context) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(

            colorScheme: ColorScheme.fromSeed(seedColor: AppColors.MainColor),
            useMaterial3: true,
          ),
          //home: SignUpScreen(),
          initialRoute: AppRoute.PROFILE,
          getPages: AppRoute.pages,
        );
      }
    );
  }
}

