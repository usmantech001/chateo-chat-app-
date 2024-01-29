// ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'dart:io';
import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class PersonalChatController extends GetxController {
  static PersonalChatController get instance => Get.find();
  String? doc_id;
  String to_uid = '';
  String to_name = '';
  String to_imgUrl = '';
  String from_token = '';
  String to_token = '';
  String from_name = '';
  String from_imgUrl = '';
  String from_uid = '';
  String last_time= UserStore.instance.getLastMsgDate();
  XFile? image;
  File? pickedFile;
  late String userId;
  bool isFieldEmpty = true;
  final msgScrollController = ScrollController();
  final messasgeController = TextEditingController();
  final imageTextController = TextEditingController();
  int fromUnreadMsg = 0;
  int toUnreadMsg = 0;
  bool meActiveInPersonalChatScreen = false;
  bool toActiveInPersonalChatScreen = false;
  final db = FirebaseFirestore.instance;
  var listener;
  List<MsgContent> msgList = [];
  final picker = ImagePicker();
  String? imgUrl;
  String? videoUrl;
  bool isUploadingImage = false;
  bool isUploadingVideo = false;
  bool isGettingImgUrl = false;
  bool alreadyStartedConversationToday = true;

  @override
  void onInit() {
    super.onInit();
    userId = UserStore.instance.getUserID();
    doc_id = Get.parameters['doc_id'] ?? '';
    to_uid = Get.parameters['to_uid'] ?? '';
    to_name = Get.parameters['to_name'] ?? "";
    to_imgUrl = Get.parameters['to_imgUrl'] ?? '';
    to_token = Get.parameters['to_token'] ?? '';
    from_token = Get.parameters['from_token'] ?? '';
    from_name = Get.parameters['from_name'] ?? '';
    from_imgUrl = Get.parameters['from_imgUrl'] ?? '';
    from_uid = Get.parameters['from_uid'] ?? '';
    last_time = Get.parameters['last_time'] ?? '';
    String newfromUnreadMsg = Get.parameters['from_unread_msg'] ?? '0';
    fromUnreadMsg = int.parse(newfromUnreadMsg);
    String newtoUnreadMsg = Get.parameters['to_unread_msg'] ?? '0';
    toUnreadMsg = int.parse(newtoUnreadMsg);
    var me_active_in_chat =
        Get.parameters['meActiveInPersonalChatScreen'] ?? 'false';
    String to_active_in_chat =
        Get.parameters['toActiveInPersonalChatScreen'] ?? 'false';
    String conversationStarted =
        Get.parameters['alreadyStartedConversationToday'] ?? 'false';
    alreadyStartedConversationToday =
        conversationStarted == 'true' ? true : false;
    update();

    if (meActiveInPersonalChatScreen != true) {
      meActiveInPersonalChatScreen = me_active_in_chat == 'true' ? true : false;
      update();
    }
    if (toActiveInPersonalChatScreen != true) {
      toActiveInPersonalChatScreen = to_active_in_chat == 'true' ? true : false;
      update();
    }
    updateUnreadMessages();
  }

  @override
  void onReady() {
    super.onReady();
    retrieveSentMessage();
    print('onReady called');
  }

  @override
  void dispose() {
    super.dispose();
    listener.dispose();
  }

  updateUnreadMessages() async {
    await db.collection('message').doc(doc_id).update(
        {'from_unread_msg': fromUnreadMsg, 'to_unread_msg': toUnreadMsg});
  }

  checkIfTextFieldIsEmpty(String value){
    if(value.isEmpty){
      isFieldEmpty=true;
      update();
    }else{
      isFieldEmpty=false;
      update();
    }
  }

  sendMessage() async {
     var dateTimeNow = DateTime.now();
      var currentDate = DateFormat('yMd').format(dateTimeNow);

      var lastMsgDate = DateFormat('yMd').format(DateTime.parse(last_time));
      if(currentDate!=lastMsgDate){
        alreadyStartedConversationToday=false;
        update();
        await db.collection('message').doc(doc_id).update({
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
      }else if(currentDate == lastMsgDate && msgList.isEmpty){
        alreadyStartedConversationToday=false;
        update();
        await db.collection('message').doc(doc_id).update({
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
      }
    if (userId == from_uid) {
      if (toActiveInPersonalChatScreen == true) {
        final sendContent = MsgContent(
            message: messasgeController.text.trim(),
            uid: userId,
            type: 'text',
            addtime: Timestamp.now(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        messasgeController.clear();

        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
          sendNotificationMsg(
              title: from_name, body: sendContent.message!, image: from_imgUrl, token: to_token);
          update();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&
              alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': sendContent.message,
            'to_unread_msg': 0,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
        print('The toreadmsg1 is $toUnreadMsg');
      } else {
        toUnreadMsg++;
        update();
        final sendContent = MsgContent(
            message: messasgeController.text.trim(),
            uid: userId,
            type: 'text',
            addtime: Timestamp.now(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        messasgeController.clear();

        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
          sendNotificationMsg(
              title: from_name, body: sendContent.message!, image: from_imgUrl, token: to_token);
          update();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': sendContent.message,
            'to_unread_msg': toUnreadMsg,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
        print('The toreadmsg is $toUnreadMsg');
      }
    }

    if (userId != from_uid) {
      if (meActiveInPersonalChatScreen == true) {
        final sendContent = MsgContent(
            message: messasgeController.text.trim(),
            uid: userId,
            type: 'text',
            addtime: Timestamp.now(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        messasgeController.clear();

        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
          sendNotificationMsg(
              title: to_name, body: sendContent.message!, image: to_imgUrl, token: from_token);
          // unreadMsg++;
          update();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': sendContent.message,
            'from_unread_msg': 0,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
        print('The fromUnreadMsg is $fromUnreadMsg');
      } else {
        fromUnreadMsg++;
        update();
        final sendContent = MsgContent(
            message: messasgeController.text.trim(),
            uid: userId,
            type: 'text',
            addtime: Timestamp.now(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        messasgeController.clear();

        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
          sendNotificationMsg(
              title: to_name, body: sendContent.message!, image: to_imgUrl, token: from_token);
          update();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': sendContent.message,
            'from_unread_msg': fromUnreadMsg,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
        if (kDebugMode) {
          print('The fromUnreadMsg is $fromUnreadMsg');
        }
      }
    }
  }

  sendNotificationMsg({
    required String title,
    required String body,
    String? image,
    required String token,
  }) async {
    final serviceAccountFileContent = <String, String>{
      "type": "service_account",
      "project_id": "chateo-a7a4d",
      "private_key_id": "bdca5d2cb5a6b5d8c0576acfbfc1657cc1e0e40d",
      "private_key":
          "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXyA+MHEoAvhh5\njQa4MtiDkdcKe1c77z7798dDx8A0s+282UhbtJEXOvuy2ZgR1ojl/uYo1sKyTlBg\nY6yvTe0DFj3Na8tRX9Eu+EltYH5uaxFimnG3zpTEZwhK1d2dmTW/ZFaMN2h0cNM/\n7eIWEITBX0g6pgfKMyPnxySG4Kdc+lB1L9xUovduBWTbYidSphZa4IigLN+a2Upu\n8qIBVcQktxpOf6jfRHP3X6aXpTHCXzZvDWjuTuu60cE6h4RLHt3aK6XcZADsOqpj\n1yzFfBWJh3lpix8PfsfnXtOQWiuxqR5sd9fDl9mJc1H8yAYbNqcs7AbDCO7QytQ+\nQphi8m7zAgMBAAECggEAA5Z7O5oi66/n/zOPYET0wO4ZHF/Rrj0tCs1kHJzjqmXt\nwuQ1+tOisbRiD8ESAFXxvXy62btIiz4hAJj1PjLu3SmmQ1f+zIkhy4+bQ2Z1BqIp\nnTWTu5RlXYZ799zkqggy8OJrzfu0peVRhmDWp86IfNOw7uX5fX+bo9ZywsIbuAMP\nbFW0Qy9zvPSw/PpVJ4UfEcJ2k5hIQ27Dj35aRvd3mcs7+HASbamZhCJIHU9sE5+4\nyatdn/1Xg/aI2t7RKbHuNc+RYfBcO3/c5Wtrei7MIjaZbgudBCF7coUAsqthOWuV\neGtKK7/k+2KwgU3NuEsbBY1R+Uu/gwVdn3Pc9R8HTQKBgQDMGuaICi2aBYoaP0E5\nUPj6M4NnXz8c0DBhQhhhljx1trFY3E889kuVkwyB1v/QIbPDiDCk1j+eDqy8sevl\nM1YokAuuhwd5pj9X+FpCw6NIszPhweDKaj68vM3lLWe2jzSIyhWwuMTPSspfEJa4\nLd/DmHHIMX3G/U0sZOxPxU+idQKBgQC+X3F4DufJI45xMgM3yZxgnVHIQcAz7MeJ\nz5VMLlQ8BC3zS63JLrsJICMuEu89Q9UbQSx6Y4eMsUlgEgMzQ+PvXNW1lx5Pm3ST\n5RZdqlQ+qk3QAkU3BoAJn6dzr/fmnKJulGeCHbwWSg+5nAXW9WIE0wX1iUyq72kr\nHXo9i+3OxwKBgQCADLBs0NXjN255IQ4ug1pwvjjGdb8GuKZhnjHlp3eu8js5YJ5l\nxK+O236RRu2fCkXZemvqPnATHWnJyGYSma6ILDbn+9b4vxAmhK08Dbk3NxZpoFUD\nKLzLdDhIe8ABjL6MwxvwjzsKQgXMtn+YdU9ZSx63VjVuziPIoliPg15+sQKBgFZz\n/ZGqIzTCwvNA5Rk2o590kilBQsnR46P/8ysPdw1yUHPGkHtmj2XLhG5uBttprKOd\n61cBUBNih5HrXCyxzhdrr1mx8P/x9vUa+hc7PNrgeEnYXhppB0hXirIM3aWKyHEz\nT/ZVDo+Ivq9p3XULJqJOOsyQt5KA+t+rmVHN9AcNAoGBAMoKQVwfuVYh/guFWqqX\nMNC97ZP5bHmI3BjhJkbE9ylkWYOcGakEJG8RAidpkuyodi9m50GQr9xEcFo/qeU6\n+OMgSiYeh18WW7iqTzfi9YdRGJay0hur+DGkj/PmOVB8qpPrMZ6Ydr4Aebwhl6jR\nEgsmLXb8NsEk1tRCKjU6LEAP\n-----END PRIVATE KEY-----\n",
      "client_email":
          "firebase-adminsdk-n4pgq@chateo-a7a4d.iam.gserviceaccount.com",
      "client_id": "108287531362815898279",
      "auth_uri": "https://accounts.google.com/o/oauth2/auth",
      "token_uri": "https://oauth2.googleapis.com/token",
      "auth_provider_x509_cert_url":
          "https://www.googleapis.com/oauth2/v1/certs",
      "client_x509_cert_url":
          "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-n4pgq%40chateo-a7a4d.iam.gserviceaccount.com",
      // "universe_domain": "googleapis.com"
    };
    var server = FirebaseCloudMessagingServer(
      serviceAccountFileContent,
    );
    // ignore: unused_local_variable
    var result = await server.send(
      FirebaseSend(
        validateOnly: false,
        message: FirebaseMessage(
            notification: FirebaseNotification(
              title: title,
              body: body,
            ),
            android: FirebaseAndroidConfig(
              ttl: '3s',

              /// Add Delay in String. If you want to add 1 minute delat then add it like "60s"
              notification: FirebaseAndroidNotification(
                icon: 'ic_notification',
                color: '#009999',
                image: image,
              ),
            ),
            token: token
            //     token, // only required If you want to send message to specific user.
            ),
      ),
    );
  }

  retrieveSentMessage() async {
    var messages = db
        .collection('message')
        .doc(doc_id)
        .collection('msglist')
        .withConverter(
            fromFirestore: MsgContent.fromFirestore,
            toFirestore: (MsgContent msgcontent, options) =>
                msgcontent.toFirestore())
        .orderBy('addtime', descending: false);
    msgList.clear();
    listener = messages.snapshots().listen((event) {
      for (var change in event.docChanges) {
        switch (change.type) {
          case DocumentChangeType.added:
            if (change.doc.data() != null) {
              msgList.insert(0, change.doc.data()!);
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

  sendImageMessage() async {
      var dateTimeNow = DateTime.now();
      var currentDate = DateFormat('yMd').format(dateTimeNow);

      var lastMsgDate = DateFormat('yMd').format(DateTime.parse(last_time));
      if(currentDate!=lastMsgDate){
        alreadyStartedConversationToday=false;
        update();
        await db.collection('message').doc(doc_id).update({
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
      }else if(currentDate == lastMsgDate && msgList.isEmpty){
        alreadyStartedConversationToday=false;
        update();
        await db.collection('message').doc(doc_id).update({
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
      }
    if (userId == from_uid) {
      if (toActiveInPersonalChatScreen == true) {
        final sendContent = MsgContent(
            message: imgUrl,
            uid: userId,
            type: 'imageAndmessage',
            addtime: Timestamp.now(),
            imgMessage: imageTextController.text.trim(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        imageTextController.clear();
        Get.focusScope?.unfocus();
        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
          sendNotificationMsg(
              title: from_name,
              body: sendContent.imgMessage ?? '[image]',
              image: from_imgUrl,
              token: to_token);
          Get.back();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&
              alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': '[photo]',
            'to_unread_msg': 0,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
      } else {
        toUnreadMsg++;
        update();
        final sendContent = MsgContent(
            message: imgUrl,
            uid: userId,
            type: 'imageAndmessage',
            addtime: Timestamp.now(),
            imgMessage: imageTextController.text.trim(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        imageTextController.clear();
        Get.focusScope?.unfocus();
        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
              sendNotificationMsg(
              title: from_name,
              body: sendContent.imgMessage ?? '[image]',
              image: from_imgUrl,
              token: to_token);
          Get.back();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&
              alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': '[photo]',
            'to_unread_msg': toUnreadMsg,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
      }
    }

    if (userId != from_uid) {
      if (meActiveInPersonalChatScreen == true) {
        final sendContent = MsgContent(
            message: imgUrl,
            uid: userId,
            type: 'imageAndmessage',
            addtime: Timestamp.now(),
            imgMessage: imageTextController.text.trim(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        imageTextController.clear();
        Get.focusScope?.unfocus();
        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
              sendNotificationMsg(
              title: to_name,
              body: sendContent.imgMessage ?? '[image]',
              image: to_imgUrl,
              token: from_token);
          Get.back();
          update();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&
              alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': '[photo]',
            'from_unread_msg': 0,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
      } else {
        fromUnreadMsg++;
        update();
        final sendContent = MsgContent(
            message: imgUrl,
            uid: userId,
            type: 'imageAndmessage',
            addtime: Timestamp.now(),
            imgMessage: imageTextController.text.trim(),
            isTheFirst: alreadyStartedConversationToday == true ? false : true);
        imageTextController.clear();
        Get.focusScope?.unfocus();
        await db
            .collection('message')
            .doc(doc_id)
            .collection('msglist')
            .withConverter(
                fromFirestore: MsgContent.fromFirestore,
                toFirestore: (MsgContent msgcontent, options) =>
                    msgcontent.toFirestore())
            .add(sendContent)
            .then((value) async {
              UserStore.instance.saveLastMsgTime(sendContent.addtime!.toDate().toString());
              sendNotificationMsg(
              title: to_name,
              body: sendContent.imgMessage ?? '[image]',
              image: to_imgUrl,
              token: from_token);
              update();
          Get.back();
          var now = DateTime.now();
          var messageDateTime = sendContent.addtime!.toDate();
          var todaysDate = DateFormat('yMd').format(now);
          var messageDate = DateFormat('yMd').format(messageDateTime);
          if (todaysDate == messageDate &&alreadyStartedConversationToday == false) {
            alreadyStartedConversationToday = true;
            update();
          }
          await db.collection('message').doc(doc_id).update({
            'last_time': Timestamp.now(),
            'last_msg': '[photo]',
            'from_unread_msg': fromUnreadMsg,
            'alreadyStartedConversationToday': alreadyStartedConversationToday
          });
        });
      }
    }
  }

  pickImage() async {
    final pickedImg = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      Get.toNamed(AppRoute.PICKED_IMAGE);
      image = XFile(pickedImg.path);
      pickedFile = File(image!.path);
      update();
      if (pickedImg.path.endsWith('.jpg') ||
          pickedImg.path.endsWith('.jpeg') ||
          pickedImg.path.endsWith('.png') ||
          pickedImg.path.endsWith('.gif')) {
        uploadImage(pickedFile);
      } else {
        uploadVideo(pickedFile);
      }
      print('image picked with the path ${pickedImg.path}');
      update();
    }
  }

  pickVideo() async {
    final pickedVideo = await picker.pickVideo(source: ImageSource.gallery);
    if (pickedFile != null) {}
  }

  uploadImage(File? imageFile) async {
    isUploadingImage = true;
    update();
    if (imageFile != null) {
      var imagePath = imageFile.path;
      final storageRef =
          FirebaseStorage.instance.ref('chat').child('uploaded/images');
      storageRef.putFile(imageFile).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;

          case TaskState.paused:
            break;

          case TaskState.canceled:
            break;

          case TaskState.error:
            isUploadingImage = true;
            update();
            break;

          case TaskState.success:
            print('uploaded');

            await getImgUrl(imagePath).then((value) {
              isUploadingImage = false;
              update();
            });
        }
      });
    }
  }

  uploadVideo(File? videoFile) async {
    isUploadingVideo = true;
    update();
    if (videoFile != null) {
      var videoPath = videoFile.path;
      final storageRef =
          FirebaseStorage.instance.ref('chat').child('uploaded/videos');
      storageRef.putFile(videoFile).snapshotEvents.listen((event) async {
        switch (event.state) {
          case TaskState.running:
            break;

          case TaskState.paused:
            break;

          case TaskState.canceled:
            break;

          case TaskState.error:
            isUploadingVideo = true;
            update();
            break;

          case TaskState.success:
            print('video uploaded successfully');

            await getVideoUrl(videoPath).then((value) {
              isUploadingVideo = false;
              update();
            });
        }
      });
    }
  }

  Future<void> getVideoUrl(String videoPath) async {
    final spaceRef =
        FirebaseStorage.instance.ref('chat').child('uploaded/videos');
    videoUrl = await spaceRef.getDownloadURL();
    update();
  }

  Future<void> getImgUrl(String imgPath) async {
    final spaceRef =
        FirebaseStorage.instance.ref('chat').child('uploaded/images');
    imgUrl = await spaceRef.getDownloadURL();
    update();
  }

  leavePersonalChat() {
    if (userId == from_uid) {
      meActiveInPersonalChatScreen = false;
      UserStore.instance.removeLastMsgDate();
      last_time = '';
      update();
    } else {
      toActiveInPersonalChatScreen = false;
       UserStore.instance.removeLastMsgDate();
      last_time = '';
      update();
    }
  }
}
