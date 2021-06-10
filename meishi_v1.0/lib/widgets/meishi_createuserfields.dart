import 'package:flutter/material.dart';

class AppUserTextEmailField extends StatelessWidget {
  final String inputText;
  final ValueChanged<String> onSaved;
  final bool obscureText;
  final TextEditingController controller;
  final FocusNode focusNode;
  final FormFieldValidator<String> validator;
  final bool autoValidate;

  const AppUserTextEmailField(
      {this.inputText,
      this.onSaved,
      this.obscureText,
      this.controller,
      this.focusNode,
      this.validator,
      this.autoValidate});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidate: autoValidate,
      validator: validator,
      focusNode: focusNode,
      controller: controller,
      style: TextStyle(
        color: Colors.white,
        fontSize: 15,
      ),
      decoration: InputDecoration(
        hintText: inputText,
        contentPadding: const EdgeInsets.all(8),
        fillColor: const Color(0xff1c2c34),
        filled: true,
        hintStyle: TextStyle(
          color: const Color(0xff657885),
          fontSize: 15,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
      ),
      onSaved: onSaved,
      textAlign: TextAlign.start,
      obscureText: obscureText == null ? false : true,
    );
  }
}
