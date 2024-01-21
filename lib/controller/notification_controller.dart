import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';

class NotificationController extends GetxController{
static NotificationController get instance => Get.find();
  final messaging = FirebaseMessaging.instance;
  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    requestPermission();
    requestDeviceToken();
    init();
  
  }

  requestPermission() async {
    NotificationSettings settings = await messaging.requestPermission();
    if(settings.authorizationStatus== AuthorizationStatus.authorized){
      print('User permission granted');
    } else if( settings.authorizationStatus == AuthorizationStatus.provisional){
      print('User granted provissional permission');
    }else{
      print('User declined or has not accepted permission');
    }

  }

  requestDeviceToken() async{
    await messaging.getToken().then((token){
      print('the device token is $token');
    });
  }

  init(){
    var androidInitialization = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iosInitialization = const DarwinInitializationSettings();
   var initializationSettings = InitializationSettings(android: androidInitialization, iOS:iosInitialization,);
   flutterLocalNotificationsPlugin.initialize(initializationSettings, onDidReceiveNotificationResponse: (details) {
     
   },);

   FirebaseMessaging.onMessage.listen((RemoteMessage message) async{
    print('.............................onMessage...................');
    print('The message title is ${message.notification!.title} and The message body is ${message.notification!.title}');

    

    // BigPictureStyleInformation bigPictureStyleInformation = 
    // BigPictureStyleInformation(
    //   ,
    // htmlFormatContent: true, contentTitle: message.notification!.title, htmlFormatContentTitle: true, 
    // )

    AndroidNotificationDetails androidNotificationDetails =const AndroidNotificationDetails('chateo', 'chateo', importance: Importance.high, playSound: true, priority: Priority.high);
    NotificationDetails notificationDetails = NotificationDetails(android: androidNotificationDetails);
   await flutterLocalNotificationsPlugin.show(0, message.notification!.title, message.notification!.body,notificationDetails ,
   // payload: message.notification!.title
    );

    });
  }

  
}