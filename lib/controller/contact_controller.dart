import 'dart:convert';

import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/model/user_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:chateo/storage/storage_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController{
  @override
  void onInit() {
    super.onInit();
     print('initttt');
    getContacts();
   // getUserData();
    userId = getUserId();
   
  }
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    getUserData();
   

  }
  static ContactController get instance => Get.find();
  late String userId;
  final searchController = TextEditingController();
  final db = FirebaseFirestore.instance;
  final id = UserStore.instance.getUserID();
  List<UserData> usersList =[];
  List<UserData> usersContactList =[];
  List<Contact> contactsList = [];
   String number = '0803 60 16 ';
   List<String> contactData =[];
   SnapshotOptions options = SnapshotOptions();
   
  getContacts() async {
   List<Contact> contacts= await ContactsService.getContacts();
   for(Contact contact in contacts){
    for(Item phone in contact.phones!){
      var phoneNumber = phone.value!.replaceAll(RegExp(r'\D'),"");
      getMatchedContact(phoneNumber, contact);
    
    }
   }
  
  }

 String getUserId(){
    if(UserStore.instance.userId.isNotEmpty){
    return UserStore.instance.getUserID();
    }else{
      return '';
    }
  }

 saveContactList(List<UserData> contacts){
  for(var contact in contacts){
    contactData.add(jsonEncode(contact.toFirestore()));
  }
  UserStore.instance.saveContactList(contactData);
  print('saved');
  getSavedContact();
 }
 List<UserData>getSavedContact(){
   List<String>? contacts = [];
   contacts = UserStore.instance.getSavedContact();
   
   List<UserData> users =[];
   contacts!.forEach((element) {
    print(element);
    // users.add();
   });
   return users;
 }

 List<UserData> savedContact(){
    setContactData = getSavedContact();
    return usersContactList;
 }

 set setContactData(List<UserData> contacts){
   usersContactList = contacts;
   for(var contact in contacts){
    usersList.add(contact);
   }
 }

  getUserData() async{
     await db.collection('users').withConverter(
      fromFirestore: UserData.fromFirestore, 
      toFirestore: (UserData userdata, options)=> userdata.toFirestore()
      ).where('id', isNotEqualTo: id).snapshots().listen((event) {
        usersList=[];
        for(var changes in event.docChanges){
          
          if(changes.doc!=null){
          //  usersList =[];
          UserData user;
            usersList.add(changes.doc.data()!);
            update();
           // saveContactList(usersList);
           // update();
          //  UserStore.instance.saveContactList(jsonEncode(user.toFirestore(usersList)))
           // update();
            
          }
        }
      }); 

    // var users=   await db.collection('users').withConverter(
    //   fromFirestore: UserData.fromFirestore, 
    //   toFirestore: (UserData userdata, options)=> userdata.toFirestore()
    //   ).where('id', isNotEqualTo: id).get();
    //    usersList =[];
    //   for(var user in users.docs){
         
    //     usersList.add(user.data());
    //   }
  }

  getMatchedContact(String phoneNumber, Contact contact){
    
    for(var user in usersList){
     if(phoneNumber.length<=10){
     }else{
      if(user.phoneNumber!.substring(user.phoneNumber!.length-10).contains(phoneNumber.substring(phoneNumber.length-10)) ){
           contactsList=[];
           contactsList.add(contact);
           update();
      }else{
        
      }
     }
      
    }
  }
  goToChat(UserData to_userdata) async {
     print('The user id is ${userId}');
      var from_messages= await db.collection('message').withConverter(
      fromFirestore: Msg.fromFirestore, 
      toFirestore: (Msg msg, options)=>msg.toFirestore()
      ).where('from_uid', isEqualTo:userId ).where('to_uid', isEqualTo: to_userdata.id).get();

      var to_messages= await db.collection('message').withConverter(
      fromFirestore: Msg.fromFirestore, 
      toFirestore: (Msg msg, options)=>msg.toFirestore()
      ).where('from_uid', isEqualTo : to_userdata.id ).where('to_uid', isEqualTo: userId).get();
        print('The from_messages doc is ${from_messages.docs} ');
        print('The to_messages doc is ${to_messages.docs} ');
      if(from_messages.docs.isEmpty&&to_messages.docs.isEmpty ){
  
        String savedProfile = UserStore.instance.getUserDetails();
        UserProfileData userProfile = UserProfileData.fromJson(jsonDecode(savedProfile));
        
        final msg = Msg(
          from_name: userProfile.firstName,
          to_name: to_userdata.firstName,
          from_uid: userProfile.id,
          to_uid: to_userdata.id,
          last_msg: '',
          last_time: Timestamp.now(),
          unread_msg: 0
        );
        await db.collection('message').withConverter(
      fromFirestore: Msg.fromFirestore, 
      toFirestore: (Msg msg, options)=>msg.toFirestore()
      ).add(msg).then((value){
        Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id' : value.id,
          'to_uid': to_userdata.id??'',
          'to_name': to_userdata.firstName??'',
          'imgUrl': to_userdata.imgUrl??''
        });
         print('The from_messages doc is ${from_messages.docs} ');
        print('The to_messages doc is ${to_messages.docs} ');
      });
      }
      else {
        if(from_messages.docs.isNotEmpty){
           Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id' : from_messages.docs.first.id,
          'to_uid': to_userdata.id??'',
          'to_name': to_userdata.firstName??'',
          'imgUrl': to_userdata.imgUrl??''
        });
        }
         if(to_messages.docs.isNotEmpty){
           Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id' : to_messages.docs.first.id,
          'to_uid': to_userdata.id??'',
          'to_name': to_userdata.firstName??'',
          'to_imgUrl': to_userdata.imgUrl??''
        });
        }
      }
  }
}