import 'package:chatapp/logic/cubits/chat/chats_cubit.dart';
import 'package:chatapp/logic/cubits/chat/chats_state.dart';
import 'package:chatapp/presentation/widgets/chat_widget.dart';
import 'package:chatapp/presentation/widgets/custom_drawer.dart';
import 'package:chatapp/presentation/widgets/shimmer_widget.dart';
import 'package:double_tap_to_exit/double_tap_to_exit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/ui.dart';
import '../../widgets/add_button_widget.dart';
import '../chat/show_users.dart';

class ChatNavBar extends StatelessWidget {
  const ChatNavBar({super.key});
  static const String routeName = "navBar";

  @override
  Widget build(BuildContext context) {
    return DoubleTapToExit(
      snackBar: SnackBar(
        content: Text(
          "Tap to exit again",
          style: TextStyles.body3.copyWith(
            color: AppColors.text,
          ),
        ),
        backgroundColor: AppColors.circleColor,
      ),
      child: Scaffold(
        drawer: const CustomDrawer(),
        appBar: AppBar(
          iconTheme: const IconThemeData(color: AppColors.text, size: 28),
          title: Text(
            "Konect",
            style: TextStyles.body1,
          ),
        ),
        body: BlocBuilder<ChatsCubit, ChatsState>(
          builder: (context, state) {
            if (state is ChatsLoadingState) {
              return const ShimmerWidget(
                isExpand: true,
              );
            }
            if (state is ChatsErrorState) {
              return Center(
                child: Text(state.message.toString()),
              );
            }
            if (state is ChatsLoadedState && state.chats.isEmpty ||
                state.chats
                    .where((chat) => chat.lastMessage?.text != "")
                    .isEmpty) {
              return const Center(
                child: Text(
                  "Oops, no chats!!! Tap + to start.",
                  style: TextStyle(color: Colors.white),
                ),
              );
            }
            if (state is ChatsLoadedState && state.chats.isNotEmpty) {
              return ChatWidget(
                chats: state.chats,
              );
            }
            return const SizedBox();
          },
        ),
        floatingActionButton: AddButtonWidget(
          onTap: () => Navigator.pushNamed(
            context,
            ShowUsers.routeName,
          ),
        ),
      ),
    );
  }
}
