import 'dart:convert';
import 'dart:io';

import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class PersonalChatController extends GetxController {
  static PersonalChatController get instance => Get.find();
  String? doc_id;
  String to_uid = '';
  String to_name = '';
  String to_imgUrl = '';
  XFile? image;
  File? imageFile;
  late String userId;
  final msgScrollController = ScrollController();
  final messasgeController = TextEditingController();
  final imageTextController = TextEditingController();
  final db = FirebaseFirestore.instance;
  var listener;
  List<MsgContent> msgList = [];
  final picker = ImagePicker();
  String? imgUrl;
  bool isUploadingImage = false;
  bool isGettingImgUrl = false;
  String uri =
      'https://fcm.googleapis.com/v1/projects/chateo-a7a4d/messages:send';
      String url = 'https://api.rnfirebase.io/messaging/send';
  String token =
      'fOrmVPokSImSmLQjHfK8J9:APA91bFT1HnBhjv0FHlKGKYc_QwLmgor5iltLSwFKkiZ4JSnMv0Mq_ydwGAWHlm9-Xp1EscYDJ0QrU7XFqNLUofQd9NitXMk6Amp3kfuID4pbnAn8u3Y86VU_BtQuV-TOiZgLlDIMQ94';
  String accessToken =
      'eyJhbGciOiJSUzI1NiIsImtpZCI6IjViNjAyZTBjYTFmNDdhOGViZmQxMTYwNGQ5Y2JmMDZmNGQ0NWY4MmIiLCJ0eXAiOiJKV1QifQ.eyJpc3MiOiJodHRwczovL3NlY3VyZXRva2VuLmdvb2dsZS5jb20vY2hhdGVvLWE3YTRkIiwiYXVkIjoiY2hhdGVvLWE3YTRkIiwiYXV0aF90aW1lIjoxNzA1NjgzMTgxLCJ1c2VyX2lkIjoidm5DREE1dm41SlkwcktpSUFXV0RBdE1DTXp1MiIsInN1YiI6InZuQ0RBNXZuNUpZMHJLaUlBV1dEQXRNQ016dTIiLCJpYXQiOjE3MDU2ODMxODEsImV4cCI6MTcwNTY4Njc4MSwicGhvbmVfbnVtYmVyIjoiKzIzNDgxNjczMjA5MDMiLCJmaXJlYmFzZSI6eyJpZGVudGl0aWVzIjp7InBob25lIjpbIisyMzQ4MTY3MzIwOTAzIl19LCJzaWduX2luX3Byb3ZpZGVyIjoicGhvbmUifX0.WLdgQ0_jB7WcCzkH1RDB-Gd13bXKKomD0MJcDu5GoiY5Sixs0E2XNui9FrtpOkimtylhCRGM9WNr-ChXWPQOjAwAIoi8V60uG16ZeLhTowDt1P4nFli_-Ai1rGDu0bngcNY5I0_2biexQ94yNxsRTdTrP5mSouO88dY4sbrheFbMKvg7irfC2uZ8RUbKYNBBT8hBYiiufAckJLbqilcIF1gYMv_Kt2nOOt_hZbQQC-C7ke66pKMgn7oa0B4BLtkQXPqW98L2kQbPHbr9D_aJtyVjB0deJrUBwGzBkqCrFbyrj0jukTMiuLeI3Df9vf6lNjHPXhSiujxCzo_B7-0vGQ';
 String accessToken1 ='10828753136281589827';
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();

    print('The doc is is  ${Get.parameters['doc_id']}');
    userId = UserStore.instance.getUserID();

    doc_id = Get.parameters['doc_id'] ?? '';
    to_uid = Get.parameters['to_uid'] ?? '';
    to_name = Get.parameters['to_name'] ?? "";
    to_imgUrl = Get.parameters['to_imgUrl'] ?? '';
    update();
    sendNotificationMessage(body: 'Hello my bro', title: 'Usman');
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    retrieveSentMessage();
    sendNotificationMessage(body: 'Hello my bro', title: 'Usman');
  }

  @override
  void dispose() {
    // TODO: implement dispose

    super.dispose();
    listener.dispose();
  }

  sendMessage() async {
    final sendContent = MsgContent(
        message: messasgeController.text.trim(),
        uid: userId,
        type: 'text',
        addtime: Timestamp.now());
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
      await db.collection('message').doc(doc_id).update({
        'last_time': Timestamp.now(),
        'last_msg': sendContent.message,
        // 'unread_msg' : 1
      });
    });
  }

  sendNotificationMessage({required String body, required String title}) async {
    print('sending');
    try {
      await http
          .post(Uri.parse(uri),
              headers: {
                'Content_Type': 'application/json',
                'Authorization': 'Bearer $accessToken1'
              },
              body: jsonEncode({
                "message" :{
                  'token': token,
                'data': {
                  'via': 'FlutterFire Cloud Messaging!!!',
                  //'count': _messageCount.toString(),
                },
                'notification': {
                  'title': 'Hello FlutterFire!',
                  'body': 'This notification was created via FCM!',
                },

                }
              
                
              }))
          .then((value) {
        print(value.statusCode);
       // print(value.)
       
      
      });
    } catch (e) {
      print(e.toString());
    }
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
    final sendContent = MsgContent(
        message: imgUrl,
        uid: userId,
        type: 'imageAndmessage',
        addtime: Timestamp.now(),
        imgMessage: imageTextController.text.trim());
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
      Get.back();
      await db.collection('message').doc(doc_id).update({
        'last_time': Timestamp.now(),
        'last_msg': '[photo]',
        // 'unread_msg' : 1
      });
    });
  }

  pickImage() async {
    final pickedImg = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImg != null) {
      Get.toNamed(AppRoute.PICKED_IMAGE);
      image = XFile(pickedImg.path);
      imageFile = File(image!.path);
      print('image picked with the path ${pickedImg.path}');
      update();
      uploadImage(imageFile);
    }
  }

  uploadImage(File? imageFile) async {
    isUploadingImage = true;
    update();
    if (imageFile != null) {
      var imagePath = imageFile.path;
      final storageRef = FirebaseStorage.instance.ref('chat').child(imagePath);
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

            await getImgUrl(imageFile.path).then((value) {
              isUploadingImage = false;
              update();
            });
        }
      });
    }
  }

  Future<void> getImgUrl(String imgPath) async {
    final spaceRef = FirebaseStorage.instance.ref('chat').child(imgPath);
    imgUrl = await spaceRef.getDownloadURL();
    print('Image url gotten');
    update();
  }
}
