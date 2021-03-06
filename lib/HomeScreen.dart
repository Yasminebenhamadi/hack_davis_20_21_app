import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'SignInScreen.dart';
import 'customWidget/CustomButton.dart';
import 'package:hackdavis2021app/RegistrationScreen.dart';

class HomeScreen extends StatefulWidget {


  static const String id = "HomeScreen";

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[

            Row(
              children: <Widget>[

                Hero(
                  tag: "hero1",
                  child: TypewriterAnimatedTextKit(
                    text: ['The Mavenclaws App'],
                    textStyle: TextStyle(
                      color: Colors.black,
                      fontSize: 24.0,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 12.0,
            ),
            CustomButton(
                text: "Log in",
                color: Colors.blue,
                onPressed: () {
                  Navigator.pushNamed(context, SignInScreen.id);
                  } //with /first being the key name of the route
            ),
            CustomButton(
              text: "Register",
              color: Colors.yellow,
              onPressed: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
