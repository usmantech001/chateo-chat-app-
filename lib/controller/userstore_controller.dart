import 'dart:convert';

import 'package:chateo/constants/constants.dart';
import 'package:chateo/storage/storage_service.dart';
import 'package:get/get.dart';

class UserStore extends GetxController{
  static UserStore get instance => Get.find();
  String userId ='';
  bool isLogin = false;
  @override
  void onInit() {
    super.onInit();
   // removeKey();
     isLogin = StorageService.instance.getBool(AppConstants.IS_LOGIN);
     userId = getUserID();
  }

   Future<void> saveUserDetails(value) async{
     await StorageService.instance.setString(AppConstants.SAVE_USER_PROFILE, jsonEncode(value));
    }

    Future<void> saveContactList(List<String> value) async{
     await StorageService.instance.setStringList(AppConstants.SAVE_CONTACT_LIST, value);
    }
    List<String>? getSavedContact(){
     return StorageService.instance.getStringList(AppConstants.SAVE_CONTACT_LIST);
    }
    String getUserDetails(){
     return StorageService.instance.getString(AppConstants.SAVE_USER_PROFILE);
    }
    
    setUserID(String userID) async {
      await StorageService.instance.setString(AppConstants.SAVE_USER_ID, userID);
    }

   String getUserID(){
    return  StorageService.instance.getString(AppConstants.SAVE_USER_ID);
    }

    Future<void> login(bool value) async{
     await StorageService.instance.setBool(AppConstants.IS_LOGIN, value);
    }
    removeKey(){
      StorageService.instance.removeKey(AppConstants.IS_LOGIN);
      StorageService.instance.removeKey(AppConstants.SAVE_USER_ID);
      StorageService.instance.removeKey(AppConstants.SAVE_USER_PROFILE);
    }
    
}