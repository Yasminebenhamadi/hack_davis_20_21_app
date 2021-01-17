import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

const kInputTextFieldDecoration = InputDecoration( //specify how the input text look like
  hintText: 'Enter your email',
  contentPadding://padding of the inout text
  EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  border: OutlineInputBorder( //outline of the border
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  enabledBorder: OutlineInputBorder( //border outline when the app start
    borderSide: BorderSide(color: Colors.blueAccent, width: 1.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),
  focusedBorder: OutlineInputBorder(//border outline when the input is chosen
    borderSide: BorderSide(color: Colors.blueAccent, width: 2.0),
    borderRadius: BorderRadius.all(Radius.circular(32.0)),
  ),

);