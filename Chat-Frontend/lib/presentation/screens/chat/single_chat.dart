import 'package:chatapp/core/app_assets.dart';
import 'package:chatapp/logic/cubits/singleChat/singleChat_cubit.dart';
import 'package:chatapp/logic/cubits/singleChat/singleChat_state.dart';
import 'package:chatapp/logic/services/formatter.dart';
import 'package:chatapp/presentation/screens/home/provider/chat_provider.dart';
import 'package:chatapp/presentation/widgets/gap_widget.dart';
import 'package:chatapp/presentation/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../../core/ui.dart';
import '../../widgets/send_message_widget.dart';

class SingleChat extends StatefulWidget {
  final String? chatRoomId;
  final String? userId;
  final String? userName;
  const SingleChat({
    super.key,
    this.chatRoomId,
    this.userName,
    this.userId,
  });
  static const String routeName = "singleChat";

  @override
  State<SingleChat> createState() => _SingleChatState();
}

class _SingleChatState extends State<SingleChat> {
  final chatCon = TextEditingController();
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SingleChatCubit>(context).connectSocket(
      chatRoomId: widget.chatRoomId,
      userId: widget.userId!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<ChatProvider>(context);
    var callId = Formatter().generateUniqueId();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: AppColors.text, size: 28),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const CircleAvatar(
              radius: 18,
              backgroundImage: AssetImage(
                AppAssets.placeholder,
              ),
            ),
            const GapWidget(
              width: -8,
            ),
            Text(
              widget.userName!,
              style: TextStyles.body2,
            ),
          ],
        ),
        actions: [
          ZegoSendCallInvitationButton(
            iconSize: const Size(40, 40),
            buttonSize: const Size(40, 40),
            isVideoCall: true, // Change to false for audio call
            resourceID:
                "zego_call", // Replace with your actual resourceID from Zego Console
            invitees: [
              ZegoUIKitUser(
                id: widget.userId!, // User ID of the person you want to call
                name: widget.userName!, // Their name
              ),
            ],
            networkLoadingConfig: ZegoNetworkLoadingConfig(
              enabled: true,
              iconColor: Colors.white,
              progressColor: Colors.white,
            ),
            timeoutSeconds: 30, // Call expires in 30 seconds if not answered
          ),
          const GapWidget(
            width: 4,
          ),
          ZegoSendCallInvitationButton(
            iconSize: const Size(40, 40),
            buttonSize: const Size(40, 40),
            isVideoCall: false,
            resourceID: "zego_call",
            invitees: [
              ZegoUIKitUser(
                id: widget.userId!,
                name: widget.userName!,
              ),
            ],
            timeoutSeconds: 30,
            networkLoadingConfig: ZegoNetworkLoadingConfig(
              enabled: true,
              iconColor: Colors.white,
              progressColor: Colors.white,
            ),
          ),
          const GapWidget(
            width: 8,
          ),
        ],
      ),
      body: Column(
        children: [
          BlocBuilder<SingleChatCubit, SingleChatState>(
              builder: (context, state) {
            if (state is SingleChatLoadingState) {
              return const ShimmerWidget();
            }
            if (state is SingleChatErrorState) {
              return Center(
                child: Text(
                  state.message.toString(),
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }
            if (state is SingleChatLoadedState) {
              // context.read<ChatsCubit>().markRead(widget.chatRoomId!);
              return Expanded(
                child: ListView.builder(
                  itemCount: state.singleChat.length,
                  reverse: true,
                  itemBuilder: (context, int index) {
                    final msg = state.singleChat[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: msg.sender == userPro.userId
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                          children: [
                            Flexible(
                              child: Container(
                                padding: const EdgeInsets.all(10),
                                margin: const EdgeInsets.symmetric(
                                  vertical: 2,
                                  horizontal: 14,
                                ),
                                decoration: BoxDecoration(
                                  color: msg.sender == userPro.userId
                                      ? AppColors.drawerColor
                                      : AppColors.circleColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  msg.message!,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 16),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            mainAxisAlignment: msg.sender == userPro.userId
                                ? MainAxisAlignment.end
                                : MainAxisAlignment.start,
                            children: [
                              Text(
                                Formatter.formatDate(msg.createdAt),
                                style: const TextStyle(
                                  fontSize: 10,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(width: 4),
                              msg.sender == userPro.userId
                                  ? Icon(
                                      msg.isRead == true
                                          ? Icons.done_all
                                          : Icons.done,
                                      color: AppColors.text,
                                      size: 14,
                                    )
                                  : const SizedBox(),
                            ],
                          ),
                        )
                      ],
                    );
                  },
                ),
              );
            }
            return const SizedBox();
          }),
          const GapWidget(height: -12),
          SendMessageWidget(
            chatCon: chatCon,
            onSend: () {
              if (chatCon.text.isNotEmpty) {
                BlocProvider.of<SingleChatCubit>(context).sendMessage(
                  chatCon: chatCon,
                  chatRoomId: widget.chatRoomId!,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  void startAudioCall(BuildContext context, String userId, String userName) {
    ZegoUIKitPrebuiltCallInvitationService().send(
      invitees: [
        ZegoCallUser(userId, userName),
      ],
      isVideoCall: false, // Audio Call
      resourceID: "zego_call",
      timeoutSeconds: 30,
    );
  }

  void startVideoCall(BuildContext context, String userId, String userName) {
    ZegoUIKitPrebuiltCallInvitationService().send(
      invitees: [
        ZegoCallUser(userId, userName),
      ],
      isVideoCall: true, // Audio Call
      resourceID: "zego_call",
      timeoutSeconds: 30,
    );
  }
}
