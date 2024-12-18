import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatapp/modes/user.dart';
import 'package:chatapp/services/chat/chat_services.dart';
part 'friends_state.dart';


class FriendsCubit extends Cubit<FriendsState> {
  final ChatServices chatServices;

  FriendsCubit(this.chatServices) : super(FriendsState(isLoading: true));

  Future<void> fetchFriends() async {
    emit(FriendsState(isLoading: true));
    try {
      final friends = await chatServices.getFriends();
      emit(FriendsState(friends: friends, isLoading: false));
    } catch (e) {
      emit(FriendsState(error: e.toString(), isLoading: false));
    }
  }
}
