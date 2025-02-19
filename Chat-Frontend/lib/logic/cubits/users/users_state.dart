import 'package:chatapp/data/models/users_model.dart';

abstract class UsersState {
  List<UsersModel> users;
  UsersState(this.users);
}

class UsersInitialState extends UsersState {
  UsersInitialState() : super([]);
}

class UsersLoadingState extends UsersState {
  UsersLoadingState() : super([]);
}

class UsersLoadedState extends UsersState {
  UsersLoadedState(super.users);
}

class UsersErrorState extends UsersState {
  String message;
  UsersErrorState(this.message, super.users);
}
