import 'package:bloc/bloc.dart';
import 'package:chatapp/cubits/chat_cubit/chat_state.dart';
import 'package:chatapp/modes/message.dart';
import 'package:chatapp/modes/user.dart';
import 'package:chatapp/services/chat/chat_services.dart';

class ChatCubit extends Cubit<ChatState> {
  final ChatServices chatServices;
  final Users receiver;
  Message? replayMessage;

  ChatCubit({required this.chatServices, required this.receiver})
      : super(ChatInitial());

  String smailString(String s1, String s2) {
    int len = s1.length < s2.length ? s1.length : s2.length;

    for (int i = 0; i < len; i++) {
      if (s1.codeUnitAt(i) > s2.codeUnitAt(i)) {
        return s1 + s2;
      } else if (s1.codeUnitAt(i) < s2.codeUnitAt(i)) {
        return s2 + s1;
      }
    }
    return s1.length == len ? s1 + s2 : s2 + s1;
  }
  
  
  
  
  
  
  
  void loadMessages() async {
    emit(ChatLoading());
    try {
      // Load initial chat messages
      chatServices.getChat(receiver).listen((snapshot) {
        final messages = snapshot.docs
            .map((doc) => Message.get(doc.data() as Map<String, dynamic>))
            .toList();
        emit(ChatLoaded(messages: messages, replayMessage: replayMessage));
      });
    } catch (e) {
      emit(ChatError('Failed to load messages'));
    }
  }

  void sendMessage(String text) {
    if (text.isNotEmpty) {
      chatServices.sendMessage(text, receiver, replayMessage?.message);
      clearReplay();
    }
  }

  void setReplayMessage(Message message) {
    replayMessage = message;
    if (state is ChatLoaded) {
      emit(ChatLoaded(
          messages: (state as ChatLoaded).messages, replayMessage: message));
    }
  }

  void clearReplay() {
    replayMessage = null;
    if (state is ChatLoaded) {
      emit(ChatLoaded(
          messages: (state as ChatLoaded).messages, replayMessage: null));
    }
  }
}
