import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hackdavis2021app/classes/user.dart';

class UsersList extends StatefulWidget {
  final User currentUser;
  UsersList({this.currentUser});
  @override
  _UsersListState createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  User _user;
  String selectedHobby;
  List<String> _hobbies;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  @override
  void initState() {
    super.initState();
    _user = widget.currentUser;
    //TODO _hobbies = _user.hobbies;
    _hobbies = [
      '1','2','3'
    ];
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Find Connections'),
      ),
      body: Column(
        children: [
          Container(
            child: DropdownButton<String>(
              icon: Icon(Icons.arrow_drop_down),
              hint: Text('Choose a hobby'),
              value: selectedHobby,
              onChanged: (newValue){
                setState(() {
                  selectedHobby = newValue;
                });
              },
              items: _hobbies.map((valueItem){
                return DropdownMenuItem<String>(
                    value: valueItem,
                    child: Text(valueItem),
                );
              }).toList(),
              
            ),
          ),
          StreamBuilder<List<User>>(
              stream: selectedHobby.isNotEmpty ? _firestore.collection('Users').where('Hobbies',arrayContains: selectedHobby).snapshots().map((event) {
                List<User> users = List<User>();
                event.docs.forEach((document){
                  users.add(User.fromMap(document.data()));
                });
                return users;
              }) : _firestore.collection('Users').where('Hobbies',arrayContains: selectedHobby).snapshots().map((event) {
                List<User> users = List<User>();
                event.docs.forEach((document){
                  users.add(User.fromMap(document.data()));
                });
                return users;
              }),
              builder: (buildContext,asyncSnapShot){
                if(asyncSnapShot.hasError)
                  return null;
                else if (!asyncSnapShot.hasData)
                  return null;
                else {
                  List<User> users = asyncSnapShot.data;
                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (buildContext,int){
                      return _displayUserWidget(users[int]);
                    },
                  );
                }
              },
          ),
        ],
      ),

    );
  }
  Widget _displayUserWidget (User user){
    return Row(
      children: [
        Text(user.name),
        IconButton(
            icon: Icon(Icons.arrow_forward),
            onPressed: (){
              //todo
            }
        ),
      ],
    );
  }
}
