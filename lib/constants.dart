import 'package:flutter/material.dart';

var kButtonColor = Color(0xFFFD93D5);
var kBackgroundColor = Color(0xFF0F123F);

const kTextFieldDecoration = InputDecoration(
  hintText: 'Enter input',
  hintStyle: TextStyle(color: Colors.grey),
  filled: true,
  fillColor: Colors.white,
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xFF0F123F), width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color: Color(0xCFFD93D5), width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
);