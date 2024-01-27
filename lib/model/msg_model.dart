// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';

class Msg{
  String? from_uid;
  String? to_uid;
  String? from_name;
  String? to_name;
  String? last_msg;
  String? from_imgUrl;
  String? to_imgUrl;
  String? from_token;
  String? to_token;
  int? from_unread_msg;
  int? to_unread_msg;
  Timestamp? last_time;
  bool? alreadyStartedConversationToday;

  Msg({
    this.from_uid,
    this.to_uid,
    this.from_name,
    this.to_name,
    this.last_msg,
    this.last_time,
    this.from_unread_msg,
    this.to_unread_msg,
    this.from_imgUrl,
    this.to_imgUrl,
    this.from_token,
    this.to_token,
    this.alreadyStartedConversationToday
  });

  Msg.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? optionsfinal){
    final data = snapshot.data();
    {
      from_uid = data!['from_uid'];
      to_uid = data['to_uid'];
      from_name = data['from_name'];
      to_name = data['to_name'];
      last_msg = data['last_msg'];
      from_unread_msg = data['from_unread_msg'];
      to_unread_msg = data['to_unread_msg'];
      last_time = data['last_time'];
      from_imgUrl = data['from_imgUrl'];
      to_imgUrl = data['to_imgUrl'];
      from_token = data['from_token'];
      to_token = data['to_token'];
      alreadyStartedConversationToday = data['alreadyStartedConversationToday'];
      
    }
  }
  Map<String, dynamic> toFirestore(){
    return {
      'from_uid' : from_uid,
      'to_uid' : to_uid,
      'from_name' : from_name,
      'to_name' : to_name,
      'last_msg' : last_msg,
      'from_unread_msg' : from_unread_msg,
      'to_unread_msg' : to_unread_msg,
      'last_time' : last_time,
      'from_imgUrl' : from_imgUrl,
      'to_imgUrl' : to_imgUrl,
      'from_token' : from_token,
      'to_token' : to_token,
      'alreadyStartedConversationToday' : alreadyStartedConversationToday
    };
  }
}

class MsgContent{
  String? message;
  String? uid;
  String? type;
  String? imgMessage;
  Timestamp? addtime;
  bool? isTheFirst;

  MsgContent({
    this.message,
  this.addtime,
  this.type,
  this.uid,
  this.imgMessage,
  this.isTheFirst,
  });

  MsgContent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? optionsfinal){
    final data = snapshot.data();
    {
      uid = data!['uid'];
      type = data['type'];
      message = data['message'];
      addtime = data['addtime'];
      imgMessage = data['imgMessage'];
      isTheFirst = data['isTheFirst'];
    }
  }
  Map<String, dynamic> toFirestore(){
    return {
      'uid' : uid,
      'message' : message,
      'type' : type,
      'addtime' : addtime,
      'imgMessage': imgMessage,
      'isTheFirst' :isTheFirst
    };
  }
}