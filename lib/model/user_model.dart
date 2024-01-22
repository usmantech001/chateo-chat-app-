import 'package:cloud_firestore/cloud_firestore.dart';

class UserData{
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? id;
  String? imgUrl;
  bool? isOnline;
  String? token;

  UserData({
    this.id,
    this.firstName,
    this.imgUrl,
    this.lastName,
    this.phoneNumber,
    this.isOnline,
    this.token
  });

  UserData.fromFirestore(
    DocumentSnapshot<Map<String, dynamic>> snapshot,
    SnapshotOptions? options
    ){
      final data = snapshot.data();
    {
      firstName = data!['firstName']??'';
      phoneNumber = data['phoneNumber'];
      lastName = data['lastName'];
      id = data['id'];
      imgUrl = data['imgUrl'];
      isOnline = data['isOnline'];
      token = data['token'];
    }
  }

  Map<String, dynamic> toFirestore() {
    return {
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'id': id,
      'imgUrl': imgUrl,
      'lastName': lastName,
      'isOnline' : isOnline,
      'token' : token
    };
  }
}

class UserProfileData{
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? id;
  String? imgUrl;

  UserProfileData({
    this.id,
    this.firstName,
    this.imgUrl,
    this.lastName,
    this.phoneNumber
  });

  UserProfileData.fromJson(Map<String, dynamic> data,
    ){
    {
      firstName = data!['firstName']??'';
      phoneNumber = data['phoneNumber'];
      lastName = data['lastName'];
      id = data['id'];
      imgUrl = data['imgUrl'];
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'firstName': firstName,
      'id': id,
      'imgUrl': imgUrl,
      'lastName': lastName
    };
  }
}


