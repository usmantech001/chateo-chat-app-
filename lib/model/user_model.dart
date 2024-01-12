// class UserLoginModel{
//   String? name;
//   String? email;
//   String? password;
//   String? id;

//   UserLoginModel({
//     this.email,
//     this.id,
//     this.name,
//     this.password
//   });

//   UserLoginModel.fromJson(Map<String, dynamic> json){
//     {
//       email = json['email'];
//       name = json['name'];
//       password = json['password'];
//       id = json['id'];
//     }
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'name': name,
//       'id': id,
//       'password':password,
//     };
//   }
// }

class UserModel{
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? id;
  String? imgUrl;

  UserModel({
    this.id,
    this.firstName,
    this.imgUrl,
    this.lastName,
    this.phoneNumber
  });

  UserModel.fromJson(Map<String, dynamic> json){
    {
      firstName = json['firstName'];
      phoneNumber = json['phoneNumber'];
      lastName = json['lastName'];
      id = json['id'];
      imgUrl = json['imgUrl'];
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


