import 'dart:convert';
import 'dart:io';

import 'package:chateo/controller/userstore_controller.dart';
import 'package:chateo/model/msg_model.dart';
import 'package:chateo/route/app_pages.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_cloud_messaging_flutter/firebase_cloud_messaging_flutter.dart';
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
  String to_token = '';
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
    to_token = Get.parameters['to_token'] ?? '';
    update();
  }

  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
    retrieveSentMessage();
    
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
          sendNotMsg(title: to_name, body: sendContent.message!);
      await db.collection('message').doc(doc_id).update({
        'last_time': Timestamp.now(),
        'last_msg': sendContent.message,
        // 'unread_msg' : 1
      });
    });
    
  }

 
  
  sendNotMsg({
    required String title,
    required String body,
  }) async {
    final serviceAccountFileContent = <String, String>{
    "type": "service_account",
  "project_id": "chateo-a7a4d",
  "private_key_id": "bdca5d2cb5a6b5d8c0576acfbfc1657cc1e0e40d",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQCXyA+MHEoAvhh5\njQa4MtiDkdcKe1c77z7798dDx8A0s+282UhbtJEXOvuy2ZgR1ojl/uYo1sKyTlBg\nY6yvTe0DFj3Na8tRX9Eu+EltYH5uaxFimnG3zpTEZwhK1d2dmTW/ZFaMN2h0cNM/\n7eIWEITBX0g6pgfKMyPnxySG4Kdc+lB1L9xUovduBWTbYidSphZa4IigLN+a2Upu\n8qIBVcQktxpOf6jfRHP3X6aXpTHCXzZvDWjuTuu60cE6h4RLHt3aK6XcZADsOqpj\n1yzFfBWJh3lpix8PfsfnXtOQWiuxqR5sd9fDl9mJc1H8yAYbNqcs7AbDCO7QytQ+\nQphi8m7zAgMBAAECggEAA5Z7O5oi66/n/zOPYET0wO4ZHF/Rrj0tCs1kHJzjqmXt\nwuQ1+tOisbRiD8ESAFXxvXy62btIiz4hAJj1PjLu3SmmQ1f+zIkhy4+bQ2Z1BqIp\nnTWTu5RlXYZ799zkqggy8OJrzfu0peVRhmDWp86IfNOw7uX5fX+bo9ZywsIbuAMP\nbFW0Qy9zvPSw/PpVJ4UfEcJ2k5hIQ27Dj35aRvd3mcs7+HASbamZhCJIHU9sE5+4\nyatdn/1Xg/aI2t7RKbHuNc+RYfBcO3/c5Wtrei7MIjaZbgudBCF7coUAsqthOWuV\neGtKK7/k+2KwgU3NuEsbBY1R+Uu/gwVdn3Pc9R8HTQKBgQDMGuaICi2aBYoaP0E5\nUPj6M4NnXz8c0DBhQhhhljx1trFY3E889kuVkwyB1v/QIbPDiDCk1j+eDqy8sevl\nM1YokAuuhwd5pj9X+FpCw6NIszPhweDKaj68vM3lLWe2jzSIyhWwuMTPSspfEJa4\nLd/DmHHIMX3G/U0sZOxPxU+idQKBgQC+X3F4DufJI45xMgM3yZxgnVHIQcAz7MeJ\nz5VMLlQ8BC3zS63JLrsJICMuEu89Q9UbQSx6Y4eMsUlgEgMzQ+PvXNW1lx5Pm3ST\n5RZdqlQ+qk3QAkU3BoAJn6dzr/fmnKJulGeCHbwWSg+5nAXW9WIE0wX1iUyq72kr\nHXo9i+3OxwKBgQCADLBs0NXjN255IQ4ug1pwvjjGdb8GuKZhnjHlp3eu8js5YJ5l\nxK+O236RRu2fCkXZemvqPnATHWnJyGYSma6ILDbn+9b4vxAmhK08Dbk3NxZpoFUD\nKLzLdDhIe8ABjL6MwxvwjzsKQgXMtn+YdU9ZSx63VjVuziPIoliPg15+sQKBgFZz\n/ZGqIzTCwvNA5Rk2o590kilBQsnR46P/8ysPdw1yUHPGkHtmj2XLhG5uBttprKOd\n61cBUBNih5HrXCyxzhdrr1mx8P/x9vUa+hc7PNrgeEnYXhppB0hXirIM3aWKyHEz\nT/ZVDo+Ivq9p3XULJqJOOsyQt5KA+t+rmVHN9AcNAoGBAMoKQVwfuVYh/guFWqqX\nMNC97ZP5bHmI3BjhJkbE9ylkWYOcGakEJG8RAidpkuyodi9m50GQr9xEcFo/qeU6\n+OMgSiYeh18WW7iqTzfi9YdRGJay0hur+DGkj/PmOVB8qpPrMZ6Ydr4Aebwhl6jR\nEgsmLXb8NsEk1tRCKjU6LEAP\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-n4pgq@chateo-a7a4d.iam.gserviceaccount.com",
  "client_id": "108287531362815898279",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-n4pgq%40chateo-a7a4d.iam.gserviceaccount.com",
 // "universe_domain": "googleapis.com"
  };
  var server = FirebaseCloudMessagingServer(
    serviceAccountFileContent,
  );
  var result = await server.send(
    FirebaseSend(
      validateOnly: false,
      message: FirebaseMessage(
        notification: FirebaseNotification(
          title: title,
          body: body,
        ),
        android: const FirebaseAndroidConfig(
          ttl: '3s',

          /// Add Delay in String. If you want to add 1 minute delat then add it like "60s"
          notification: FirebaseAndroidNotification(
            icon: 'ic_notification',
            color: '#009999',
          ),
        ),
         token:to_token
        //     token, // only required If you want to send message to specific user.
      ),
    ),
  );
  print(result.successful);
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
