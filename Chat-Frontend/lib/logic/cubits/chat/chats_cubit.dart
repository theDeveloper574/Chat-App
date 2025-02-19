import 'dart:developer';

import 'package:chatapp/data/models/chats/chats_model.dart';
import 'package:chatapp/logic/cubits/chat/chats_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../../core/api.dart';
import '../../services/preferences.dart';

class ChatsCubit extends Cubit<ChatsState> {
  ChatsCubit() : super(ChatsInitialState()) {
    _loadChats();
  }
  //chats repository
  //try to fetch chats in Cubit using socket
  late IO.Socket socket;
  Future<void> _loadChats() async {
    try {
      emit(ChatsLoadingState(state.chats));
      final token = await Preferences.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        emit(
          ChatsErrorState("Session expired. Please log in again.", state.chats),
        );
        return;
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      socket = IO.io(serverURL, <String, dynamic>{
        'transports': ['websocket', 'polling'],
        'autoConnect': false,
      });

      socket.connect();

      socket.onConnect((_) {
        log("Connected to socket server");
        // ✅ Request the user's chat list when connected
        socket.emit('getUserChatList', decodedToken['id']);
      });

      // ✅ Listen for chat list updates
      socket.on('chatList', (data) {
        final chats =
            (data as List).map((e) => ChatsModel.fromJson(e)).toList();
        chats.sort((a, b) =>
            b.lastMessage!.createdAt!.compareTo(a.lastMessage!.createdAt!));
        emit(ChatsLoadedState(chats));
      });
      // ✅ Listen for real-time chat list updates
      socket.on('chatListUpdated', (_) {
        socket.emit('getUserChatList', decodedToken['id']);
      });

      // ✅ Listen for read messages updates and force UI update
      socket.on('messagesRead', (data) {
        log("✅ Messages read in chat ${data['chatRoomId']}");

        // Re-fetch the chat list
        socket.emit('getUserChatList', decodedToken['id']);
      });

      socket.onDisconnect((_) => log("Disconnected from socket"));
    } catch (ex) {
      emit(ChatsErrorState(ex.toString(), state.chats));
    }
  }

  // ✅ Mark messages as read when chat is opened
  void markRead(String chatRoomId) async {
    try {
      final token = await Preferences.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        emit(
          ChatsErrorState("Session expired. Please log in again.", state.chats),
        );
        return;
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      socket.emit('markMessagesAsRead', {
        "chatRoomId": chatRoomId,
        "userId": decodedToken['id'],
      });
      // ✅ Update UI immediately
      final updatedChats = state.chats.map((chat) {
        if (chat.sId == chatRoomId) {
          return chat.copyWith(unreadCount: 0); // Update unread count
        }
        return chat;
      }).toList();

      emit(ChatsLoadedState(updatedChats));
    } catch (ex) {
      emit(ChatsErrorState("Session is expired", state.chats));
    }
  }

  @override
  Future<void> close() {
    socket.dispose();

    return super.close();
  }
}
