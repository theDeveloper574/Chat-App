import 'package:jwt_decoder/jwt_decoder.dart';

class CuUserModel {
  String? sId;
  String? userName;
  String? name;
  String? avatar;
  String? email;
  // String? password;
  String? createdAt;
  String? updatedAt;
  String? token;

  CuUserModel({
    this.sId,
    this.userName,
    this.name,
    this.avatar,
    this.email,
    // this.password,
    this.createdAt,
    this.updatedAt,
    this.token,
  });

  CuUserModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
    // password = json['password'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
    token = json['token'];
  }
  // Add this factory constructor to decode the JWT token and return a CuUserModel
  factory CuUserModel.fromToken(String token) {
    final decodedToken = JwtDecoder.decode(token);
    return CuUserModel(
      sId: decodedToken['id'],
      userName: decodedToken['userName'],
      name: decodedToken['name'],
      avatar: decodedToken['avatar'],
      email: decodedToken['email'],
      token: token, // Store the token as well
      // You can add more fields if necessary
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    // data['password'] = this.password;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    data['token'] = this.token;
    return data;
  }
}
