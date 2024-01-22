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
  int? unread_msg;
  Timestamp? last_time;

  Msg({
    this.from_uid,
    this.to_uid,
    this.from_name,
    this.to_name,
    this.last_msg,
    this.last_time,
    this.unread_msg,
    this.from_imgUrl,
    this.to_imgUrl,
    
  });

  Msg.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? optionsfinal){
    final data = snapshot.data();
    {
      from_uid = data!['from_uid'];
      to_uid = data['to_uid'];
      from_name = data['from_name'];
      to_name = data['to_name'];
      last_msg = data['last_msg'];
      unread_msg = data['unread_msg'];
      last_time = data['last_time'];
      from_imgUrl = data['from_imgUrl'];
      to_imgUrl = data['to_imgUrl'];
      
    }
  }
  Map<String, dynamic> toFirestore(){
    return {
      'from_uid' : from_uid,
      'to_uid' : to_uid,
      'from_name' : from_name,
      'to_name' : to_name,
      'last_msg' : last_msg,
      'unread_msg' : unread_msg,
      'last_time' : last_time,
      'from_imgUrl' : from_imgUrl,
      'to_imgUrl' : to_imgUrl,
    };
  }
}

class MsgContent{
  String? message;
  String? uid;
  String? type;
  String? imgMessage;
  Timestamp? addtime;

  MsgContent({
    this.message,
  this.addtime,
  this.type,
  this.uid,
  this.imgMessage
  });

  MsgContent.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot, SnapshotOptions? optionsfinal){
    final data = snapshot.data();
    {
      uid = data!['uid'];
      type = data['type'];
      message = data['message'];
      addtime = data['addtime'];
      imgMessage = data['imgMessage'];
    }
  }
  Map<String, dynamic> toFirestore(){
    return {
      'uid' : uid,
      'message' : message,
      'type' : type,
      'addtime' : addtime,
      'imgMessage': imgMessage
    };
  }
}