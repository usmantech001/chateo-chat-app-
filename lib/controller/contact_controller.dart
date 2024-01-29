// ignore_for_file: non_constant_identifier_names

import 'dart:convert';

import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/model/user_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ContactController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    //getContacts();
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
  List<UserData> usersList = [];
  List<UserData> usersContactList = [];
  List<Contact> contactsList = [];
  String number = '0803 60 16 ';
  List<String> contactData = [];
  bool meActiveInPersonalChatScreen = false;
  bool toActiveInPersonalChatScreen = false;
  int from_unread = 0;
  int to_unread = 0;
  String token = '';

  getContacts() async {
    List<Contact> contacts = await ContactsService.getContacts();
    for (Contact contact in contacts) {
      for (Item phone in contact.phones!) {
        var phoneNumber = phone.value!.replaceAll(RegExp(r'\D'), "");
        getMatchedContact(phoneNumber, contact);
      }
    }
  }

  String getUserId() {
    if (UserStore.instance.userId.isNotEmpty) {
      return UserStore.instance.getUserID();
    } else {
      return '';
    }
  }

  saveContactList(List<UserData> contacts) {
    for (var contact in contacts) {
      contactData.add(jsonEncode(contact.toJson()));
    }
    UserStore.instance.saveContactList(contactData);
    print('The contact has beeen saved $contactData');
    getSavedContact();
  }

  List<UserData> getSavedContact() {
    List<String>? contacts = [];
    contacts = UserStore.instance.getSavedContact();
    update();

    List<UserData> users = [];
    contacts?.forEach((element) {
      users.add(UserData.fromJson(jsonDecode(element)));
    });
    return users;
  }

  List<UserData> savedContact() {
    setContactData = getSavedContact();
    return usersContactList;
  }

  set setContactData(List<UserData> contacts) {
    usersContactList = contacts;
    print('The userContactlist is ${usersContactList.length}');
    update();
    for (var contact in usersContactList) {
      usersList.add(contact);
      update();
      print('The saved contact is ${usersList.length}');
    }
  }

  getUserData() async {
    db
        .collection('users')
        .where('id', isNotEqualTo: id)
        .snapshots()
        .listen((event) {
      usersList = [];
      for (var changes in event.docChanges) {
        if (changes.doc != null) {
          //  usersList =[];
          usersList.add(UserData.fromJson(changes.doc.data()!));
          update();
          // saveContactList(usersList);
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

  getMatchedContact(String phoneNumber, Contact contact) {
    for (var user in usersList) {
      if (phoneNumber.length <= 10) {
      } else {
        if (user.phoneNumber!
            .substring(user.phoneNumber!.length - 10)
            .contains(phoneNumber.substring(phoneNumber.length - 10))) {
          contactsList = [];
          contactsList.add(contact);
          update();
        } else {}
      }
    }
  }

  goToChat(UserData to_userdata) async {
    String savedProfile = UserStore.instance.getUserDetails();
    UserProfileData userProfile =
        UserProfileData.fromJson(jsonDecode(savedProfile));
    var from_messages = await db
        .collection('message')
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: userId)
        .where('to_uid', isEqualTo: to_userdata.id)
        .get();

    var to_messages = await db
        .collection('message')
        .withConverter(
            fromFirestore: Msg.fromFirestore,
            toFirestore: (Msg msg, options) => msg.toFirestore())
        .where('from_uid', isEqualTo: to_userdata.id)
        .where('to_uid', isEqualTo: userId)
        .get();
    if (from_messages.docs.isEmpty && to_messages.docs.isEmpty) {
      final msg = Msg(
          from_name: userProfile.firstName,
          to_name: to_userdata.firstName,
          from_uid: userProfile.id,
          to_uid: to_userdata.id,
          last_msg: '',
          alreadyStartedConversationToday: false,
          last_time: Timestamp.now(),
          from_unread_msg: 0,
          to_unread_msg: 0,
          from_token: userProfile.deviceToken,
          to_token: to_userdata.token,
          to_imgUrl: to_userdata.imgUrl
          );
      await db
          .collection('message')
          .withConverter(
              fromFirestore: Msg.fromFirestore,
              toFirestore: (Msg msg, options) => msg.toFirestore())
          .add(msg)
          .then((value) {
        Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id': value.id,
          'from_uid': userProfile.id ?? '',
          'to_uid': to_userdata.id ?? '',
          'to_name': to_userdata.firstName ?? '',
          'imgUrl': to_userdata.imgUrl ?? '',
          'to_token': to_userdata.token ?? '',
          'from_name': userProfile.firstName ?? '',
          'from_imgUrl': userProfile.imgUrl ?? '',
          'from_token': userProfile.deviceToken??'',
          'last_time' : msg.last_time!.toDate().toString(),
          'meActiveInPersonalChatScreen': msg.from_uid == userProfile.id
              ? true.toString()
              : false.toString(),
          'toActiveInPersonalChatScreen': msg.from_uid != userProfile.id
              ? true.toString()
              : false.toString()
        });
      });
    } else {
      if (from_messages.docs.isNotEmpty) {
        if (from_messages.docs.first.data().from_uid == userProfile.id) {
          from_unread = 0;
          to_unread = from_messages.docs.first.data().to_unread_msg ?? 0;
          meActiveInPersonalChatScreen = true;
          toActiveInPersonalChatScreen = false;
          update();
        }else{
           from_unread = from_messages.docs.first.data().from_unread_msg??0;
          to_unread = 0;
          meActiveInPersonalChatScreen = false;
          toActiveInPersonalChatScreen = true;
          update();
        }
        Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id': from_messages.docs.first.id,
          'from_uid': userProfile.id ?? '',
          'to_uid': to_userdata.id ?? '',
          'to_name': to_userdata.firstName ?? '',
          'imgUrl': to_userdata.imgUrl ?? '',
          'from_token': userProfile.deviceToken??'',
          'to_token': to_userdata.token ?? '',
          'from_name': userProfile.firstName ?? '',
          'from_imgUrl': userProfile.imgUrl ?? '',
          'from_unread_msg': from_unread.toString(),
          'to_unread_msg': to_unread.toString(),
          'last_time' : from_messages.docs.first.data().last_time!.toDate().toString(),
          'meActiveInPersonalChatScreen':
              meActiveInPersonalChatScreen.toString(),
          'toActiveInPersonalChatScreen':
              toActiveInPersonalChatScreen.toString(),
              'alreadyStartedConversationToday' : from_messages.docs.first.data().alreadyStartedConversationToday.toString()
        });
      }
      if (to_messages.docs.isNotEmpty) {
        if (to_messages.docs.first.data().from_uid == userProfile.id) {
          from_unread = 0;
          to_unread = from_messages.docs.first.data().to_unread_msg ?? 0;
          meActiveInPersonalChatScreen = true;
          toActiveInPersonalChatScreen = false;
          update();
        }else{
          from_unread = to_messages.docs.first.data().from_unread_msg??0;
          to_unread = 0;
          meActiveInPersonalChatScreen = false;
          toActiveInPersonalChatScreen = true;
          update();
        }
        Get.toNamed(AppRoute.PERSONAL_CHAT, parameters: {
          'doc_id': to_messages.docs.first.id,
          'from_uid': userProfile.id ?? '',
          'to_uid': to_userdata.id ?? '',
          'to_name': to_userdata.firstName ?? '',
          'to_imgUrl': to_userdata.imgUrl ?? '',
          'from_token': userProfile.deviceToken??'',
          'to_token': to_userdata.token ?? '',
          'from_name': userProfile.firstName ?? '',
          'from_imgUrl': userProfile.imgUrl ?? '',
          'last_time' : to_messages.docs.first.data().last_time!.toDate().toString(),
          'meActiveInPersonalChatScreen':
              meActiveInPersonalChatScreen.toString(),
          'toActiveInPersonalChatScreen':
              toActiveInPersonalChatScreen.toString(),
              'alreadyStartedConversationToday' : from_messages.docs.first.data().alreadyStartedConversationToday.toString()
        });
      }
    }
  }
}
