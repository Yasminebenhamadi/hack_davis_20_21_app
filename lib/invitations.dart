import 'package:flutter/material.dart';

class Invitations extends StatefulWidget {
  @override
  _InvitationsState createState() => _InvitationsState();
}

class _InvitationsState extends State<Invitations> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
  Future<void> acceptInvitation() async{
    //todo
    await deleteInvitation();
  }
  Future<void> deleteInvitation() async{
    //todo
  }
}
