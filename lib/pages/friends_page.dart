import 'package:chatapp/cubits/friends_cubit/cubit/friends_cubit.dart';
import 'package:chatapp/cubits/login_cubit/login_cubit.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:chatapp/widgets/friend_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class FriendsPage extends StatelessWidget {
  const FriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FriendsCubit(ChatServices())..fetchFriends(),
      child: const FriendsView(),
    );
  }
}

class FriendsView extends StatelessWidget {
  const FriendsView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginCubit, LoginState>(
      listener: (context, state) {
        if (state is LoginInitial) {
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xe4e4e4e4),
          appBar: AppBar(
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.logout,
                  color: Colors.white,
                ),
                onPressed: () {
                  BlocProvider.of<LoginCubit>(context).logout();
                },
              )
            ],
            automaticallyImplyLeading: false,
            backgroundColor: const Color(0xff8642e3),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  ('lib/assets/images/scholar.png'),
                  scale: 2,
                ),
                const Text(
                  'Chat',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            centerTitle: true,
          ),
          body: BlocBuilder<FriendsCubit, FriendsState>(
            builder: (context, state) {
              if (state.isLoading) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        ('lib/assets/images/scholar.png'),
                        scale: .5,
                      ),
                      const CircularProgressIndicator(),
                    ],
                  ),
                );
              } else if (state.error != null) {
                return Center(child: Text('Error: ${state.error}'));
              } else if (state.friends == null || state.friends!.isEmpty) {
                return const Center(child: Text('No friends found.'));
              } else {
                return ListView.builder(
                  itemCount: state.friends!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return FriendBox(
                      reciver: state.friends![index],
                    );
                  },
                );
              }
            },
          ),
        );
      },
    );
  }
}
