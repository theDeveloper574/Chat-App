import 'package:chatapp/data/repositories/user_repository.dart';
import 'package:chatapp/logic/cubits/users/users_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitialState()) {
    _fetchUser();
  }
  final repo = UserRepository();
  void _fetchUser() async {
    emit(UsersLoadingState());
    try {
      final usersList = await repo.fetchUsers();
      emit(UsersLoadedState(usersList));
    } catch (ex) {
      emit(UsersErrorState(ex.toString(), state.users));
    }
  }
}
