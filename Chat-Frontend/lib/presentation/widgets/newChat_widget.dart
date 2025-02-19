import 'package:chatapp/core/api.dart';
import 'package:chatapp/data/repositories/chats_repository.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/app_assets.dart';
import '../../../data/models/users_model.dart';
import '../screens/chat/single_chat.dart';
import '../screens/home/provider/chat_provider.dart';

class NewChatWidget extends StatelessWidget {
  final List<UsersModel> usersLi;
  const NewChatWidget({super.key, required this.usersLi});

  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<ChatProvider>(context);
    return ListView.builder(
      itemCount: usersLi.length,
      itemBuilder: (context, int index) {
        UsersModel users = usersLi[index];
        return ListTile(
          onTap: () async {
            final chatRoomId = await ChatsRepository().getChatRoom(
              cuUser: userPro.userId!,
              userId: users.sId!,
            );
            if (chatRoomId == 'null') {
              final newChatRoom = await ChatsRepository().createNewChat(
                cuUser: userPro.userId!,
                userId: users.sId!,
              );
              Navigator.pushNamed(context, SingleChat.routeName, arguments: {
                "userId": users.sId,
                "chatRoomId": newChatRoom,
                "userName": users.name,
              });
            } else {
              Navigator.pushNamed(context, SingleChat.routeName, arguments: {
                "userId": users.sId,
                "chatRoomId": chatRoomId,
                "userName": users.name,
              });
            }
          },
          leading: CircleAvatar(
            backgroundImage: users.avatar == ""
                ? const AssetImage(AppAssets.placeholder)
                : NetworkImage("$ImgBaseUrl${users.avatar}"),
          ),
          title: Text(
            users.name!,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          subtitle: Text(
            users.email!,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "username",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Text(
                users.userName!,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
