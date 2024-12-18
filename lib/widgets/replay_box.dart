// ignore: file_names
import 'package:chatapp/modes/message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ReplayBox extends StatelessWidget {
  final String receiver;
  final Message replaymessage;
  final void Function() exit;
  const ReplayBox(
      {super.key,
      required this.receiver,
      required this.replaymessage,
      required this.exit});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      (replaymessage.senderName ==
                              FirebaseAuth.instance.currentUser!.displayName)
                          ? 'you'
                          : replaymessage.senderName,
                      style: const TextStyle(
                        color: Color.fromARGB(255, 57, 23, 23),
                      ),
                    ),
                    Text(replaymessage.message),
                  ],
                ),
                trailing: IconButton(
                  onPressed: exit,
                  icon: const Icon(
                    Icons.cancel,
                    color: Colors.black,
                  ),
                )),
          ]),
    );
  }
}
