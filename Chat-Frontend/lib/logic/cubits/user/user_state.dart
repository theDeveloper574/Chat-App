import 'package:chatapp/data/models/user_model.dart';

abstract class UserState {}

class UserInitialState extends UserState {}

class UserLoadingState extends UserState {}

class UserLoggedState extends UserState {
  CuUserModel userModel;
  UserLoggedState(this.userModel);
}

class UserLoggedOutState extends UserState {}

class UserUpdateErrorState extends UserState {
  final CuUserModel userModel;
  final String message;
  UserUpdateErrorState(this.userModel, this.message);
}

class UserErrorState extends UserState {
  String message;
  UserErrorState(this.message);
}
