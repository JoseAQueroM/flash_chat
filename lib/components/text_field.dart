import 'package:flutter/material.dart';

class TextFieldInputs extends StatelessWidget {
  TextFieldInputs({
    required this.textInput,
    required this.onChanged,
    required this.isPassword,
  });

  final String textInput;
  final ValueChanged<String> onChanged;
  final bool isPassword;

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      obscureText: isPassword,
      decoration: InputDecoration(
        hintText: textInput,
        contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
      ),
    );
  }
}
