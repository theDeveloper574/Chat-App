import 'package:chatapp/core/api.dart';
import 'package:chatapp/data/models/chats/chats_model.dart';
import 'package:chatapp/logic/cubits/chat/chats_cubit.dart';
import 'package:chatapp/logic/services/formatter.dart';
import 'package:chatapp/presentation/screens/chat/single_chat.dart';
import 'package:chatapp/presentation/screens/home/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/app_assets.dart';
import '../../core/ui.dart';

class ChatWidget extends StatelessWidget {
  final List<ChatsModel> chats;
  const ChatWidget({
    super.key,
    required this.chats,
  });

  // @override
  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<ChatProvider>(context, listen: false);
    final chatItems = chats
        .where((chat) => chat.lastMessage?.text?.isNotEmpty ?? false)
        .length;
    return ListView.separated(
      padding: EdgeInsets.zero,
      // itemCount: chats.length,
      itemCount: chatItems,
      itemBuilder: (context, int index) {
        ChatsModel chat = chats[index];
        chat.users!.removeWhere((e) => e.sId == userPro.userId);
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, SingleChat.routeName, arguments: {
              "userId": chat.users![0].sId!,
              "chatRoomId": chat.sId,
              "userName": chat.users![0].name,
            });
            context.read<ChatsCubit>().markRead(chat.sId!);
          },
          contentPadding: const EdgeInsets.symmetric(
            vertical: 0,
            horizontal: 16,
          ),
          leading: CircleAvatar(
            radius: 28,
            child: CircleAvatar(
              backgroundColor: AppColors.circleColor,
              radius: 27,
              backgroundImage: chat.users![0].avatar == ""
                  ? const AssetImage(
                      AppAssets.placeholder,
                    )
                  : NetworkImage("$ImgBaseUrl${chat.users![0].avatar!}"),
            ),
          ),
          title: Text(
            chat.users![0].name!,
            maxLines: 1,
            style: TextStyles.body3.copyWith(
              overflow: TextOverflow.ellipsis,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            chat.lastMessage!.text!,
            maxLines: 1,
            style: TextStyles.body3.copyWith(
              overflow: TextOverflow.ellipsis,
            ),
          ),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                Formatter.formatDate(chat.lastMessage!.createdAt),
                style: TextStyles.body4.copyWith(
                  overflow: TextOverflow.ellipsis,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                height: 4,
              ),
              chat.unreadCount! > 0
                  ? Container(
                      decoration: BoxDecoration(
                        color: AppColors.circleColor,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Text(
                          chat.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox(),
            ],
          ),
        );
      },
      separatorBuilder: (context, int index) {
        return Divider(
          color: AppColors.text,
          indent: MediaQuery.sizeOf(context).width / 4.5,
        );
      },
    );
  }
}
