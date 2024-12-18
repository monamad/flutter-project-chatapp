import 'package:chatapp/cubits/chat_cubit/chat_cubit.dart';
import 'package:chatapp/cubits/chat_cubit/chat_state.dart';
import 'package:chatapp/modes/user.dart';
import 'package:chatapp/services/chat/chat_services.dart';
import 'package:chatapp/widgets/chatbox.dart';
import 'package:chatapp/widgets/private_chat_message_bubble.dart';
import 'package:chatapp/widgets/replay_box.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChatPage extends StatelessWidget {
  final Users receiver;

  const ChatPage({super.key, required this.receiver});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ChatCubit(chatServices: ChatServices(), receiver: receiver)
            ..loadMessages(),
      child: const ChatView(),
    );
  }
}

class ChatView extends StatefulWidget {
  const ChatView({super.key});

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  final TextEditingController textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
  _scrollToBottom( );
  }

  @override
  void dispose() {
    textController.dispose();
    _focusNode.dispose();
    _scrollController.dispose();
    super.dispose();
  }



  void _scrollToBottom({bool animated = true}) {
  if (_scrollController.hasClients) {
    if (animated) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    } else {
      _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
    }
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffe4e4e4),
      appBar: AppBar(
        backgroundColor: const Color(0xff8642e3),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset('lib/assets/images/scholar.png', scale: 2),
            Text(
              context.read<ChatCubit>().receiver.name,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: BlocConsumer<ChatCubit, ChatState>(
  listener: (context, state) {
    if (state is ChatLoaded) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollToBottom(animated: false); // Scroll to the last message
      });
    }
  },
  builder: (context, state) {
    if (state is ChatLoading) {
      return const Center(child: CircularProgressIndicator());
    } else if (state is ChatLoaded) {
      return Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final message = state.messages[index];
                return GestureDetector(
                  onLongPress: () {
                    context.read<ChatCubit>().setReplayMessage(message);
                    _focusNode.requestFocus();
                  },
                  child: PrivateMessageBubble(message),
                );
              },
            ),
          ),
          if (state.replayMessage != null)
            ReplayBox(
              receiver: context.read<ChatCubit>().receiver.name,
              replaymessage: state.replayMessage!,
              exit: () {
                context.read<ChatCubit>().clearReplay();
                _focusNode.unfocus();
              },
            ),
          Chatbox(
            controller: textController,
            focusNode: _focusNode,
            sendmessage: (m) {
              context.read<ChatCubit>().sendMessage(textController.text);
              textController.clear();
              _scrollToBottom();
            },
            onTap: () {
              _scrollToBottom(animated: true);
            },
          ),
        ],
      );
    } else if (state is ChatError) {
      return Center(child: Text(state.message));
    }
    return const SizedBox();
        },
      ),
    );
  }
}
