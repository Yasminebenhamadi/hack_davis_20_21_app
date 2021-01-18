import 'package:flutter/material.dart';
import 'classes/user.dart';

class UserProfile extends StatefulWidget {
  final User user;
  UserProfile({this.user});
  @override
  _UserProfileState createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  User _user;
  @override
  void initState() {
    super.initState();
    _user = widget.user;
  }
  @override
  Widget build(BuildContext context) {
    return Container(

    );
  }
  Future<void> Connect (){
    //todo send invitation
  }
}
