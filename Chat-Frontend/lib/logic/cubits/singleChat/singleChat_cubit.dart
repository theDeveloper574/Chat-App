import 'dart:developer';

import 'package:chatapp/core/api.dart';
import 'package:chatapp/data/models/chats/singleChat_model.dart';
import 'package:chatapp/logic/cubits/singleChat/singleChat_state.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../../services/preferences.dart';

class SingleChatCubit extends Cubit<SingleChatState> {
  SingleChatCubit() : super(SingleChatInitialState());
  late IO.Socket socket;
  Future<void> connectSocket({
    required String? chatRoomId,
    required String userId,
  }) async {
    try {
      emit(SingleChatLoadingState(state.singleChat));
      final token = await Preferences.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        emit(
          SingleChatErrorState(
            "Session expired. Please log in again.",
            state.singleChat,
          ),
        );
        return;
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      emit(SingleChatLoadedState(List.from(state.singleChat)));
      socket = IO.io(
          serverURL,
          IO.OptionBuilder()
              .enableForceNew() // 🔥 Ensures a fresh socket instance each time
              .setTransports(['websocket', 'polling'])
              .disableAutoConnect()
              .build());

      // ✅ Connect to the socket server
      socket.connect();

      // ✅ Handle successful connection
      socket.onConnect((_) {
        log("✅ Connected to socket server");
        socket.emit('joinRoom',
            {"chatRoomId": chatRoomId, "userId": decodedToken['id']});
      });

      // ✅ Fetch last messages from server
      socket.on('previousMessages', (data) {
        log("📥 Previous Messages Received: $data");
        final messages =
            (data as List).map((e) => SingleChatModel.fromJson(e)).toList();
        emit(SingleChatLoadedState(messages));
      });
      socket.on('receiveMessage', (data) {
        log("📥 New Message Received: $data");
        final newMessage = SingleChatModel.fromJson(data);
        final updatedMessages = List<SingleChatModel>.from(state.singleChat)
          ..insert(0, newMessage);

        emit(SingleChatLoadedState(updatedMessages));
        // ✅ Check read status after 1 second
        Future.delayed(const Duration(seconds: 1), () {
          socket.emit('checkReadStatus', {"chatRoomId": newMessage.chatRoomId});
        });
      });
      // ✅ Listen for read status updates
      // socket.on('messagesRead', (data) {
      //   log("📥 Read Status Updated: $data");
      //
      //   final chatRoomId = data['chatRoomId'];
      //   final userId = data['userId']; // User who read the messages
      //
      //   // ✅ Update messages sent by the current user
      //   final updatedMessages = state.singleChat.map((msg) {
      //     if (msg.chatRoomId == chatRoomId &&
      //         msg.sender == decodedToken['id']) {
      //       return msg.copyWith(
      //           isRead: true, readAt: DateTime.now().toIso8601String());
      //     }
      //     return msg;
      //   }).toList();

      //   emit(SingleChatLoadedState(updatedMessages));
      // });

      // ✅ Handle disconnection
      socket.onDisconnect((_) {
        log("❌ Disconnected from socket");
      });

      // ✅ Handle connection errors
      socket.onError((error) {
        log("⚠️ Socket Error: $error");
        emit(SingleChatErrorState(error.toString(), state.singleChat));
      });
    } catch (ex) {
      log("❌ Exception in connectSocket: $ex");
      emit(SingleChatErrorState(ex.toString(), state.singleChat));
    }
  }

  void sendMessage({
    required TextEditingController chatCon,
    required String chatRoomId,
  }) async {
    try {
      final token = await Preferences.getToken();
      if (token == null || JwtDecoder.isExpired(token)) {
        emit(
          SingleChatErrorState(
            "Session expired. Please log in again.",
            state.singleChat,
          ),
        );
        return;
      }
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
      if (chatCon.text.isEmpty) return;
      final message = SingleChatModel(
        isRead: false,
        readAt: DateTime.now().toIso8601String(),
        message: chatCon.text.trim(),
        createdAt: DateTime.now().toIso8601String(),
        chatRoomId: chatRoomId,
        sender: decodedToken['id'],
      );

      // Emit message event
      socket.emit('sendMessage', message);
      chatCon.clear();
    } catch (ex) {
      emit(SingleChatErrorState(ex.toString(), state.singleChat));
    }
  }

  @override
  Future<void> close() {
    socket.dispose();
    socket.disconnect();
    return super.close();
  }
}
