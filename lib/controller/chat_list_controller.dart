import 'package:chateo/controller/personal_chat_controller.dart';
import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ChatListController extends GetxController{
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
  }
  @override
  void onReady() {
    super.onReady();

  //  getChatListData();
    chatListData();
 
  }
  static ChatListController get instance => Get.find();
final id = UserStore.instance.getUserID();
  final searchController = TextEditingController();
 final db = FirebaseFirestore.instance;
 List<Msg> chatList =[];
 List<DocumentSnapshot<Msg>> chatData = [];
 String to_uid ='';
 String to_name ='';
 String to_imgUrl = '';
 String to_token = '';


  getChatListData() async{
    db.collection('message').withConverter(
    fromFirestore: Msg.fromFirestore, 
    toFirestore: (Msg msg, options)=> msg.toFirestore()
    ).orderBy('last_time', descending: false).snapshots().listen((event) {
      for(var change in event.docChanges){
        switch(change.type){
          case DocumentChangeType.added:
          if(change.doc.data()!=null){
            
            chatList.insert(0, change.doc.data()!);
            update();
          }
          break;
          case DocumentChangeType.modified:
          break;
          case DocumentChangeType.removed:
          break;
        }
      }
    });
  }

  chatListData() async {
    chatData =[];
    var from_messages = db.collection('message').withConverter(
    fromFirestore: Msg.fromFirestore, 
    toFirestore: (Msg msg, options)=> msg.toFirestore()
    ).where('from_uid', isEqualTo:id ).snapshots().listen((event) {
      
      for(var change in event.docChanges){  
       // chatData.add(change.doc);
       chatData =[];
        chatData.addAll(event.docs);
        update();
      }
    });
    var to_messages = db.collection('message').withConverter(
    fromFirestore: Msg.fromFirestore, 
    toFirestore: (Msg msg, options)=> msg.toFirestore()
    ).where('to_uid', isEqualTo:id ).snapshots().listen((event) {
      
      for(var change in event.docChanges){
        chatData =[];
        chatData.addAll(event.docs);
        update();
      }
    });
    

  }
  goChat(DocumentSnapshot<Msg> user){
    if(user.data()!.from_uid==id){
      to_uid = user.data()!.to_uid!??'';
      to_name = user.data()!.to_name??'';
      to_imgUrl = user.data()!.to_imgUrl??'';
      to_token = user.data()!.to_token??'';
      update();
    }else{
       to_uid = user.data()!.from_uid!;
      to_name = user.data()!.from_name??'';
      to_imgUrl = user.data()!.from_imgUrl??'';
      to_token = user.data()!.from_token??'';
      update();
    }
     Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id' : user.id,
          'to_uid': to_uid,
          'to_name': to_name,
          'to_imgUrl': to_imgUrl,
          'to_token' : to_token
        }
        );
  }

  String imgUrl(DocumentSnapshot<Msg> user){
      if(user.data()!.from_uid==id){
        return user.data()!.to_imgUrl??'';
      }else{
        return user.data()!.from_imgUrl??'';
      }
  }
}