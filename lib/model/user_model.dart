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

  UserData.fromJson(Map<String, dynamic>data){
    {
      firstName = data['firstName']??'';
      phoneNumber = data['phoneNumber'];
      lastName = data['lastName'];
      id = data['id'];
      imgUrl = data['imgUrl'];
      isOnline = data['isOnline'];
      token = data['token'];
    }
  }

  Map<String, dynamic> toJson() {
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
      firstName = data['firstName']??'';
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


