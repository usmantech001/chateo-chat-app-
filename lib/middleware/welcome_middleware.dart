import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class WelcomeMiddleware extends GetMiddleware {
 @override
 int? priority =0;
 WelcomeMiddleware({this.priority});
  @override
  RouteSettings? redirect(String? route) {

    if(UserStore.instance.isLogin==true){
      return RouteSettings(name: AppRoute.BOTTOMNAV);

    }else{
      return null;
    }
  }
}