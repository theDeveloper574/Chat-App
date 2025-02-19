class SingleChatModel {
  String? sId;
  String? chatRoomId;
  String? sender;
  String? message;
  String? createdAt;
  bool? isRead;
  String? readAt;

  SingleChatModel({
    this.sId,
    this.chatRoomId,
    this.sender,
    this.message,
    this.isRead,
    this.readAt,
    this.createdAt,
  });

  SingleChatModel.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    chatRoomId = json['chatRoomId'];
    sender = json['sender'];
    message = json['message'];
    createdAt = json['createdAt'];
    isRead = json['isRead'];
    readAt = json['readAt'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.sId;
    data['chatRoomId'] = this.chatRoomId;
    data['isRead'] = this.isRead;
    data['readAt'] = this.readAt;
    data['sender'] = this.sender;
    data['message'] = this.message;
    data['createdAt'] = this.createdAt;
    return data;
  }

  // ✅ Add copyWith method
  SingleChatModel copyWith({
    String? sId,
    String? chatRoomId,
    String? sender,
    String? message,
    String? createdAt,
    bool? isRead,
    String? readAt,
  }) {
    return SingleChatModel(
      sId: sId ?? this.sId,
      chatRoomId: chatRoomId ?? this.chatRoomId,
      sender: sender ?? this.sender,
      message: message ?? this.message,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      readAt: readAt ?? this.readAt,
    );
  }
}
