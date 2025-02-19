class UsersModel {
  String? sId;
  String? userName;
  String? name;
  String? avatar;
  String? email;
  String? createdAt;
  String? updatedAt;

  UsersModel({
    this.sId,
    this.userName,
    this.name,
    this.avatar,
    this.email,
    this.createdAt,
    this.updatedAt,
  });

  UsersModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    userName = json['userName'];
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
    createdAt = json['createdAt'];
    updatedAt = json['updatedAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['userName'] = this.userName;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    data['createdAt'] = this.createdAt;
    data['updatedAt'] = this.updatedAt;
    return data;
  }
}
