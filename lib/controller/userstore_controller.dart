import 'package:chateo/constants/constants.dart';
import 'package:chateo/storage/storage_service.dart';
import 'package:get/get.dart';

class UserStore extends GetxController{
  static UserStore get instance => Get.find();
  final userId ='';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

  }

   Future<void> saveUserDetails(String value) async{
     await StorageService.instance.setString(AppConstants.SAVE_USER_PROFILE, value);
    }
    setUserID(String userID) async {
      await StorageService.instance.setString(AppConstants.SAVE_USER_ID, userID);
    }
}