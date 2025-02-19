import 'package:chatapp/data/models/chats/chats_model.dart';

abstract class ChatsState {
  List<ChatsModel> chats;
  ChatsState(this.chats);
}

class ChatsInitialState extends ChatsState {
  ChatsInitialState() : super([]);
}

class ChatsLoadingState extends ChatsState {
  ChatsLoadingState(super.chats);
}

class ChatsLoadedState extends ChatsState {
  ChatsLoadedState(super.chats);
}

class ChatsErrorState extends ChatsState {
  String message;
  ChatsErrorState(this.message, super.chats);
}
