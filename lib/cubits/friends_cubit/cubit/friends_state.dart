part of 'friends_cubit.dart';

class FriendsState {
  final List<Users>? friends;
  final bool isLoading;
  final String? error;

  FriendsState({this.friends, this.isLoading = false, this.error});
}