import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class MyTextfield extends StatelessWidget {
  final controller;
  final String hintText;
  final bool obscureText;

  const MyTextfield(
      {super.key,
      required this.controller,
      required this.hintText,
      required this.obscureText});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          // Border color at the time of seeing
          enabledBorder: const OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black),
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          // Border color at the time of focused
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: HexColor("#0066FF")),
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          // fillColor: Colors.grey,
          // filled: true,
          labelText: hintText,
        ),
      ),
    );
  }
}
