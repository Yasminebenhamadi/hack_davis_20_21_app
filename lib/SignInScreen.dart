import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hackdavis2021app/utilities/constants.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import 'HobbiesScreen.dart';
import 'HobbiesScreen.dart';
import 'RegistrationScreen.dart';
import 'customWidget/CustomButton.dart';
import 'utilities/constants.dart';

class SignInScreen extends StatefulWidget {
  static const String id = "SignInScreen";

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool showSpinner = false;
  bool showPassword = true;
  final _auth = FirebaseAuth.instance;
  TextEditingController _emailcontroller = TextEditingController();
  TextEditingController _passwordcontroller = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // String email;
  // String password;

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
                    text: ['Sign In'],
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
                sigInbtn(),
                SizedBox(
                  height: 20,
                ),
                RichText(
                  text: TextSpan(children: <TextSpan>[
                    TextSpan(
                        text: 'Don\'t have a account? ',
                        style: TextStyle(color: Colors.black)),
                    TextSpan(
                        text: 'Create one',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushReplacementNamed(
                                context, RegistrationScreen.id);
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

  sigInbtn() {
    return CustomButton(
      text: "Sign In",
      color: Colors.yellow,
      onPressed: () async {
        FocusScope.of(context).unfocus();

        if (_formKey.currentState.validate()) {
          String email = _emailcontroller.text.trim();
          String password = _passwordcontroller.text.trim();
          try {
            UserCredential user = await _auth.signInWithEmailAndPassword(
                email: email, password: password);
            if (user != null) {
              Navigator.pushReplacementNamed(context, HobbyScreen.id);
            }
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
          print('Invalid form');
        }
      },
    );
  }
}
