import 'package:chatapp/core/app_assets.dart';
import 'package:chatapp/core/ui.dart';
import 'package:chatapp/data/models/user_model.dart';
import 'package:chatapp/logic/cubits/user/user_state.dart';
import 'package:chatapp/presentation/screens/splash.dart';
import 'package:chatapp/presentation/widgets/profile_img_widget.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:share_plus/share_plus.dart';

import '../../logic/cubits/user/user_cubit.dart';
import '../screens/auth/update_profile.dart';

class CustomDrawer extends StatelessWidget {
  const CustomDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoggedOutState) {
          Navigator.pushReplacementNamed(context, Splash.routeName);
        }
        if (state is UserUpdateErrorState) {
          toast(message: state.message); // Show toast for update errors
        }
      },
      builder: (context, state) {
        if (state is UserLoadingState) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.white,
            ),
          );
        }
        if (state is UserLoggedState || state is UserUpdateErrorState) {
          final user = (state is UserLoggedState)
              ? state.userModel
              : (state as UserUpdateErrorState).userModel;
          return _buildWid(context, user);
        }
        return const SizedBox(
          child: Text("some text addeed"),
        );
      },
    );
  }

  Widget _buildWid(BuildContext context, CuUserModel userModel) {
    return Theme(
      data: ThemeData(
        dividerColor: Colors.transparent,
        dividerTheme: const DividerThemeData(
          color: Colors.white,
        ),
      ),
      child: Drawer(
        child: Container(
          color: AppColors.drawerColor,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, UpdateProfile.routeName);
                },
                child: SizedBox(
                  height: (kIsWeb)
                      ? MediaQuery.sizeOf(context).height * 0.36
                      : MediaQuery.sizeOf(context).height * 0.3,
                  child: DrawerHeader(
                    decoration: const BoxDecoration(
                      color: Colors.transparent,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        userModel.avatar == ""
                            ? Image.asset(
                                AppAssets.placeholder,
                                height: 90,
                              )
                            : ProfileImgWidget(
                                imgUrl: userModel.avatar!,
                              ),
                        const SizedBox(height: 6),
                        Text(
                          userModel.name ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 2),
                        const Text(
                          "username ↓:",
                          style: TextStyle(color: AppColors.text, fontSize: 14),
                        ),
                        Text(
                          userModel.userName ?? "",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontSize: 16,
                            color: Colors.white70,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Menu Items
              _buildDrawerItem(
                Icons.settings,
                "Profile",
                onTap: () =>
                    Navigator.pushNamed(context, UpdateProfile.routeName),
              ),
              _buildDrawerItem(Icons.group, "Group Chat"),
              _buildDrawerItem(Icons.person_add, "Invite friends", onTap: () {
                Share.share('check out my New Chat App');
              }),
              _buildDrawerItem(Icons.privacy_tip, "Privacy Policy"),
              _buildDrawerItem(
                Icons.logout,
                "Log Out",
                onTap: () => BlocProvider.of<UserCubit>(context).logOut(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Drawer Item Widget
  Widget _buildDrawerItem(
    IconData icon,
    String title, {
    void Function()? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: GoogleFonts.poppins(color: AppColors.text),
      ),
      onTap: onTap,
    );
  }
}
