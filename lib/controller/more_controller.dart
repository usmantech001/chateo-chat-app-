import 'dart:convert';

import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/user_model.dart';
import 'package:get/get.dart';

class MoreController extends GetxController{
  UserProfileData? profileData;
 @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    getUserDetails();
  }

  getUserDetails(){
   String userDetails = UserStore.instance.getUserDetails();
     profileData = UserProfileData.fromJson(jsonDecode(userDetails));
     print(profileData!.firstName??'');
  }
}