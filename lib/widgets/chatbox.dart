import 'package:flutter/material.dart';

// ignore: must_be_immutable
class Chatbox extends StatelessWidget {
  String message = '';
  final TextEditingController controller;
  final FocusNode focusNode;
  final Function(String) sendmessage;
  final Function() onTap;

  Chatbox(
      {super.key,
      required this.controller,
      required this.focusNode,
      required this.onTap,
      required this.sendmessage});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 4),
        child: Container(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Color(0xffffffff),
          ),
          child: TextField(
            onTap: onTap,
            controller: controller,
            focusNode: focusNode,
            onChanged: (message) {
              this.message = message;
            },
            onSubmitted: (message) {
              sendmessage(message);
              focusNode.requestFocus();
            },
            style: const TextStyle(color: Colors.black),
            decoration: InputDecoration(
              suffix: IconButton(
                icon: const Icon(
                  Icons.send,
                  color: Colors.white,
                ),
                onPressed: () {
                  sendmessage(message);
                },
              ),
              hintText: "message",
              hintStyle: TextStyle(color: Colors.purple[200]),
              border: OutlineInputBorder(
                borderSide: const BorderSide(color: Colors.white, width: 1),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ));
  }
}
