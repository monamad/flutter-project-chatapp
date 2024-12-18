import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomFormTextField extends StatelessWidget {
  final String hint;
  final bool isPassword;
  Function(String) ontap;
  bool? notconfirmedpass;
  final TextEditingController myController;
  CustomFormTextField(
      {super.key,
      required this.hint,
      required this.myController,
      required this.ontap,
      required this.isPassword,
     });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(3.0),
      child: TextFormField(
        scrollPadding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 12 * 4),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'this field is required';
          }
          if (isPassword) {
            if (value.length < 6) {
              return 'password must be at least 6 characters';
            }
          }
          return null;
        },
        controller: myController,
        onChanged: ontap,
        obscureText: isPassword,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white),
            border: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.white, width: 1),
              borderRadius: BorderRadius.circular(12),
            )),
      ),
    );
  }
}
