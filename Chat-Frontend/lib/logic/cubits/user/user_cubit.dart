import 'dart:io';

import 'package:chatapp/data/models/user_model.dart';
import 'package:chatapp/data/repositories/user_repository.dart';
import 'package:chatapp/logic/cubits/user/user_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zego_uikit_prebuilt_call/zego_uikit_prebuilt_call.dart';

import '../../services/preferences.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()) {
    _loadUserData();
  }
  final repo = UserRepository();
  //register new user
  Future<bool> register({
    String? name,
    File? image,
    required String username,
    required String email,
    required String password,
  }) async {
    emit(UserLoadingState());
    try {
      final response = await repo.register(
        name: name,
        avatar: image,
        username: username,
        email: email,
        password: password,
      );
      emit(UserLoggedState(response));
      return true;
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
      return false;
    }
  }

  //login user
  Future<bool> login({required String user, required String password}) async {
    emit(UserLoadingState());
    try {
      final res = await repo.loginUser(
        user: user,
        password: password,
      );
      emit(UserLoggedState(res));
      return true;
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
      return false;
    }
  }

  void logOut() async {
    final pref = await SharedPreferences.getInstance();
    pref.clear();
    ZegoUIKitPrebuiltCallInvitationService().uninit();
    emit(UserLoggedOutState());
  }

  //update user cubit
  Future<bool> updateUser(CuUserModel user, {XFile? avatar}) async {
    try {
      emit(UserLoadingState());
      final res = await repo.updateUserInfo(user, newAvatar: avatar);
      emit(UserLoggedState(res));
      return true;
    } catch (ex) {
      // Emit UserUpdateErrorState with the current user data and error message
      emit(UserUpdateErrorState(user, ex.toString()));
      return false;
    }
  }

  Future<void> _loadUserData() async {
    try {
      bool isToken = await Preferences.isUserAuthenticated();
      if (isToken) {
        final token = await Preferences.getToken();
        if (token != null) {
          // Decode the token
          Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

          // Create a CuUserModel using the decoded token
          CuUserModel userModel = CuUserModel.fromToken(token);

          // Emit the user state with the decoded data
          emit(UserLoggedState(userModel));
        }
      } else {
        emit(UserErrorState("User session expired"));
      }
    } catch (ex) {
      emit(UserErrorState("User Session expire"));
    }
  }
}
