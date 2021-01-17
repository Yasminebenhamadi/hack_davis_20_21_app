import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:developer';

class HobbyScreen extends StatefulWidget {

  static const String id = "HobbyScreen";
  @override
  _HobbyScreenState createState() => _HobbyScreenState();
}


class _HobbyScreenState extends State<HobbyScreen> {

  final FirebaseAuth _auth = FirebaseAuth.instance;
  User loggedInUser; //instance of firebase user

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    log("data: $_auth");

    //getCurrUser();
    loggedInUser =  _auth.currentUser;

  }



  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("current User: " + loggedInUser.email),
    );
  }
}
