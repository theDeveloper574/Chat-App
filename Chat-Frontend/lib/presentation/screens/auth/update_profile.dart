import 'package:chatapp/data/models/user_model.dart';
import 'package:chatapp/presentation/screens/auth/provider/create_account_provider.dart';
import 'package:chatapp/presentation/widgets/textField_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../../../core/ui.dart';
import '../../../logic/cubits/user/user_cubit.dart';
import '../../../logic/cubits/user/user_state.dart';
import '../../widgets/ButtonWidget.dart';
import '../../widgets/dialog/imagePick_dialog.dart';
import '../../widgets/gap_widget.dart';
import '../../widgets/image_pick_widget.dart';
import '../../widgets/profile_img_widget.dart';
import '../splash.dart';

class UpdateProfile extends StatelessWidget {
  UpdateProfile({super.key});
  static const String routeName = "updateProfile";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Update Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: BlocListener<UserCubit, UserState>(
        listener: (context, state) {
          if (state is UserLoggedOutState) {
            Navigator.pushReplacementNamed(context, Splash.routeName);
          }
          if (state is UserUpdateErrorState) {
            toast(message: state.message);
          }
        },
        child: BlocBuilder<UserCubit, UserState>(
          builder: (context, state) {
            if (state is UserLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            // Handle both UserLoggedState and UserUpdateErrorState
            if (state is UserLoggedState || state is UserUpdateErrorState) {
              // Extract user data from both states
              final user = (state is UserLoggedState)
                  ? state.userModel
                  : (state as UserUpdateErrorState).userModel;

              return updateUser(context, user);
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  late String name;
  late String username;
  late String avatar;
  Widget updateUser(context, CuUserModel user) {
    name = user.name!;
    username = user.userName!;
    avatar = user.avatar!;
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: ListView(
        children: [
          Provider.of<CreateAccProvider>(context).image != null
              ? const ImagePickWidget()
              : ProfileImgWidget(
                  imgUrl: user.avatar!,
                  onTap: () => showImageSourceDialog(
                    context: context,
                    onPickImage: (ImageSource image) {
                      Provider.of<CreateAccProvider>(context, listen: false)
                          .pickImage(imageSource: image);
                    },
                  ),
                ),
          const GapWidget(),
          TextFieldWidget(
            hintText: "Name",
            initialVa: user.name!,
            onChanged: (val) {
              user.name = val;
            },
          ),
          const GapWidget(),
          TextFieldWidget(
            hintText: "Username",
            initialVa: user.userName!,
            onChanged: (val) {
              user.userName = val;
            },
          ),
          const GapWidget(),
          ButtonWidget(
            width: 40,
            text: "Update",
            onPressed: () async {
              final img = Provider.of<CreateAccProvider>(
                context,
                listen: false,
              );
              if (img.image != null) {
                user.avatar = img.image?.path;
              }
              if (name == user.name &&
                  username == user.userName! &&
                  avatar == user.avatar) {
                Navigator.pop(context);
                return;
              }
              bool isUpdated =
                  await BlocProvider.of<UserCubit>(context).updateUser(
                user,
                avatar: img.image,
              );
              if (isUpdated) {
                toast(message: "User Update");
                Navigator.pop(context);
              }
            },
          )
        ],
      ),
    );
  }
}
