import 'package:chateo/model/user_model.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
late String userID;
late String phoneNumber;
final picker = ImagePicker();

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   userID= Get.parameters['userID']??'';
   phoneNumber = Get.parameters['phoneNumber']??'';
  }
  final firstNameController = TextEditingController();
 final lastNameontroller = TextEditingController();
 String imgPath ='';

 saveUserProfile(){
  if(firstNameController.text.isEmpty){
    errorSnackbar(title: 'Required', message: 'Please input your first name');
  }else{
   final userdata = UserModel(
      imgUrl: imgPath,
      id: userID,
      firstName: firstNameController.text.trim(),
      lastName: lastNameontroller.text.trim(),
      phoneNumber: phoneNumber
    );
  }
 }

 pickImage() async {
 XFile? pickedImg= await picker.pickImage(source: ImageSource.gallery);
 if(pickedImg!=null){
  print(pickedImg.path);
 }
 }
}