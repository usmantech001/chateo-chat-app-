import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService extends GetxService{
  static StorageService get instance => Get.find();
  late SharedPreferences _prefs;
   Future<StorageService> init() async{
     _prefs =await SharedPreferences.getInstance();
    return this;
   }

   Future<bool> setBool(String key, bool value) async{
    return await _prefs.setBool(key, value);
  }
  bool getBool(String key) {
   return  _prefs.getBool(key)??false;
  }

  Future<bool> setString(String key, String value) async{
    return await _prefs.setString(key, value);
  }

  String getString(String key) {
   return  _prefs.getString(key)??'';
   
  }

 Future<bool> removeKey(String key) async {
  
    return await _prefs.remove(key);
  }
}