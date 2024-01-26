import 'dart:io';
import 'package:chateo/constants/constants.dart';
import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/user_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:chateo/widgets/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class ProfileController extends GetxController{
late String userID;
late String phoneNumber;
final picker = ImagePicker();
XFile? image;
File? imageFile;
String? imgUrl;
final db = FirebaseFirestore.instance;
final messaging = FirebaseMessaging.instance;
bool isSaving = false;
String deviceToken = '';

@override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
   userID= Get.parameters['userID']??'';
   phoneNumber = Get.parameters['phoneNumber']??'';

    requestPermission();
    requestDeviceToken();
  }
  final firstNameController = TextEditingController();
 final lastNameontroller = TextEditingController();

 requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    if(settings.authorizationStatus== AuthorizationStatus.authorized){
    } else if( settings.authorizationStatus == AuthorizationStatus.provisional){
    }else{
    }

  }
requestDeviceToken() async{
    await messaging.getToken().then((token){
      deviceToken = token??'';
      update();
    });
  }
 saveUserProfile() async {
  if(firstNameController.text.isEmpty){
    errorSnackbar(title: 'Required', message: 'Please input your first name');
  }else{
    isSaving=true;
    update();
   final userdata = UserData(
      imgUrl: imgUrl,
      id: userID,
      firstName: firstNameController.text.trim(),
      lastName: lastNameontroller.text.trim(),
      phoneNumber: phoneNumber,
      token: deviceToken,
      isOnline: true
    );
    final userProfile = UserProfileData(
      imgUrl: imgUrl,
      id: userID,
      firstName: firstNameController.text.trim(),
      lastName: lastNameontroller.text.trim(),
      phoneNumber: phoneNumber,
      
    );
    
    UserStore.instance.saveUserDetails(userProfile.toJson());
    UserStore.instance.setUserID(userID);
  final user =await db.collection('users').where('id', isEqualTo: userID).get();
    if(user.docs.isEmpty){
      try{
          await db.collection('users').add(userdata.toJson()).then((value){
      
      isSaving =false;
      update();
      UserStore.instance.login(true);
      Get.snackbar('Success', 'Login Success', backgroundColor: AppColors.MainColor, colorText: Colors.white);
      Get.offAllNamed(AppRoute.BOTTOMNAV);
    }
    );
        
      } catch (e){
        isSaving =false;
        update();

      }
      
    }else{
      try{
         await db.collection('users').doc(user.docs.first.id).update(userdata.toJson()).then((value){
        isSaving =false;
        update();
        UserStore.instance.login(true);
        Get.snackbar('Success', 'Login Success', backgroundColor: AppColors.MainColor, colorText: Colors.white);
        Get.offAllNamed(AppRoute.BOTTOMNAV);
      });

      }catch (e){
        isSaving =false;
      update();
      }
     
    }
  }
 }

 pickImage() async {
 final pickedImg= await picker.pickImage(source: ImageSource.gallery);
 if(pickedImg!=null){
  image = XFile(pickedImg.path);
  imageFile = File(image!.path);
  update();
  uploadImage(imageFile);
 
 }
 }
 uploadImage(File? imageFile) async {
     if(imageFile!=null){
      var imagePath = imageFile.path;
     final storageRef = FirebaseStorage.instance.ref('profile').child(imagePath);
     storageRef.putFile(imageFile).snapshotEvents.listen((event) async{
      switch(event.state){
        case TaskState.running:
         break;
         
        case TaskState.paused:
         break;

         case TaskState.canceled:
           break;

         case TaskState.error:
          break;  

        case TaskState.success:  
       getImgUrl(imageFile.path);
      }
     });
     }
 }

 Future<void> getImgUrl(String imgPath) async {
  final spaceRef =  FirebaseStorage.instance.ref('profile').child(imgPath);
   imgUrl = await spaceRef.getDownloadURL();
   update();
 }
//  updateUserProfile() async{
//   try{
//     await db.collection('users').doc().update();
//   }catch (e){

//   }
//  }
 }