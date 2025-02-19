import '../../../data/models/chats/singleChat_model.dart';

abstract class SingleChatState {
  List<SingleChatModel> singleChat;
  SingleChatState(this.singleChat);
}

class SingleChatInitialState extends SingleChatState {
  SingleChatInitialState() : super([]);
}

class SingleChatLoadingState extends SingleChatState {
  SingleChatLoadingState(super.singleChat);
}

class SingleChatLoadedState extends SingleChatState {
  SingleChatLoadedState(super.singleChat);
}

class SingleChatErrorState extends SingleChatState {
  String message;
  SingleChatErrorState(this.message, super.singleChat);
}
