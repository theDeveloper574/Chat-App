import 'dart:convert';
import 'dart:developer';

import 'package:chatapp/core/api.dart';
import 'package:chatapp/data/models/chats/chats_model.dart';

class ChatsRepository {
  final _api = Api();
  //fetch users chat
  Future<List<ChatsModel>> fetchChats({required String userId}) async {
    try {
      final response =
          await _api.sendRequest.get("$BASE_URL/chat/getUserChatList/$userId");
      ApiResponse apiResponse = ApiResponse.fromResponse(response);
      if (!apiResponse.success) {
        throw apiResponse.message.toString();
      }
      return (apiResponse.data as List<dynamic>)
          .map((e) => ChatsModel.fromJson(e))
          .toList();
    } catch (ex) {
      rethrow;
    }
  }

  //check chatRoom
  Future<String?> getChatRoom({
    required String cuUser,
    required String userId,
  }) async {
    try {
      final chatRoom = await _api.sendRequest.post(
        "$BASE_URL/chat/checkChatRoom",
        data: jsonEncode(
          {
            "user1": cuUser,
            "user2": userId,
          },
        ),
      );
      ApiResponse apiResponse = ApiResponse.fromResponse(chatRoom);
      if (!apiResponse.success) {
        return apiResponse.message.toString();
      }
      return apiResponse.data.toString();
    } catch (ex) {
      rethrow;
    }
  }

  //crate new Chat Room
  Future<String?> createNewChat({
    required String cuUser,
    required String userId,
  }) async {
    try {
      final newChatRes =
          await _api.sendRequest.post("$BASE_URL/chat/createChatRoom",
              data: jsonEncode(
                {
                  "user1": cuUser,
                  "user2": userId,
                },
              ));
      ApiResponse apiResponse = ApiResponse.fromResponse(newChatRes);

      if (!apiResponse.success) {
        log("❌ Chat room creation failed: ${apiResponse.message}");
        return null; // ✅ Return null instead of message
      }

      // ✅ Ensure data is a valid ID
      final chatRoomId = apiResponse.data?.toString();
      if (chatRoomId == null || chatRoomId.isEmpty) {
        log("❌ Invalid chat room ID received!");
        return null;
      }

      log("✅ New chat room created: $chatRoomId");
      return chatRoomId;
    } catch (ex) {
      rethrow;
    }
  }
}
