import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:hackdavis2021app/utilities/constants.dart';

import 'HobbiesScreen.dart';
import 'HobbiesScreen.dart';
import 'SignInScreen.dart';
import 'customWidget/CustomButton.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = "RegistrationScreen";
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showSpinner = false;
  bool showPassword = true;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Hero(
                  tag: "hero1",
                  child: TypewriterAnimatedTextKit(
                    text: ['Register'],
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                SizedBox(
                  height: 48.0,
                ),
                TextFormField(
                  controller: _namecontroller,
                  textAlign: TextAlign.start,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter your name";
                    return null;
                  },
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Enter your name'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _emailcontroller,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.isEmpty) return "Please enter an email";
                    if (!value.contains('@'))
                      return "Please enter a valid email";
                    return null;
                  },
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Enter your email'),
                ),
                SizedBox(
                  height: 8.0,
                ),
                TextFormField(
                  controller: _passwordcontroller,
                  textAlign: TextAlign.start,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value.length < 6)
                      return "Enter a password atleast 6 characters long";
                    return null;
                  },
                  obscureText: showPassword,
                  decoration: kInputTextFieldDecoration.copyWith(
                      hintText: 'Enter your password',
                      suffixIcon: IconButton(
                          icon: Icon(Icons.remove_red_eye),
                          onPressed: () {
                            setState(() {
                              showPassword = !showPassword;
                            });
                          })),
                ),
                SizedBox(
                  height: 24.0,
                ),
                registerbtn(),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'Sign In',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, SignInScreen.id);
                          }),
                  ]),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  registerbtn() {
    return CustomButton(
      text: "Register",
      color: Colors.lightBlue,
      onPressed: () async {
        FocusScope.of(context).unfocus();
        if (_formKey.currentState.validate()) {
          String name = _namecontroller.text.trim();
          String email = _emailcontroller.text.trim();
          String password = _passwordcontroller.text.trim();
          try {
            await _auth
                .createUserWithEmailAndPassword(
                    email: email, password: password)
                .then((value) async {
              print('adding user ${value.user.uid} to firestore.');
              await _firestore.collection('Users').doc(value.user.uid).set({
                'name': name,
                'email': email,
                'uid': value.user.uid,
              });
              print('added user to firestore.');
            });
            Navigator.pushReplacementNamed(context, HobbyScreen.id);
          } catch (e) {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('ERROR'),
                  content: Text(e.message.toString()),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    )
                  ],
                );
              },
            );
          }
        } else {
          print('Invalid form.');
        }
      },
    );
  }
}
