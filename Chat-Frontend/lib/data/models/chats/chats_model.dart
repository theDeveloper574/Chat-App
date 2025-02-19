class ChatsModel {
  LastMessage? lastMessage;
  String? sId;
  List<Users>? users;
  String? createdAt;
  int? unreadCount;

  ChatsModel({
    this.lastMessage,
    this.sId,
    this.users,
    this.createdAt,
    required this.unreadCount,
  });

  ChatsModel.fromJson(Map<String, dynamic> json) {
    lastMessage = json['lastMessage'] != null
        ? new LastMessage.fromJson(json['lastMessage'])
        : null;
    sId = json['_id'];
    if (json['users'] != null) {
      users = <Users>[];
      json['users'].forEach((v) {
        users!.add(new Users.fromJson(v));
      });
    }
    createdAt = json['createdAt'];
    unreadCount = json['unreadCount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.lastMessage != null) {
      data['lastMessage'] = this.lastMessage!.toJson();
    }
    data['_id'] = this.sId;
    if (this.users != null) {
      data['users'] = this.users!.map((v) => v.toJson()).toList();
    }
    data['createdAt'] = this.createdAt;
    data['unreadCount'] = this.unreadCount;
    return data;
  }

  ChatsModel copyWith({
    LastMessage? lastMessage,
    String? sId,
    List<Users>? users,
    String? createdAt,
    int? unreadCount,
  }) {
    return ChatsModel(
      lastMessage: lastMessage ?? this.lastMessage,
      sId: sId ?? this.sId,
      users: users ?? this.users,
      createdAt: createdAt ?? this.createdAt,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}

class LastMessage {
  String? text;
  String? sender;
  String? createdAt;

  LastMessage({this.text, this.sender, this.createdAt});

  LastMessage.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    sender = json['sender'];
    createdAt = json['createdAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['text'] = this.text;
    data['sender'] = this.sender;
    data['createdAt'] = this.createdAt;
    return data;
  }
}

class Users {
  String? sId;
  String? name;
  String? avatar;
  String? email;

  Users({this.sId, this.name, this.avatar, this.email});

  Users.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    name = json['name'];
    avatar = json['avatar'];
    email = json['email'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['name'] = this.name;
    data['avatar'] = this.avatar;
    data['email'] = this.email;
    return data;
  }
}
