import 'dart:async';
import 'dart:developer';

import 'package:chatapp/data/repositories/user_repository.dart';
import 'package:chatapp/logic/cubits/user/user_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../logic/cubits/user/user_state.dart';
import '../../../../logic/services/formatter.dart';

class LogInProvider extends ChangeNotifier {
  final BuildContext context;
  LogInProvider(this.context) {
    _listToUserChanges();
  }
  final userRepo = UserRepository();
  StreamSubscription? _userCubitStream;
  bool isSignIn = false;
  String error = "";
  void _listToUserChanges() {
    log("listening to user state");
    _userCubitStream =
        BlocProvider.of<UserCubit>(context).stream.listen((state) {
      if (state is UserLoadingState) {
        isSignIn = true;
        error = "";
        notifyListeners();
      } else if (state is UserErrorState) {
        isSignIn = false;
        error = state.message.toString();
        notifyListeners();
      } else {
        isSignIn = false;
        error = "";
      }
    });
  }

  final emailCon = TextEditingController();
  final passCon = TextEditingController();
  final key = GlobalKey<FormState>();
  bool isRemember = false;
  bool isShowPass = true;
  onChanged(bool? val) {
    if (isRemember) {
      isRemember = false;
    } else {
      isRemember = true;
    }
    notifyListeners();
  }

  void onShowPass() {
    if (isShowPass) {
      isShowPass = false;
    } else {
      isShowPass = true;
    }
    notifyListeners();
  }

  void login() async {
    if (!key.currentState!.validate()) return;
    Formatter.hideKeyboard();
    String user = emailCon.text.trim();
    String password = passCon.text.trim();

    BlocProvider.of<UserCubit>(context).login(
      user: user,
      password: password,
    );
  }

  @override
  void dispose() {
    _userCubitStream?.cancel();
    super.dispose();
  }
}
