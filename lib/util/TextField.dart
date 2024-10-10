import 'package:flutter/material.dart';

class Textfield extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  TextInputType keyboardType;
  Textfield({super.key, required this.controller, required this.hintText,required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        hintText: hintText,
        fillColor: Colors.grey[300],
        filled: true,
        border: new OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
