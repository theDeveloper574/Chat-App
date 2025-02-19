import 'package:chatapp/logic/cubits/users/users_cubit.dart';
import 'package:chatapp/logic/cubits/users/users_state.dart';
import 'package:chatapp/presentation/screens/home/provider/chat_provider.dart';
import 'package:chatapp/presentation/widgets/shimmer_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../widgets/newChat_widget.dart';

class ShowUsers extends StatelessWidget {
  const ShowUsers({super.key});
  static const routeName = "showUsers";
  @override
  Widget build(BuildContext context) {
    final userPro = Provider.of<ChatProvider>(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: AppColors.text, size: 28),
        title: Text(
          "Konect Users",
          style: TextStyles.body1,
        ),
      ),
      body: BlocBuilder<UsersCubit, UsersState>(
        builder: (context, state) {
          state.users.removeWhere((e) => e.sId == userPro.userId);
          if (state is UsersLoadingState) {
            return const ShimmerWidget(
              isExpand: true,
            );
          }
          if (state is UsersErrorState) {
            return Center(
              child: Text(
                state.message.toString(),
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          }
          if (state is UsersLoadedState && state.users.isEmpty) {
            return const Center(
              child: Text("NO Users exits till!!!"),
            );
          }
          if (state is UsersLoadedState && state.users.isNotEmpty) {
            return NewChatWidget(
              usersLi: state.users,
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
