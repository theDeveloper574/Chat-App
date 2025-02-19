import 'dart:async';

import 'package:chatapp/core/app_assets.dart';
import 'package:chatapp/core/ui.dart';
import 'package:chatapp/logic/cubits/user/user_cubit.dart';
import 'package:chatapp/logic/cubits/user/user_state.dart';
import 'package:chatapp/presentation/screens/auth/login_screen.dart';
import 'package:chatapp/presentation/screens/home/chat_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});
  static const routeName = "splash";

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 100), () => _checkUserState());
  }

  _checkUserState() {
    UserState userState = BlocProvider.of<UserCubit>(context).state;
    if (userState is UserLoggedState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, ChatNavBar.routeName);
    } else if (userState is UserLoggedOutState) {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else if (userState is UserErrorState) {
      toast(message: userState.message.toString());
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, LoginScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserCubit, UserState>(
      listener: (context, state) {
        _checkUserState();
      },
      child: Scaffold(
        body: Container(
          height: MediaQuery.sizeOf(context).height,
          width: MediaQuery.sizeOf(context).width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppAssets.splash),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.only(
                  top: MediaQuery.sizeOf(context).height * 0.22,
                ),
                child: const CircularProgressIndicator(
                  color: AppColors.circleColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
