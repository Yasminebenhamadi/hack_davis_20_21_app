import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
    getCurrUser();
  }

  void getCurrUser() async
  {
    try {
      //final User user = await _auth.currentUser;
      loggedInUser = await _auth.currentUser;

    } catch (e) {print(e);}
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text("current User: " + loggedInUser.email),
    );
  }
}
